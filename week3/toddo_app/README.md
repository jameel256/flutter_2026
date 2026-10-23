# Week 3: To-Do App (Lists, Text Input, and Models)

In week 2 our app's state was a single number. This week the state is a **list of
objects**: we built a to-do app where you can add tasks, tick them off, and delete them.

## How to run this week's code

```bash
cd flutter_2026/week3/toddo_app
flutter pub get
flutter run
```

Or in **VS Code**: open [lib/main.dart](lib/main.dart) and press **F5**.

Run the tests with:
```bash
flutter test
```

## How the project is organised

We stopped putting everything in `main.dart` and split the code into folders:

```
lib/
├── main.dart              # starts the app, sets the theme, opens TodoPage
├── models/
│   └── tasks.dart         # Task class: the data (title + isDone)
└── screens/
    └── todo_page.dart     # TodoPage: the screen and all its logic
```

- **models/** hold plain Dart classes that describe your data. No widgets.
- **screens/** hold the pages the user sees.

We import our own files with the package name from `pubspec.yaml`:
```dart
import 'package:toddo_app/models/tasks.dart';
```

## What we built in class

| Feature | Where to look |
|---------|---------------|
| `Task` model with a title and a done flag | [lib/models/tasks.dart](lib/models/tasks.dart) |
| Text box + **Add** button (Enter also works) | `TextField`, `_addTask()` in [todo_page.dart](lib/screens/todo_page.dart) |
| Blank input is ignored | `trim()` and `if (text.isEmpty) return;` |
| Checkbox to mark a task done | `Checkbox`, `_toggleTask()` |
| Done tasks are crossed out and grey | `TextStyle(decoration: ...)` inside the `ListTile` |
| Delete button on each task | `IconButton`, `_deleteTask()` |
| "No tasks yet!" message when the list is empty | the ternary inside the second `Expanded` |

## Key ideas

### A model class for your data
```dart
class Task {
  String title;
  bool isDone;

  Task(this.title, {this.isDone = false});
}
```
`isDone` is a **named parameter with a default**, so `Task('Buy milk')` starts as
not done.

### Reading text with a `TextEditingController`
The controller is connected to the `TextField`. Use `.text` to read what was typed and
`.clear()` to empty it. Controllers must be cleaned up in `dispose()`:
```dart
@override
void dispose() {
  _taskController.dispose();
  super.dispose();
}
```

### `setState` works on lists too
Adding, removing, or changing an item only shows on screen if it happens inside
`setState`:
```dart
setState(() {
  _tasks.add(Task(text));
});
```

### `ListView.builder` for lists
It builds one row per item using `itemCount` and `itemBuilder`. The `index` tells you
which task the row is for, and that same index is passed to `_toggleTask` and
`_deleteTask`.

### Layout: `Column`, `Row`, and `Expanded`
- `Column` stacks widgets vertically, `Row` places them side by side.
- `Expanded` says "take up the remaining space". We need it around the `TextField`
  (inside a `Row`) and around the `ListView` (inside a `Column`). Without it, Flutter
  can't work out their size and shows a layout error.

## Assignment (due before next week)

Add **two** of the features below to the to-do app. Each one needs `setState`.

1. **Task counter.** Show how many tasks are left in the AppBar title, e.g.
   `My Tasks (2 left)`. It must update when you add, tick, or delete a task.
   *Hint:* `_tasks.where((t) => !t.isDone).length`
2. **Clear completed.** Add a button in the `AppBar` (`actions: [...]`) that removes
   every task that is done in one tap.
   *Hint:* `_tasks.removeWhere((t) => t.isDone)`
   **Extra:** disable the button (`onPressed: null`) when there is nothing to clear.
3. **Priority.** Add a `bool isImportant` field to the `Task` model (default `false`).
   Long-pressing a task (`onLongPress` on the `ListTile`) toggles it, and important
   tasks show a star icon or a red title.
4. **Confirm before delete.** When the delete button is tapped, show an `AlertDialog`
   asking "Delete this task?" with **Cancel** and **Delete** buttons. Only delete if the
   user chooses **Delete**.
   *Hint:* look up `showDialog` in the Flutter docs.

### Optional stretch: undo
After a task is deleted, show a `SnackBar` at the bottom with an **Undo** button that
puts the task back **in the same position** it was in.

*Hint:* save the task and its index before removing it, then use
`_tasks.insert(index, task)`.
```dart
ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(
    content: const Text('Task deleted'),
    action: SnackBarAction(label: 'Undo', onPressed: () { /* ... */ }),
  ),
);
```

### What to bring next week
- Your updated `lib/` folder
- If you changed the `Task` model, be ready to explain **why** the new field belongs in
  the model and not in the screen.
- Think about this: close the app and open it again. What happens to your tasks? Why?
  (This is what we'll fix soon.)
