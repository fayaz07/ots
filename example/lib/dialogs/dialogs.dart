import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const Duration _dialogDuration = Duration(milliseconds: 100);
const Curve _animCurve = Curves.linear;

class AnimatedAboutDialog extends StatefulWidget {
  final Widget title, content;
  final List<Widget> actions;
  final ScrollController actionScrollController, scrollController;
  final Curve insetAnimationCurve;
  final Duration insetAnimationDuration;
  final VoidCallback dismiss;

  const AnimatedAboutDialog({
    Key key,
    this.title,
    this.content,
    this.actions,
    this.actionScrollController,
    this.scrollController,
    this.insetAnimationCurve,
    this.insetAnimationDuration,
    this.dismiss,
  }) : super(key: key);

  @override
  _AnimatedAboutDialogState createState() => _AnimatedAboutDialogState();
}

class _AnimatedAboutDialogState extends State<AnimatedAboutDialog>
    with SingleTickerProviderStateMixin {
  Animation<double> _scale;
  AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: _dialogDuration,
      animationBehavior: AnimationBehavior.normal,
    );
    _scale = Tween(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: _animCurve,
        reverseCurve: _animCurve,
      ),
    );
    super.initState();
    _controller.forward();

//    widget.dismiss.
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scale,
      alignment: Alignment.center,
      child: _getChild(),
    );
  }

  Widget _getChild() {
    switch (Platform.operatingSystem) {
      case "ios":
        return CupertinoAlertDialog(
          key: UniqueKey(),
          title: widget.title,
          content: widget.content,
          actions: widget.actions,
          actionScrollController: widget.actionScrollController,
          insetAnimationCurve: widget.insetAnimationCurve,
          insetAnimationDuration: widget.insetAnimationDuration,
          scrollController: widget.scrollController,
        );
//      case "linux":
//
//      /// todo: linux about dialog implementation
//      case "macos":
//
//      /// todo: macos about dialog implementation
//      case "windows":
//
//      /// todo: windows about dialog implementation
//      case "fuchsia":
//
//      /// todo: fuchsia about dialog implementation
      case "android":
      default:
        return AlertDialog(
          key: UniqueKey(),
          title: widget.title,
          content: widget.content,
          actions: widget.actions,
        );
    }
  }
}
