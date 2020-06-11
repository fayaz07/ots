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
      loader: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
      ),
      child: MaterialApp(
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              crossAxisAlignment: WrapCrossAlignment.center,
              alignment: WrapAlignment.center,
              direction: Axis.horizontal,
              children: <Widget>[
                RaisedButton(
                  color: Colors.blue,
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
                RaisedButton(
                  color: Colors.green,
                  child: Text('Show Loader', style: textStyle),
                  onPressed: () async {
                    showLoader(
                      isModal: true,
                    );

                    await Future.delayed(Duration(seconds: 3));
                    hideLoader();
                  },
                ),
                RaisedButton(
                  color: Colors.red,
                  child: Text('LoadToast Error'),
                  onPressed: () {
//                    hideLoadToastWithError();
                  },
                ),
                RaisedButton(
                  color: Colors.orange,
                  child: Text('LoadToast Warning'),
                  onPressed: () {
//                    hideLoadToastWithWarning();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
