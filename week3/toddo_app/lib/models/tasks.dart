// A model is a plain Dart class that describes our data. It has no UI code.
// Each item in the to-do list is one Task.
class Task {
  String title;
  bool isDone;

  // `this.title` is required and positional: Task('Buy milk').
  // `{this.isDone = false}` is a named parameter with a default value, so a new
  // task starts unfinished unless we say otherwise: Task('Buy milk', isDone: true).
  Task(this.title, {this.isDone = false});

  // Storage can only save simple values (text, numbers, true/false), not our
  // Task class. toJson() turns a Task into a Map, which can be written as text:
  // Task('Buy milk') -> {'title': 'Buy milk', 'isDone': false}
  Map<String, dynamic> toJson() => {'title': title, 'isDone': isDone};

  // The opposite of toJson(): build a Task back from a saved Map.
  // A `factory` constructor is one that runs code to create the object.
  // `as String` / `as bool` tell Dart what type each value is.
  factory Task.fromJson(Map<String, dynamic> json) =>
      Task(json['title'] as String, isDone: json['isDone'] as bool);
}