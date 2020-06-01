library ots;

import 'dart:io' show Platform;
import 'package:flutter/cupertino.dart' show CupertinoActivityIndicator;
import 'package:flutter/material.dart' show CircularProgressIndicator, Colors;
import 'package:flutter/widgets.dart'
    show
        GlobalKey,
        OverlayEntry,
        Overlay,
        required,
        StatelessWidget,
        debugPrint,
        VoidCallback,
        Positioned,
        TextStyle,
        Color,
        Widget,
        SizedBox,
        Key,
        BuildContext,
        Center,
        Stack,
        ModalBarrier;
import 'package:ots/widgets/network_state.dart';
import 'widgets/notification.dart';
import 'package:connectivity/connectivity.dart';

/// This will be used as a key for getting the [context] of [OTS] widget
/// which is used for inserting the [OverlayEntry] into an [Overlay] widget
final _tKey = GlobalKey(debugLabel: 'overlay_parent');
final _modalBarrierDefaultColor = Colors.grey.withOpacity(0.15);

/// Updates with the latest [OverlayEntry] child
OverlayEntry _overlayEntry;

/// To keep track if the [Overlay] is shown
bool _overlayShown = false;

Widget _loader;

class OTS extends StatelessWidget {
  final Widget child;
  final Widget loader;
  final bool showNetworkUpdates;

  const OTS({Key key, this.child, this.loader, this.showNetworkUpdates})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    _loader = loader;
    if (showNetworkUpdates) {
      _listenToNetworkChanges();
    }
    return SizedBox(
      key: _tKey,
      child: child,
    );
  }
}

/// handling Internet Connectivity changes
void _listenToNetworkChanges() async {
  Connectivity().onConnectivityChanged.listen((event) {
    switch (event) {
      case ConnectivityResult.wifi:
        _showNetworkStateWidget(NetworkState.Connected);
        break;
      case ConnectivityResult.mobile:
        _showNetworkStateWidget(NetworkState.Connected);
        break;
      case ConnectivityResult.none:
        _showNetworkStateWidget(NetworkState.Disconnected);
        break;
    }
  });
}

_showNetworkStateWidget(NetworkState state) {
  try {
    final child = Positioned(
      bottom: 0.0,
      left: 0.0,
      right: 0.0,
      height: 30.0,
      child: NetworkWidget(
        disposeOverlay: _hideOverlay,
        state: state,
      ),
    );

    try {
      if (_overlayShown) _hideOverlay();
    } catch (err) {
      // print(err);
    }

    _showOverlay(child: child);
  } catch (err) {
    debugPrint(err.toString());
  }
}

/// To handle a loader for the application
Future<bool> showLoader({bool isModal = false, Color modalColor}) async {
  try {
    final _loadingIndicator = Center(
      child: _loader ??
          (Platform.isAndroid
              ? CircularProgressIndicator()
              : CupertinoActivityIndicator()),
    );
    return await _showOverlay(
        child: isModal
            ? Stack(
                children: <Widget>[
                  ModalBarrier(
                    color: modalColor ?? _modalBarrierDefaultColor,
                  ),
                  _loadingIndicator
                ],
              )
            : _loadingIndicator);
  } catch (err) {
    debugPrint(
        '''Caught an exception while trying to show a Loader\n${err.toString()}''');
    return Future.value(false);
  }
}

Future<bool> hideLoader() async {
  try {
    return await _hideOverlay();
  } catch (err) {
    debugPrint(
        '''Caught an exception while trying to hide loader\n${err.toString()}''');
    return Future.value(false);
  }
}

/// This method can be used by the client to show a Notification as an overlay
Future<bool> showNotification(
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
  assert(message != null);

  final child = Positioned(
    left: 8.0,
    right: 8.0,
    child: NotificationWidget(
      disposeOverlay: _hideOverlay,
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

  return await _showOverlay(child: child);
}

Future<bool> hideNotification() async {
  try {
    return await _hideOverlay();
  } catch (err) {
    debugPrint(
        '''Caught an exception while trying to hide Notification\n${err.toString()}''');
    return Future.value(false);
  }
}

///----------------------------------------------------------------------------
/// These methods deal with showing and hiding the overlay
Future<bool> _showOverlay({@required Widget child}) async {
  try {
    BuildContext context = _tKey.currentContext;

    if (_overlayShown) {
      debugPrint('''Another overlay is already showing''');
      return Future.value(false);
    }

//    try {
//      if (_overlayShown) hideOverlay();
//    } catch (err) {
//      // print(err);
//    }

    _overlayEntry = OverlayEntry(
      builder: (context) => child,
    );

    Overlay.of(context).insert(_overlayEntry);
    _overlayShown = true;
    debugPrint('''Overlay shown''');
    return Future.value(true);
  } catch (err) {
    debugPrint(
        '''Caught an exception while trying to insert Overlay\n${err.toString()}''');
    return Future.value(false);
  }
}

Future<bool> _hideOverlay() async {
  try {
    _overlayEntry.remove();
    _overlayShown = false;
    debugPrint('''Overlay removed''');
    return Future.value(true);
  } catch (err) {
    debugPrint(
        '''Caught an exception while trying to remove Overlay\n${err.toString()}''');
    return Future.value(false);
  }
}

/// ----------------------------- end overlay methods --------------------------
