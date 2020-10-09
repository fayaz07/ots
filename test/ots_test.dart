import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ots/ots.dart';

void main() {
  testWidgets(
    'hideLoader does not throw when no overlay is shown',
    (tester) async {
      await tester.pumpWidget(
        OTS(
          child: MaterialApp(
            home: Scaffold(),
          ),
        ),
      );
      await showLoader();
      await hideLoader();
      try {
        await hideLoader();
      } catch (e) {
        fail('threw on second call to [hideLoader]');
      }
    },
  );

  testWidgets(
    'hideNotification does not throw when no overlay is shown',
    (tester) async {
      await tester.pumpWidget(
        OTS(
          child: MaterialApp(
            home: Scaffold(),
          ),
        ),
      );
      await showNotification(message: 'foo');
      await hideNotification();
      try {
        await hideNotification();
      } catch (e) {
        fail('threw on second call to [hideNotification]');
      }
    },
  );
}
