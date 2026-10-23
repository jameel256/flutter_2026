import 'package:flutter/material.dart';
import 'package:toddo_app/models/tasks.dart';

// One row in the to-do list, moved out of todo_page.dart into its own widget.
// It is Stateless: it doesn't change anything itself. It shows a task, and
// when the user taps or swipes it calls the function the screen gave it.
class TaskTile extends StatelessWidget {
  final Task task;

  // VoidCallback is a function that takes nothing and returns nothing.
  // TodoPage passes these in, e.g. onDelete: () => _deleteTask(index).
  final VoidCallback onToggle;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  // `required` means you must pass these when creating a TaskTile.
  const TaskTile({
    super.key,
    required this.task,
    required this.onToggle,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    // Dismissible lets the user swipe the row away to delete it.
    return Dismissible(
      // Flutter needs a unique key to know which row was swiped away.
      // ObjectKey(task) uses the task object itself as that key.
      key: ObjectKey(task),
      // Only allow swiping from right to left.
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDelete(),
      // What shows behind the row while it is being swiped: red with a bin icon.
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      // ListTile is a ready-made row with leading / title / trailing slots.
      child: ListTile(
        // Tapping the row opens the edit dialog.
        onTap: onEdit,
        // Left side: checkbox shows and toggles isDone.
        leading: Checkbox(value: task.isDone, onChanged: (_) => onToggle()),
        // Middle: the task text. Finished tasks are crossed out
        // and grey. `null` means "use the normal style".
        title: Text(
          task.title,
          style: TextStyle(
            decoration: task.isDone ? TextDecoration.lineThrough : null,
            color: task.isDone ? Colors.grey : null,
          ),
        ),
      ),
    );
  }
}