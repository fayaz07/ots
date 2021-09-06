library ots;

import 'dart:io' show InternetAddress, Platform, SocketException;

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ots/toast/colors.dart';
import 'package:ots/toast/text_styles.dart';
import 'package:ots/toast/types.dart';
import 'package:ots/toast/widgets/error.dart';
import 'package:ots/toast/widgets/info.dart';
import 'package:ots/toast/widgets/normal.dart';
import 'package:ots/toast/widgets/success.dart';
import 'package:ots/toast/widgets/warning.dart';
import 'package:ots/widgets/network_state.dart';

import 'widgets/notification.dart';

export 'toast/types.dart';

/// This will be used as a key for getting the [context] of [OTS] widget
/// which is used for inserting the [OverlayEntry] into an [Overlay] widget
final _tKey = GlobalKey(debugLabel: 'overlay_parent');
final _modalBarrierDefaultColor = Colors.grey.withOpacity(0.15);

/// Updates with the latest [OverlayEntry] child
OverlayEntry? _notificationEntry;
OverlayEntry? _loaderEntry;
OverlayEntry? _networkStatusEntry;
OverlayEntry? _toastEntry;

/// is dark theme
bool isDarkTheme = false;

/// To keep track if the [Overlay] is shown
bool _notificationShown = false;
bool _loaderShown = false;
bool _networkShown = false;
bool _toastShown = false;
bool _persistNoInternetToast = false;

bool _showDebugLogs = true;

Widget? _loadingIndicator;

class OTS extends StatelessWidget {
  final Widget? child;
  final Widget? loader;
  final bool showNetworkUpdates;
  final bool persistNoInternetNotification;
  final bool darkTheme;
  final String? connectivityCheckAddress;
  final double bottomInternetNotificationPadding;

