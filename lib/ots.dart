library ots;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ots/loadtoast/load_toast.dart';
import 'widgets/notification.dart';

final _tKey = GlobalKey(debugLabel: 'overlay_parent');

showNotification({@required Widget child}) {
  BuildContext context = _tKey.currentContext;

  OverlayEntry entry = OverlayEntry(
    builder: (context) => Positioned(
      height: 100.0,
      left: 5.0,
      right: 5.0,
      child: NotificationWidget(
        child: Material(child: Text('hey this is loader dude')),
        duration: Duration(seconds: 2),
      ),
    ),
  );

  Overlay.of(context).insert(entry);

  Future.delayed(Duration(seconds: 4)).then((value) {
    try {
      entry.remove();
    } catch (err) {}
  });
}

OverlayEntry overlayEntry;

showLoadToast({Color backgroundColor, Color indicatorColor, String text}) {
  BuildContext context = _tKey.currentContext;

  overlayEntry = OverlayEntry(
    builder: (context) => Positioned(
      height: 100.0,
      left: 5.0,
      right: 5.0,
      child: LoadToast(
        key: loadToastKey,
        backgroundColor: backgroundColor ?? Colors.white,
        circularIndicatorColor: indicatorColor ?? Colors.blueAccent,
      ),
    ),
  );

  Overlay.of(context).insert(overlayEntry);
  Future.delayed(Duration(milliseconds: 50))
      .whenComplete(() => showLT(text: text));

  Future.delayed(Duration(seconds: 4)).then((value) => success());

  Future.delayed(Duration(seconds: 6)).then((value) {
    try {
      overlayEntry.remove();
    } catch (err) {}
  });
}

success() {
  successLT();
}

error() {
  errorLT();
}

warning() {
  warningLT();
}

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
