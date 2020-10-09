# ots
<!-- ALL-CONTRIBUTORS-BADGE:START - Do not remove or modify this section -->
[![All Contributors](https://img.shields.io/badge/all_contributors-2-orange.svg?style=flat-square)](#contributors-)
<!-- ALL-CONTRIBUTORS-BADGE:END -->

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

## Contributors ✨

Thanks goes to these wonderful people ([emoji key](https://allcontributors.org/docs/en/emoji-key)):

<!-- ALL-CONTRIBUTORS-LIST:START - Do not remove or modify this section -->
<!-- prettier-ignore-start -->
<!-- markdownlint-disable -->
<table>
  <tr>
    <td align="center"><a href="https://github.com/alexandradeas"><img src="https://avatars0.githubusercontent.com/u/12813479?v=4" width="100px;" alt=""/><br /><sub><b>Alex Deas</b></sub></a><br /><a href="https://github.com/fayaz07/ots/commits?author=alexandradeas" title="Code">💻</a></td>    
  </tr>
</table>

<!-- markdownlint-enable -->
<!-- prettier-ignore-end -->
<!-- ALL-CONTRIBUTORS-LIST:END -->

This project follows the [all-contributors](https://github.com/all-contributors/all-contributors) specification. Contributions of any kind welcome!
