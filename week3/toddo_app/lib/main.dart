import 'package:flutter/material.dart';
// We import our own files using the package name from pubspec.yaml (toddo_app).
import 'package:toddo_app/screens/todo_page.dart';

// The app starts here. `=>` is a short way to write a one-line function.
void main() => runApp(const MyApp());

// MyApp is the root of the app. It never changes, so it is a StatelessWidget.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To-Do',
      // One seed color generates a whole matching color scheme (Material 3).
      theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
      // The first screen the user sees. It lives in lib/screens/todo_page.dart.
      home: const TodoPage(),
    );
  }
}