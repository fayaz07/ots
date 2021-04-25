import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ots/ots.dart';

void main() => runApp(
      MyApp(),
    );

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return OTS(
      showNetworkUpdates: true,
      persistNoInternetNotification: false,

      /// pass your custom loader here
//      loader: CircularProgressIndicator(
//        valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
//      ),
//      child: MaterialApp(
//      title: 'OTS Test',
//        home: Home(),
//      ),
      child: CupertinoApp(
        title: 'OTS Test',
        home: Home(),
      ),
    );
  }
}

final textStyle = TextStyle(color: Colors.white);

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                child: Text('Show Notification', style: textStyle),
                onPressed: () {
                  showNotification(
                    message: 'Hello, this is notification',
                    title: 'Test',
                    backgroundColor: Colors.green,
                    autoDismissible: true,
                    notificationDuration: 2500,
                  );
                },
              ),
              ElevatedButton(
                child: Text('Show Loader', style: textStyle),
                onPressed: () async {
                  showLoader(
                    isModal: true,
                  );

                  await Future.delayed(Duration(seconds: 3));
                  hideLoader();
                },
              ),
              ElevatedButton(
                child: Text('Show Toast', style: textStyle),
                onPressed: () async {
                  bakeToast("Hey info!", type: ToastType.info);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