  const OTS(
      {Key? key,
      this.child,
      this.loader,
      this.showNetworkUpdates = false,
      this.persistNoInternetNotification = false,
      this.darkTheme = false,
      this.connectivityCheckAddress,
      this.bottomInternetNotificationPadding = 0.0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    _loadingIndicator = loader;
    isDarkTheme = darkTheme;
    _persistNoInternetToast = persistNoInternetNotification;
    if (showNetworkUpdates) {
      _listenToNetworkChanges(bottomInternetNotificationPadding,
          connectivityCheckAddress: connectivityCheckAddress);
    }
    return SizedBox(
      key: _tKey,
      child: child,
    );
  }
}

OverlayState? get _overlayState {
  final context = _tKey.currentContext;
  if (context == null) return null;

  NavigatorState? navigator;
  void visitor(Element element) {
    if (navigator != null) return;

    if (element.widget is Navigator) {
      navigator = (element as StatefulElement).state as NavigatorState?;
    } else {
      element.visitChildElements(visitor);
    }
  }

  context.visitChildElements(visitor);

  assert(navigator != null,
      '''Cannot find OTS above the widget tree, unable to show overlay''');
  return navigator!.overlay;
}

/// handling Internet Connectivity changes
void _listenToNetworkChanges(bottomPadding,
    {String? connectivityCheckAddress}) async {
  Connectivity().onConnectivityChanged.listen((event) {
    switch (event) {
      case ConnectivityResult.wifi:
        _checkInternetConnectionAndShowStatus(bottomPadding,
            connectivityCheckAddress: connectivityCheckAddress);
        break;
      case ConnectivityResult.mobile:
        _checkInternetConnectionAndShowStatus(bottomPadding,
            connectivityCheckAddress: connectivityCheckAddress);
        break;
      case ConnectivityResult.none:
        _showNetworkStateWidget(NetworkState.Disconnected, bottomPadding);
        break;
    }
  });
}

_checkInternetConnectionAndShowStatus(double bottomPadding,
    {String? connectivityCheckAddress}) async {
  try {
    final result =
        await InternetAddress.lookup(connectivityCheckAddress ?? 'google.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      _showNetworkStateWidget(NetworkState.Connected, bottomPadding);
    }
  } on SocketException catch (_) {
    _showNetworkStateWidget(NetworkState.Weak, bottomPadding);
  }
}

Future<void> _showNetworkStateWidget(
    NetworkState state, double bottomPadding) async {
  try {
    final child = Positioned(
      bottom: bottomPadding,
      left: 0.0,
      right: 0.0,
      height: 30.0,
      child: NetworkWidget(
        disposeOverlay: _hideNetworkStateWidget,
        state: state,
        persistNotification: _persistNoInternetToast,
      ),
    );
    _printLog("Network change: " + state.message);
    if (_OverlayType.NetworkStatus.isShowing()) {
      _printLog("An internet overlay is being currently shown, "
          "hiding it before showing new overlay");
      await _hideNetworkStateWidget();
    }

    await _showOverlay(child: child, type: _OverlayType.NetworkStatus);
  } catch (err) {
    _printError(
        '''Caught an exception while trying to show NetworkStatusWidget''');
    throw err;
  }
}

Future<void> _hideNetworkStateWidget() async {
  try {
    _printLog('''Hiding loader network status''');
    await _hideOverlay(_OverlayType.NetworkStatus);
  } catch (err) {
    _printError(
        '''Caught an exception while trying to hide NetworkStatusWidget''');
    throw err;
  }
}

/// To handle a loader for the application
Future<void> showLoader(
    {bool isModal = false,
    Color? modalColor,
    bool modalDismissible = true}) async {
  try {
    _printLog('''Showing loader as Overlay''');
    final _child = Center(
      child: _loadingIndicator ??
          (Platform.isAndroid
              ? CircularProgressIndicator()
              : CupertinoActivityIndicator()),
    );
    await _showOverlay(
      child: isModal
          ? Stack(
              children: <Widget>[
                ModalBarrier(
                  color: modalColor ?? _modalBarrierDefaultColor,
                  dismissible: modalDismissible,
                ),
                _child
              ],
            )
          : _child,
      type: _OverlayType.Loader,
    );
  } catch (err) {
    debugPrint(
        '''Caught an exception while trying to show a Loader\n${err.toString()}''');
    throw err;
  }
}

Future<void> hideLoader() async {
  try {
    _printLog('''Hiding loader overlay''');
    await _hideOverlay(_OverlayType.Loader);
  } catch (err) {
    _printError('''Caught an exception while trying to hide loader''');
    throw err;
  }
}

/// This method can be used by the client to show a Notification as an overlay
Future<NotificationWidgetState> showNotification(
    {String? title,
    required String message,
    TextStyle? messageStyle,
    TextStyle? titleStyle,
    Color? backgroundColor,
    int? notificationDuration,
    int? animDuration,
    bool? autoDismissible}) async {
  /// Throws an error if message is null
  assert(message != null, '''Notification message cannot be null''');

  try {
    final instance = NotificationWidget(
      disposeOverlay: hideNotification,
      backgroundColor: backgroundColor,
      message: message,
      title: title,
      messageStyle: messageStyle,
      titleStyle: titleStyle,
      autoDismissible: autoDismissible,
      duration: notificationDuration,
      animDuration: animDuration,
    );

    final child = Positioned(
      left: 8.0,
      right: 8.0,
      child: instance,
    );

    _printLog('''Showing Notification overlay''');

    await _showOverlay(child: child, type: _OverlayType.Notification);
    return instance.get();
  } catch (err) {
    _printError('''Caught an exception while trying to show Notification''');
    throw err;
  }
}

Future<void> hideNotification() async {
  try {
    _printLog('''Hiding Notification overlay''');
    await _hideOverlay(_OverlayType.Notification);
  } catch (err) {
    _printError('''Caught an exception while trying to hide Notification''');
    throw err;
  }
}

///----------------------------------Toasts------------------------------------
Future<void> bakeToast(String message,
    {Color? backgroundColor,
    TextStyle? textStyle,
    ToastType type = ToastType.normal}) async {
  try {
    Widget? _toast;
    switch (type) {
      case ToastType.normal:
        _toast = DefaultToast(
            backgroundColor: backgroundColor ?? ToastColors.defaultToastBGColor,
            textStyle: textStyle ?? ToastTextStyle.defaultTextStyle,
            message: message,
            onToasted: _hideToast);
        break;
      case ToastType.info:
        _toast = InfoToast(
            backgroundColor: backgroundColor ?? ToastColors.infoToastBGColor,
            textStyle: textStyle ?? ToastTextStyle.defaultTextStyle,
            message: message,
            onToasted: _hideToast);
        break;
      case ToastType.success:
        _toast = SuccessToast(
            backgroundColor: backgroundColor ?? ToastColors.successToastBGColor,
            textStyle: textStyle ?? ToastTextStyle.defaultTextStyle,
            message: message,
            onToasted: _hideToast);
        break;
      case ToastType.error:
        _toast = ErrorToast(
            backgroundColor: backgroundColor ?? ToastColors.errorToastBGColor,
            textStyle: textStyle ?? ToastTextStyle.defaultTextStyle,
            message: message,
            onToasted: _hideToast);
        break;
      case ToastType.warning:
        _toast = WarningToast(
            backgroundColor: backgroundColor ?? ToastColors.warningToastBGColor,
            textStyle: textStyle ?? ToastTextStyle.defaultTextStyle,
            message: message,
            onToasted: _hideToast);
        break;
    }

    final child = Positioned(
      left: 8.0,
      right: 8.0,
      bottom: 72.0,
      child: Center(
        child: _toast,
      ),
    );

    _printLog('''Showing Toast overlay''');

    await _showOverlay(child: child, type: _OverlayType.Toast);
  } catch (err) {
    _printError('''Caught an exception while trying to show Toast''');
    throw err;
  }
}

Future<void> _hideToast() async {
  try {
    _printLog('''Hiding Toast overlay''');
    await _hideOverlay(_OverlayType.Toast);
  } catch (err) {
    _printError('''Caught an exception while trying to hide Toast''');
    throw err;
  }
}

///--------------------------------End Toast-----------------------------------

///----------------------------------------------------------------------------
/// These methods deal with showing and hiding the overlay
Future<void> _showOverlay({required Widget child, _OverlayType? type}) async {
  try {
    final overlay = _overlayState;

    if (type.isShowing()) {
      _printLog('''An overlay of ${type.name()} is already showing''');
      return Future.value(false);
    }

//    try {
//      if (_overlayShown) hideOverlay();
//    } catch (err) {
//      print(err);
//    }

    final overlayEntry = OverlayEntry(
      builder: (context) => child,
    );

    overlay!.insert(overlayEntry);
    type.setOverlayEntry(overlayEntry);
    type.setShowing();
  } catch (err) {
    _printError(
        '''Caught an exception while trying to insert Overlay\n${err.toString()}''');
    throw err;
  }
}

Future<void> _hideOverlay(_OverlayType type) async {
  try {
    if (type.isShowing()) {
      type.getOverlayEntry()!.remove();
      type.hide();
    } else {
      _printLog('No overlay is shown');
    }
  } catch (err) {
    _printError(
        '''Caught an exception while trying to remove Overlay\n${err.toString()}''');
    throw err;
  }
}

void _printLog(String log) {
  if (_showDebugLogs) debugPrint(log);
}

void _printError(String log) {
  debugPrint(log);
}

/// ----------------------------- end overlay methods --------------------------
enum _OverlayType {
  Notification,
  Loader,
  NetworkStatus,
  Toast,
}

extension OverlayTypeExtension on _OverlayType? {
  String name() {
    switch (this) {
      case _OverlayType.Notification:
        return "Notification";
      case _OverlayType.Loader:
        return "Loader";
      case _OverlayType.NetworkStatus:
        return "NetworkStatus";
      case _OverlayType.Toast:
        return "Toast";
    }
    return "Overlay";
  }

