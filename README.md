# ots
<!-- ALL-CONTRIBUTORS-BADGE:START - Do not remove or modify this section -->
[![All Contributors](https://img.shields.io/badge/all_contributors-5-orange.svg?style=flat-square)](#contributors-)
<!-- ALL-CONTRIBUTORS-BADGE:END -->

An widget that can show loaders, notifications, internet connectivity changes as `Overlay`.

[Example](example/lib/main.dart)

### Demo
<img src="https://raw.githubusercontent.com/fayaz07/ots/master/screenshots/internet.gif" height="30%" width="30%"  alt="Internet connectivity changes"/> <img src="https://raw.githubusercontent.com/fayaz07/ots/master/screenshots/loader.gif" height="30%" width="30%"  alt="Loader"/> <img src="https://raw.githubusercontent.com/fayaz07/ots/master/screenshots/notification.gif" height="30%" width="30%"  alt="Notification"/> 

<img src="https://raw.githubusercontent.com/fayaz07/ots/master/screenshots/default_toast.png" height="30%" width="30%"  alt="default_toast"/> <img src="https://raw.githubusercontent.com/fayaz07/ots/master/screenshots/error_toast.png" height="30%" width="30%"  alt="error_toast"/> <img src="https://raw.githubusercontent.com/fayaz07/ots/master/screenshots/info_toast.png" height="30%" width="30%"  alt="info_toast"/> <img src="https://raw.githubusercontent.com/fayaz07/ots/master/screenshots/success_toast.png" height="30%" width="30%"  alt="success_toast"/> <img src="https://raw.githubusercontent.com/fayaz07/ots/master/screenshots/warning_toast.png" height="30%" width="30%"  alt="warning_toast"/>


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

#### Showing toasts

##### Default toast
```
bakeToast("Hey toast!");
```

##### Info toast
```
bakeToast("Hey info!", type: ToastType.info);
```

##### Success toast
```
bakeToast("Hey success!", type: ToastType.success);
```

##### Error toast
```
bakeToast("Hey error!", type: ToastType.error);
```

##### Warning toast
```
bakeToast("Hey warning!", type: ToastType.warning);
```

> Note: Notifications are automatically dismissed after the specified duration if `autoDismissible` is set to true.


## Contributors ✨

Thanks goes to these wonderful people ([emoji key](https://allcontributors.org/docs/en/emoji-key)):

<!-- ALL-CONTRIBUTORS-LIST:START - Do not remove or modify this section -->
<!-- prettier-ignore-start -->
<!-- markdownlint-disable -->
<table>
  <tr>
    <td align="center"><a href="http://fayaz07.me"><img src="https://avatars0.githubusercontent.com/u/35001172?v=4?s=100" width="100px;" alt=""/><br /><sub><b>Mohammad Fayaz</b></sub></a><br /><a href="https://github.com/fayaz07/ots/commits?author=fayaz07" title="Code">💻</a> <a href="#content-fayaz07" title="Content">🖋</a> <a href="https://github.com/fayaz07/ots/commits?author=fayaz07" title="Documentation">📖</a> <a href="#example-fayaz07" title="Examples">💡</a> <a href="#ideas-fayaz07" title="Ideas, Planning, & Feedback">🤔</a> <a href="#maintenance-fayaz07" title="Maintenance">🚧</a></td>
    <td align="center"><a href="https://github.com/alexandradeas"><img src="https://avatars0.githubusercontent.com/u/12813479?v=4?s=100" width="100px;" alt=""/><br /><sub><b>Alex Deas</b></sub></a><br /><a href="https://github.com/fayaz07/ots/commits?author=alexandradeas" title="Code">💻</a></td>
    <td align="center"><a href="https://github.com/pranathireddyk"><img src="https://avatars.githubusercontent.com/u/34978536?v=4?s=100" width="100px;" alt=""/><br /><sub><b>Pranathi Reddy</b></sub></a><br /><a href="https://github.com/fayaz07/ots/commits?author=pranathireddyk" title="Code">💻</a></td>
    <td align="center"><a href="https://github.com/asterd"><img src="https://avatars.githubusercontent.com/u/734776?v=4?s=100" width="100px;" alt=""/><br /><sub><b>Aster</b></sub></a><br /><a href="https://github.com/fayaz07/ots/commits?author=asterd" title="Code">💻</a></td>
    <td align="center"><a href="https://lscbot.com"><img src="https://avatars.githubusercontent.com/u/88408208?v=4?s=100" width="100px;" alt=""/><br /><sub><b>lscbot</b></sub></a><br /><a href="https://github.com/fayaz07/ots/commits?author=lscbot" title="Code">💻</a></td>
  </tr>
</table>

<!-- markdownlint-restore -->
<!-- prettier-ignore-end -->

<!-- ALL-CONTRIBUTORS-LIST:END -->

This project follows the [all-contributors](https://github.com/all-contributors/all-contributors) specification. Contributions of any kind welcome!
