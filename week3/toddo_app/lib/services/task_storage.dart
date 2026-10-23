// A service is a class that does a job for the app but has no UI. This one
// saves the tasks on the device, so they are still there after the app closes.

// dart:convert gives us jsonEncode / jsonDecode to turn data into text and back.
import 'dart:convert';

// shared_preferences stores small key/value data on the device. We added it
// to pubspec.yaml under `dependencies`.
import 'package:shared_preferences/shared_preferences.dart';

import '../models/tasks.dart';

class TaskStorage {
  // The name our tasks are saved under. `static const` means it belongs to the
  // class and never changes. The `_` makes it private to this file.
  static const _key = 'tasks';

  // Read the saved tasks. Returns a Future because reading from the device
  // takes a moment; callers `await` it.
  Future<List<Task>> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    // First time the app runs nothing is saved yet, so start with an empty list.
    if (raw == null) return [];
    // Text -> list of Maps -> list of Tasks.
    final List<dynamic> decoded = jsonDecode(raw);
    return decoded
        .map((e) => Task.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  // Save the whole list, replacing whatever was saved before.
  Future<void> save(List<Task> tasks) async {
    final prefs = await SharedPreferences.getInstance();
    // List of Tasks -> list of Maps -> one String of JSON text.
    final raw = jsonEncode(tasks.map((e) => e.toJson()).toList());
    await prefs.setString(_key, raw);
  }
}