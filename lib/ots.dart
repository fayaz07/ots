library ots;

import 'dart:io' show InternetAddress, Platform, SocketException;

import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ots/widgets/network_state.dart';

import 'widgets/notification.dart';

/// This will be used as a key for getting the [context] of [OTS] widget
/// which is used for inserting the [OverlayEntry] into an [Overlay] widget
final _tKey = GlobalKey(debugLabel: 'overlay_parent');
final _modalBarrierDefaultColor = Colors.grey.withOpacity(0.15);

/// Updates with the latest [OverlayEntry] child
OverlayEntry _notificationEntry;
OverlayEntry _loaderEntry;
OverlayEntry _networkStatusEntry;

/// is dark theme
bool isDarkTheme = false;

/// To keep track if the [Overlay] is shown
bool _notificationShown = false;
bool _loaderShown = false;
bool _networkShown = false;
bool _persistNoInternetToast = false;

bool _showDebugLogs = false;

Widget _loadingIndicator;

class OTS extends StatelessWidget {
  final Widget child;
  final Widget loader;
  final bool showNetworkUpdates;
  final bool persistNoInternetNotification;
  final bool darkTheme;

  const OTS(
      {Key key,
      this.child,
      this.loader,
      this.showNetworkUpdates = false,
      this.persistNoInternetNotification = false,
      this.darkTheme = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    _loadingIndicator = loader;
    isDarkTheme = darkTheme;
    _persistNoInternetToast = persistNoInternetNotification;
    if (showNetworkUpdates) {
      _listenToNetworkChanges();
    }
    return SizedBox(
      key: _tKey,
      child: child,
    );
  }
}

OverlayState get _overlayState {
  final context = _tKey.currentContext;
  if (context == null) return null;

  NavigatorState navigator;
  void visitor(Element element) {
    if (navigator != null) return;

    if (element.widget is Navigator) {
      navigator = (element as StatefulElement).state;
    } else {
      element.visitChildElements(visitor);
    }
  }

  context.visitChildElements(visitor);

  assert(navigator != null,
      '''Cannot find OTS above the widget tree, unable to show overlay''');
  return navigator.overlay;
}

/// handling Internet Connectivity changes
void _listenToNetworkChanges() async {
  Connectivity().onConnectivityChanged.listen((event) {
    switch (event) {
      case ConnectivityResult.wifi:
        _checkInternetConnectionAndShowStatus();
        break;
      case ConnectivityResult.mobile:
        _checkInternetConnectionAndShowStatus();
        break;
      case ConnectivityResult.none:
        _showNetworkStateWidget(NetworkState.Disconnected);
        break;
    }
  });
}

_checkInternetConnectionAndShowStatus() async {
  try {
    final result = await InternetAddress.lookup('google.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      _showNetworkStateWidget(NetworkState.Connected);
    }
  } on SocketException catch (_) {
    _showNetworkStateWidget(NetworkState.Weak);
  }
}

Future<void> _showNetworkStateWidget(NetworkState state) async {
  try {
    final child = Positioned(
      bottom: 0.0,
      left: 0.0,
      right: 0.0,
      height: 30.0,
      child: NetworkWidget(
        disposeOverlay: _hideNetworkStateWidget,
        state: state,
        persistNotification: _persistNoInternetToast,
      ),
    );

    if (_OverlayType.NetworkStatus.isShowing()) {
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
Future<void> showLoader({bool isModal = false, Color modalColor}) async {
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
Future<void> showNotification(
    {String title,
    @required String message,
    TextStyle messageStyle,
    TextStyle titleStyle,
    Color backgroundColor,
    int notificationDuration,
    int animDuration,
    bool dismissOnTap,
    VoidCallback onTap,
    bool autoDismissible}) async {
  /// Throws an error if message is null
  assert(message != null, '''Notification message cannot be null''');

  try {
    final child = Positioned(
      left: 8.0,
      right: 8.0,
      child: NotificationWidget(
        disposeOverlay: hideNotification,
        backgroundColor: backgroundColor,
        message: message,
        title: title,
        messageStyle: messageStyle,
        titleStyle: titleStyle,
        autoDismissible: autoDismissible,
        duration: notificationDuration,
        onTap: onTap,
        dismissOnTap: dismissOnTap,
        animDuration: animDuration,
      ),
    );

    _printLog('''Showing Notification overlay''');

    await _showOverlay(child: child, type: _OverlayType.Notification);
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

///----------------------------------------------------------------------------
/// These methods deal with showing and hiding the overlay
Future<void> _showOverlay({@required Widget child, _OverlayType type}) async {
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

    overlay.insert(overlayEntry);
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
      type.getOverlayEntry().remove();
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
}

extension OverlayTypeExtension on _OverlayType {
  String name() {
    switch (this) {
      case _OverlayType.Notification:
        return "Notification";
      case _OverlayType.Loader:
        return "Loader";
      case _OverlayType.NetworkStatus:
        return "NetworkStatus";
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
    }
  }

  OverlayEntry getOverlayEntry() {
    switch (this) {
      case _OverlayType.Notification:
        return _notificationEntry;
      case _OverlayType.Loader:
        return _loaderEntry;
      case _OverlayType.NetworkStatus:
        return _networkStatusEntry;
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
    }
  }
}
