library ots;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'widgets/notification.dart';

final _tKey = GlobalKey(debugLabel: 'overlay_parent');

showNotification() {
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
