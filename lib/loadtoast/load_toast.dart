import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

final loadToastKey = GlobalKey<_LoadToastState>(debugLabel: 'load_toast_ots');

showLT({String text}) {
  print(loadToastKey.currentState.mounted);
  loadToastKey.currentState.show(text: text);
}

hideLT(){
  loadToastKey.currentState.success();
}

successLT(){
  loadToastKey.currentState.success();
}

errorLT(){
  loadToastKey.currentState.error();
}

warningLT(){
  loadToastKey.currentState.warning();
}

/// Mohammmad Fayaz(https://www.github.com/fayaz07/load_toast)
class LoadToast extends StatefulWidget {
  final Color backgroundColor, circularIndicatorColor;

  const LoadToast(
      {Key key,
      this.backgroundColor = Colors.white,
      this.circularIndicatorColor = Colors.blue})
      : super(key: key);

  @override
  _LoadToastState createState() => _LoadToastState();
}

class _LoadToastState extends State<LoadToast>
    with TickerProviderStateMixin {
  static String _message = "Please wait...";

  var _animDuration = Duration(milliseconds: 600);
  double _containerHeight = 50.0, _radius = 25.0;

  Widget _showingChild;

  Widget _postChild = Image.asset('assets/success.png', package: 'ots');
  Widget _postChildSuccess =
      Image.asset('assets/success.png', package: 'ots');
  Widget _postChildError =
      Image.asset('assets/cancel.png', package: 'ots');
  Widget _postChildWarning =
      Image.asset('assets/warning.png', package: 'ots');

  Animation _scaleAnim, _opacityAnim;
  AnimationController _scaleController, _opacityController;
  bool _isShowing = false;

  _LoadToastState() {
    _showingChild = Row(
      children: <Widget>[
        SizedBox(width: 20.0),
        Expanded(
            child: Text(_message,
                style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.w700,
                    color: Colors.black))),
        SizedBox(width: 10.0),
        CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation(Colors.blue),
        ),
        SizedBox(width: 10.0),
      ],
    );
  }

  show({String text}) {
    if (!_isShowing) {
      debugPrint('Showing loadtoast');
      setState(() {
        _message = text ?? _message;
      });
      _opacityController.forward();
      _isShowing = true;
    }
  }

  success() {
    if (_isShowing) {
      setState(() {
        _postChild = _postChildSuccess;
      });
      _scaleController.forward();
    }
  }

  error() {
    if (_isShowing) {
      setState(() {
        _postChild = _postChildError;
      });
      _scaleController.forward();
    }
  }

  warning() {
    if (_isShowing) {
      setState(() {
        _postChild = _postChildWarning;
      });
      _scaleController.forward();
    }
  }

  @override
  void initState() {
    super.initState();

    _scaleController = AnimationController(
      vsync: this,
      animationBehavior: AnimationBehavior.normal,
      duration: _animDuration,
    );

    _opacityController = AnimationController(
      vsync: this,
      animationBehavior: AnimationBehavior.normal,
      duration: Duration(milliseconds: 900),
    );

    _scaleAnim = Tween(begin: 250.0, end: 50.0).animate(
        CurvedAnimation(curve: Curves.linear, parent: _scaleController));
    _scaleAnim.addListener(_listenToScale);

    _opacityAnim = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        curve: Curves.easeInOutCirc, parent: _opacityController));

//    opacityController.forward();
    _opacityController.addListener(_listenToTransform);
  }

  _listenToTransform() {
    // print('opacity ${opacityAnim.value}');
//    if (opacityController.isCompleted) startFuture();
  }

  _listenToScale() {
    if (_scaleAnim.value <= 200.0) {
      setState(() {
        _showingChild = _postChild;
      });
    }
    if (_scaleAnim.isCompleted) {
      _opacityController.reverse(from: 1.0).whenComplete(() {
        _opacityController.reset();
        _scaleController.reset();
        _isShowing = false;
        setState(() {
          _showingChild = Row(
            children: <Widget>[
              SizedBox(width: 20.0),
              Expanded(
                  child: Text(_message,
                      style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.w700,
                          color: Colors.black))),
              SizedBox(width: 10.0),
              CircularProgressIndicator(
                valueColor:
                    AlwaysStoppedAnimation(widget.circularIndicatorColor),
              ),
              SizedBox(width: 10.0),
            ],
          );
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;

    return AnimatedBuilder(
//      key: loadToastKey,
      animation: _opacityAnim,
      builder: (BuildContext context, Widget child) {
        return Transform(
          transform: Matrix4.translationValues(
              0.0, _opacityAnim.value * height * 0.1, 0.0),
          child: Opacity(
            opacity: _opacityAnim.value,
            child: Align(
              alignment: Alignment.topCenter,
              child: AnimatedBuilder(
                animation: _scaleAnim,
                builder: (BuildContext context, Widget child) {
                  return Material(
                    borderRadius: BorderRadius.all(Radius.circular(_radius)),
                    color: widget.backgroundColor,
                    type: MaterialType.canvas,
                    elevation: 8.0,
                    child: SizedBox(
                        width: _scaleAnim.value,
                        height: _containerHeight,
                        child: _showingChild),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
