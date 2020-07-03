# ots

An widget that can show loaders, notifications, internet connectivity changes as `Overlay`.

[Example](example/lib/main.dart)

### Demo
<img src="https://raw.githubusercontent.com/fayaz07/ots/development/screenshots/internet.gif" height="30%" width="30%"  alt="Internet connectivity changes"/> <img src="https://raw.githubusercontent.com/fayaz07/ots/development/screenshots/loader.gif" height="30%" width="30%"  alt="Loader"/> <img src="https://raw.githubusercontent.com/fayaz07/ots/development/screenshots/notification.gif" height="30%" width="30%"  alt="Notification"/>



### Installation

```yaml
dependencies:
  flutter:
    sdk: flutter
  ...

  ots:
    git:
      url: git://github.com/fayaz07/ots.git
```

### How to use
```dart
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
        valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
      ),

      child: MaterialApp(
      title: 'OTS Test',
        home: Home(),
      ),
    );
  }
}
```

By default, loader is set to [CircularProgressIndicator](https://api.flutter.dev/flutter/material/CircularProgressIndicator-class.html) for Android and [CupertinoActivityIndicator](https://api.flutter.dev/flutter/cupertino/CupertinoActivityIndicator-class.html) for iOS.


#### Showing and hiding a loader
```dart
showLoader(
  isModal: true,
);
/// Your network operation
hideLoader();
```

> Note: `isModal` stops user from interacting with the screen

#### Showing and hiding a notification
```dart
showNotification(
  title: 'Test',
  message: 'Hello, this is notification',
  backgroundColor: Colors.green,
  autoDismissible: true,
  notificationDuration: 2500,
);

// use only if `autoDismissible: false`
hideNotification();
```

> Note: Notifications are automatically dismissed after the specified duration if `autoDismissible` is set to true.
