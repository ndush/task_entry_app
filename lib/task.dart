// Enum to represent task priorities.
enum Priority { High, Medium, Low }

// Class to represent a task.
class Task {
  final String title; // Title of the task.
  final String description; // Description of the task.
  final DateTime dueDate; // Due date of the task.
  final Priority priority; // Priority level of the task.
  bool isComplete; // Status of task completion.

  Task({
    required this.title,
    required this.description,
    required this.dueDate,
    required this.priority,
    this.isComplete = false, // Default status is not complete.
  });
}

// Subclass of Task with no additional properties or methods.
class TimedTask extends Task {
  TimedTask({
    required super.title,
    required super.description,
    required super.dueDate,
    required super.priority,
  });
}
