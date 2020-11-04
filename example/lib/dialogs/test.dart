import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'dialogs.dart';

void main() => runApp(MaterialApp(home: DialogTest()));

class DialogTest extends StatefulWidget {
  @override
  _DialogTestState createState() => _DialogTestState();
}

class _DialogTestState extends State<DialogTest> {
  Widget dialog = SizedBox();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Positioned(
            top: 50.0,
            left: 50.0,
            child: InkWell(
              child: Text('show about dialog'),
              onTap: () {
                showDialog();
              },
            ),
          ),
          Center(
            child: dialog,
          )
        ],
      ),
    );
  }

  showDialog() {
    setState(() {
      dialog = AnimatedAboutDialog(
        title: Text('AlertDialog Title'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('This is a demo alert dialog.'),
              Text('Would you like to approve of this message?'),
            ],
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('Approve'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    });
  }
}
