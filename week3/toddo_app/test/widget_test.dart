// Widget tests run the app without a phone or emulator: `flutter test`.
// WidgetTester lets us type, tap, and then check what is on screen.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:toddo_app/main.dart';

void main() {
  testWidgets('Add, complete, and delete a task', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // The empty-state message shows when there are no tasks.
    expect(find.text('No tasks yet! Add one above.'), findsOneWidget);

    // Type a task and tap Add. pump() redraws the screen after setState.
    await tester.enterText(find.byType(TextField), 'Buy milk');
    await tester.tap(find.text('Add'));
    await tester.pump();

    expect(find.text('Buy milk'), findsOneWidget);
    expect(find.text('No tasks yet! Add one above.'), findsNothing);

    // Tick the checkbox: the task is now marked done.
    await tester.tap(find.byType(Checkbox));
    await tester.pump();
    expect(tester.widget<Checkbox>(find.byType(Checkbox)).value, isTrue);

    // Delete it: we're back to the empty message.
    await tester.tap(find.byIcon(Icons.delete_outline));
    await tester.pump();
    expect(find.text('Buy milk'), findsNothing);
    expect(find.text('No tasks yet! Add one above.'), findsOneWidget);
  });

  testWidgets('Empty or blank input does not add a task', (tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.enterText(find.byType(TextField), '   ');
    await tester.tap(find.text('Add'));
    await tester.pump();

    expect(find.byType(ListTile), findsNothing);
  });
}
