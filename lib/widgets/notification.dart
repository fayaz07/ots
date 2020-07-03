import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ots/utils/styles.dart';

class NotificationWidget extends StatefulWidget {
  final int duration;
  final int animDuration;
  final bool autoDismissible;
  final bool dismissOnTap;
  final VoidCallback disposeOverlay;
  final String title;
  final String message;
  final TextStyle messageStyle;
  final TextStyle titleStyle;
  final Color backgroundColor;
  final VoidCallback onTap;

  const NotificationWidget(
      {Key key,
      this.duration = 2000,
      this.autoDismissible = true,
      this.disposeOverlay,
      this.message,
      this.messageStyle,
      this.titleStyle,
      this.backgroundColor = Colors.black,
      this.title = "Notification",
      this.animDuration = 400,
      this.onTap,
      this.dismissOnTap = false})
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
    _animationController = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: widget.animDuration ?? 400));
    _animation = Tween(begin: -0.3, end: 0.075).animate(
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
    if (widget.autoDismissible) {
      try {
        await Future.delayed(Duration(milliseconds: widget.duration ?? 2000));
        if (mounted) {
          await _animationController.reverse();
          _callDispose();
        }
      } catch (err) {
        debugPrint('''NotificationWidget dispose error''');
        throw err;
      }
    }
  }

  _callDispose() {
    if (widget.disposeOverlay != null) widget.disposeOverlay();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Dismissible(
      key: Key('dismissible_child_notification_overlay'),
      onDismissed: (DismissDirection direction) => _callDispose(),
      direction: DismissDirection.horizontal,
      confirmDismiss: (d) => Future.value(true),
      child: GestureDetector(
        onTap: () {
          if (widget.onTap != null) {
            widget.onTap();
          }

          if (widget.dismissOnTap) {
            _animationController.reverse().whenComplete(() => _callDispose());
          }
        },
        child: AnimatedBuilder(
          animation: _animation,
          builder: (context, child) => Transform(
            transform:
                Matrix4.translationValues(0.0, _animation.value * height, 0.0),
            child: Material(
              elevation: 4.0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0)),
              color: widget.backgroundColor,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      widget.title,
                      style: widget.titleStyle ?? TextStyles.titleStyle,
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      widget.message,
                      style: widget.messageStyle ?? TextStyles.bodyStyle,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
