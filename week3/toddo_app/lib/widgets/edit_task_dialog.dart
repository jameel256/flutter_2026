import 'package:flutter/material.dart';

// Shows a pop-up for renaming a task, pre-filled with the current title.
// It returns a Future<String?>: when the dialog closes we get the new title,
// or null if the user pressed Cancel (that's what the `?` allows).
Future<String?> showEditTaskDialog(BuildContext context, String currentTitle) {
  // `text:` puts the current title in the box so the user can change it.
  final controller = TextEditingController(text: currentTitle);
  return showDialog<String>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Edit Task'),
      // autofocus opens the keyboard straight away.
      content: TextField(controller: controller, autofocus: true),
      actions: [
        // Navigator.pop() closes the dialog. With no value, the result is null.
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        // pop(value) closes the dialog and sends the typed text back.
        FilledButton(
          onPressed: () => Navigator.of(context).pop(controller.text),
          child: const Text('Save'),
        ),
      ],
    ),
  );
}