import 'package:flutter/material.dart';
import 'package:toddo_app/models/tasks.dart';
import 'package:toddo_app/widgets/task_tile.dart';
import 'package:toddo_app/widgets/edit_task_dialog.dart';
import 'package:toddo_app/services/task_storage.dart';

// The to-do screen. The list of tasks changes while the app runs, so this is a
// StatefulWidget: the widget itself is fixed, and the changing data lives in
// its State class below.
class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  // Saves tasks to the phone and loads them back (see services/task_storage.dart).
  final TaskStorage _storage = TaskStorage();

  // All the tasks on screen. This is no longer `final`, because when the saved
  // tasks finish loading we replace the empty list with the loaded one.
  List<Task> _tasks = [];

  // True until the saved tasks have loaded. While it is true we show a spinner.
  bool _isLoading = true;

  // A controller lets us read (and clear) whatever the user typed in the TextField.
  final TextEditingController _taskController = TextEditingController();

  // initState() runs once, when this screen is first created. It's the place
  // to start work that should only happen at the beginning, like loading data.
  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  // `async` lets us use `await` inside: wait for the saved tasks without
  // freezing the app. `Future<void>` means "this finishes later, returns nothing".
  Future<void> _loadTasks() async {
    final loaded = await _storage.load();
    // While we were waiting, the user may have left this screen. `mounted` is
    // false if so, and calling setState then would crash, so we stop here.
    if (!mounted) return;
    setState(() {
      _tasks = loaded;
      _isLoading = false;
    });
  }

  // Every change goes through here: update the screen, then save the new list.
  // `change` is a function we pass in (e.g. "add this task"). setState runs it
  // and redraws; save() writes the list to storage. We don't `await` save()
  // because the screen doesn't need to wait for it to finish.
  void _update(VoidCallback change) {
    setState(change);
    _storage.save(_tasks);
  }

  void _addTask() {
    // trim() removes spaces at the start and end, so "   " counts as empty.
    final text = _taskController.text.trim();
    // Guard clause: if there is nothing to add, stop here.
    if (text.isEmpty) return;

    // _update calls setState for us (so the new task appears on screen) and
    // then saves the list.
    _update(() => _tasks.add(Task(text)));

    // Empty the text box so the user can type the next task.
    _taskController.clear();
  }

  // Flip a task between done and not done. `!` turns true into false and back.
  void _toggleTask(int index) {
    _update(() => _tasks[index].isDone = !_tasks[index].isDone);
  }

  void _deleteTask(int index) {
    _update(() => _tasks.removeAt(index));
  }

  // Open the edit dialog and wait for the user to finish. The dialog gives
  // back the new title, or null if they pressed Cancel.
  Future<void> _editTask(int index) async {
    final newTitle = (await showEditTaskDialog(
      context,
      _tasks[index].title,
    ))?.trim();
    // `?.trim()` only trims if the value isn't null. Same guard as _addTask:
    // ignore Cancel and blank titles.
    if (newTitle == null || newTitle.isEmpty) return;
    _update(() => _tasks[index].title = newTitle);
  }

  // dispose() runs when this screen is removed. Controllers hold on to
  // resources, so we must dispose them ourselves to avoid memory leaks.
  @override
  void dispose() {
    _taskController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Tasks')),
      // While loading, show a spinning circle. Once loaded, show the real page.
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          // Column stacks its children top to bottom: the input row, then the list.
          : Column(
              children: [
                // --- Input row: text box + Add button ---
                Padding(
                  padding: const EdgeInsets.all(16),
                  // Row places its children side by side.
                  child: Row(
                    children: [
                      // Expanded makes the TextField take all the width the button
                      // doesn't need. Without it, a TextField inside a Row crashes
                      // because it doesn't know how wide to be.
                      Expanded(
                        child: TextField(
                          controller: _taskController,
                          decoration: const InputDecoration(
                            hintText: 'Enter a task',
                            border: OutlineInputBorder(),
                          ),
                          // Pressing Enter on the keyboard also adds the task.
                          // `_` means "we get a value here but don't need it".
                          onSubmitted: (_) => _addTask(),
                        ),
                      ),

                      const SizedBox(
                        width: 8,
                      ), // a small gap between box and button
                      FilledButton(
                        onPressed: _addTask,
                        child: const Text('Add'),
                      ),
                    ],
                  ),
                ),

                // --- Task list ---
                // Expanded gives the list all the remaining height under the input row.
                Expanded(
                  // Ternary: show a friendly message when empty, otherwise the list.
                  child: _tasks.isEmpty
                      ? const Center(
                          child: Text('No tasks yet! Add one above.'),
                        )
                      // ListView.builder only builds the rows that are visible, so it
                      // stays fast even with a very long list.
                      : ListView.builder(
                          itemCount: _tasks.length,
                          // Called once per row. `index` is the row number (0, 1, 2, ...).
                          itemBuilder: (context, index) {
                            // Each row is our own TaskTile widget (widgets/task_tile.dart).
                            // The tile only draws the task; when something happens
                            // it calls these functions, and this screen does the work.
                            return TaskTile(
                              task: _tasks[index],
                              onToggle: () => _toggleTask(index),
                              onDelete: () => _deleteTask(index),
                              onEdit: () => _editTask(index),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }
}