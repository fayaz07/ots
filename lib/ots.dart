library ots;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'widgets/notification.dart';

final _tKey = GlobalKey(debugLabel: 'overlay_parent');

OverlayEntry _overlayEntry;
bool _overlayShown = false;

Future<bool> showNotification(
    {String title = "Notification",
    @required String message,
    TextStyle messageStyle,
    TextStyle titleStyle,
    Color backgroundColor,
    int notificationDuration,
    int animDuration,
    bool dismissOnTap,
    VoidCallback onTap,
    bool autoDismissible}) {
  assert(message != null);
  if (_overlayShown) {
    debugPrint('''One other overlay is already showing''');
    return Future.value(false);
  }

  final child = Positioned(
    left: 8.0,
    right: 8.0,
    child: NotificationWidget(
      disposeOverlay: hideOverlay,
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

  _showOverlay(child: child);

  return Future.value(true);
}

/// These methods deal with showing and hiding the overlay
Future<bool> _showOverlay({@required Widget child}) async {
  BuildContext context = _tKey.currentContext;

  try {
    if (_overlayShown) hideOverlay();
  } catch (err) {
    print(err);
  }
  _overlayShown = true;
  _overlayEntry = OverlayEntry(
    builder: (context) => child,
  );

  Overlay.of(context).insert(_overlayEntry);
  debugPrint('''Overlay shown''');
  return Future.value(true);
}

hideOverlay() {
  _overlayEntry.remove();
  _overlayShown = false;
  debugPrint('''Overlay removed''');
}

/// --------------------------- end overlay methods --------------------------

class OTS extends StatelessWidget {
  final Widget child;

  const OTS({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      key: _tKey,
      child: child,
    );
  }
}