  bool isShowing() {
    switch (this) {
      case _OverlayType.Notification:
        return _notificationShown;
      case _OverlayType.Loader:
        return _loaderShown;
      case _OverlayType.NetworkStatus:
        return _networkShown;
      case _OverlayType.Toast:
        return _toastShown;
    }
    return false;
  }

  void setShowing() {
    switch (this) {
      case _OverlayType.Notification:
        _notificationShown = true;
        break;
      case _OverlayType.Loader:
        _loaderShown = true;
        break;
      case _OverlayType.NetworkStatus:
        _networkShown = true;
        break;
      case _OverlayType.Toast:
        _toastShown = true;
        break;
    }
  }

  void hide() {
    switch (this) {
      case _OverlayType.Notification:
        _notificationShown = false;
        break;
      case _OverlayType.Loader:
        _loaderShown = false;
        break;
      case _OverlayType.NetworkStatus:
        _networkShown = false;
        break;
      case _OverlayType.Toast:
        _toastShown = false;
        break;
    }
  }

  OverlayEntry? getOverlayEntry() {
    switch (this) {
      case _OverlayType.Notification:
        return _notificationEntry;
      case _OverlayType.Loader:
        return _loaderEntry;
      case _OverlayType.NetworkStatus:
        return _networkStatusEntry;
      case _OverlayType.Toast:
        return _toastEntry;
    }
    return null;
  }

  void setOverlayEntry(OverlayEntry entry) {
    switch (this) {
      case _OverlayType.Notification:
        _notificationEntry = entry;
        break;
      case _OverlayType.Loader:
        _loaderEntry = entry;
        break;
      case _OverlayType.NetworkStatus:
        _networkStatusEntry = entry;
        break;
      case _OverlayType.Toast:
        _toastEntry = entry;
        break;
    }
  }
}
