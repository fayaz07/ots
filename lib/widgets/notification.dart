import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class NotificationWidget extends StatefulWidget {
  final Widget child;
  final Duration duration;

  const NotificationWidget({@required this.child, Key key, this.duration})
      : super(key: key);

  @override
  _NotificationWidgetState createState() => _NotificationWidgetState();
}

class _NotificationWidgetState extends State<NotificationWidget>
    with SingleTickerProviderStateMixin {
  Animation _animation;
  AnimationController _animationController;

  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 400));
    _animation = Tween(begin: -1.0, end: 0.05).animate(
      CurvedAnimation(
        curve: Curves.linear,
        parent: _animationController,
      ),
    );

    _animationController.forward();
    _reverse();
    super.initState();
  }

  _reverse() async {
    try {
      await Future.delayed(widget.duration);
      if (mounted) _animationController.reverse();
    } catch (err) {}
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key('dismissible_child_notification_overlay'),
//      onDismissed: (DismissDirection direction) {
//        this.dispose();
//      },
      direction: DismissDirection.horizontal,
      confirmDismiss: (d) => Future.value(true),
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) => Transform(
          transform: Matrix4.translationValues(
              0.0, _animation.value * MediaQuery.of(context).size.height, 0.0),
          child: widget.child,
        ),
      ),
    );
  }
}
