import 'package:flutter/material.dart';
import 'package:ots/ots.dart';

void main() => runApp(MaterialApp(
  home: OTS(
    child: Home(),
  ),
));

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final double indicatorWidth = 24.0;
  final double indicatorHeight = 300.0;
  final double slideHeight = 200.0;
  final double slideWidth = 400.0;

  final LayerLink layerLink = LayerLink();
  OverlayEntry overlayEntry;
  Offset center;

  @override
  Widget build(BuildContext context) {
    center = Offset(MediaQuery.of(context).size.width / 2,
        MediaQuery.of(context).size.height / 2);
    return Scaffold(
      body: Container(
        color: Colors.blue.withOpacity(0.2),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
              onTap: () {
                showNotification();
              },
              child: Center(child: Text('press here to show loader')),
            ),
          ],
        ),
      ),
    );
  }
}
