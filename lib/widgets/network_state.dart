import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:ots/utils/styles.dart';

enum NetworkState { Connected, Disconnected, Weak }

extension NetworkStateMessage on NetworkState {
  String get message {
    switch (this) {
      case NetworkState.Connected:
        return "Connected to internet";
        break;
      case NetworkState.Disconnected:
        return "No internet connection";
        break;
      case NetworkState.Weak:
        return "Weak internet connection";
        break;
    }
    return "Connected to internet";
  }

  Color get color {
    switch (this) {
      case NetworkState.Connected:
        return Colors.green;
        break;
      case NetworkState.Disconnected:
        return Colors.red;
        break;
      case NetworkState.Weak:
        return Colors.yellow;
        break;
    }
    return Colors.green;
  }
}

class NetworkWidget extends StatefulWidget {
  final VoidCallback disposeOverlay;
  final NetworkState state;

  const NetworkWidget({Key key, this.disposeOverlay, this.state})
      : super(key: key);

  @override
  _NetworkWidgetState createState() => _NetworkWidgetState();
}

class _NetworkWidgetState extends State<NetworkWidget>
    with SingleTickerProviderStateMixin {
  Animation _animation;
  AnimationController _animationController;

  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200));
    _animation = Tween(begin: -0.1, end: 0.0).animate(
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
      await Future.delayed(Duration(milliseconds: 2000));
      if (mounted) {
        await _animationController.reverse();
        _callDispose();
      }
    } catch (err) {
      debugPrint('''NotificationWidget dispose error''');
      throw err;
    }
  }

  _callDispose() {
    if (widget.disposeOverlay != null) widget.disposeOverlay();
  }

  @override
  void dispose() {
    _animationController.dispose();
//    debugPrint('''NotificationWidget disposed''');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) => Transform(
        transform:
            Matrix4.translationValues(0.0, -_animation.value * height, 0.0),
        child: Material(
//          shape:
//              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          color: widget.state.color,
          child: Center(
            child: Text(
              widget.state.message,
              style: TextStyles.networkStatusStyle,
            ),
          ),
        ),
      ),
    );
  }
}
