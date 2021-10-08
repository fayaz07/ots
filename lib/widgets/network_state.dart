import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ots/utils/styles.dart';

class NetworkWidget extends StatefulWidget {
  final VoidCallback? disposeOverlay;
  final NetworkState? state;
  final NetworkStateMessenger? messenger;
  final bool persistNotification;

  const NetworkWidget({
    Key? key,
    this.disposeOverlay,
    this.state,
    this.messenger = const NetworkStateDefaultMessage(),
    this.persistNotification = false
  }) : super(key: key);

  @override
  _NetworkWidgetState createState() => _NetworkWidgetState();
}

class _NetworkWidgetState extends State<NetworkWidget> with SingleTickerProviderStateMixin {
  late Animation _animation;
  late AnimationController _animationController;

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
    if (widget.state == NetworkState.Disconnected && widget.persistNotification) {
      debugPrint('Persisting NoInternet NetworkStatusWidget');
    } else {
      try {
        await Future.delayed(Duration(milliseconds: 2000));
        if (mounted) {
          await _animationController.reverse();
          _callDispose();
        }
      } catch (err) {
        debugPrint('''NetworkStatusWidget dispose error''');
        throw err;
      }
    }
  }

  _callDispose() {
    if (widget.disposeOverlay != null) widget.disposeOverlay!();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) => Transform(
        transform: Matrix4.translationValues(0.0, -_animation.value * height, 0.0),
        child: Material(
          color: widget.messenger!.color(widget.state), // widget.state.color,
          child: Center(
            child: Text(
              widget.messenger!.message(widget.state),   // widget.state.message,
              style: TextStyles.networkStatusStyle,
            ),
          ),
        ),
      ),
    );
  }
}

enum NetworkState { Connected, Disconnected, Weak }

abstract class NetworkStateMessenger {
  const NetworkStateMessenger();

  String message(NetworkState? networkState);
  Color color(NetworkState? networkState);
}

class NetworkStateDefaultMessage extends NetworkStateMessenger {
  const NetworkStateDefaultMessage();

  String message(NetworkState? networkState) {
    switch (networkState) {
      case NetworkState.Connected:
        return "Connected to internet";
      case NetworkState.Disconnected:
        return "No internet connection";
      case NetworkState.Weak:
        return "Internet may not be available";
      default:
        return "Unknown internet status";
    }
  }

  Color color(NetworkState? networkState) {
    switch (networkState) {
      case NetworkState.Connected:
        return Colors.green;
      case NetworkState.Disconnected:
        return Colors.red;
      case NetworkState.Weak:
        return Colors.orange;
      default:
        return Colors.orange;
    }
  }
}

// extension NetworkStateMessage on NetworkState? {
//   String get message {
//     switch (this) {
//       case NetworkState.Connected:
//         return "Connected to internet";
//       case NetworkState.Disconnected:
//         return "No internet connection";
//       case NetworkState.Weak:
//         return "Internet may not be available";
//       default:
//         return "Unknown internet status";
//     }
//   }
//
//   Color get color {
//     switch (this) {
//       case NetworkState.Connected:
//         return Colors.green;
//       case NetworkState.Disconnected:
//         return Colors.red;
//       case NetworkState.Weak:
//         return Colors.orange;
//       default:
//         return Colors.orange;
//     }
//   }
// }