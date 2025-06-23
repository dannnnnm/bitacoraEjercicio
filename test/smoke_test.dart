// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:bitacora_ejercicios/screen/add_activity.dart';
import 'package:bitacora_ejercicios/screen/main_screen.dart';
import 'package:bitacora_ejercicios/service/database_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:bitacora_ejercicios/main.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  testWidgets(
    'Shows main screen and add activity FAB leads to add activity screen',
    (WidgetTester tester) async {
      await tester.runAsync(() async {
        sqfliteFfiInit();
        await DatabaseService.init(
          customDB: await databaseFactoryFfi.openDatabase(":memory:"),
        );
        // Build our app and trigger a frame.
        await tester.pumpWidget(const MyApp());
        await tester.ensureVisible(find.byKey(newActivityFABKey));
        await tester.pumpAndSettle(Duration(seconds: 2));
        // Tap the '+' icon and trigger a frame.
        await tester.tap(find.byKey(newActivityFABKey));
        await tester.pumpAndSettle(Duration(seconds: 2));

        // Find at least one field for activity creation
        expect(find.byKey(newActivityNameKey), findsOneWidget);
      });
    },
  );
}
