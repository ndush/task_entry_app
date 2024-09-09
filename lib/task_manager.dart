import 'package:uuid/uuid.dart';
import 'task.dart';

class TaskManager {
  final List<Task> _tasks = [];

  void addTask(String title, String description, DateTime dueDate, Priority priority) {
    if (title.isNotEmpty) {
      _tasks.add(Task(
        id: Uuid().v4(),
        title: title,
        description: description,
        dueDate: dueDate,
        priority: priority,
      ));
      _sortTasks();
    }
  }

  void deleteTask(Task task) {
    _tasks.remove(task);
  }

  void _sortTasks() {
    _tasks.sort((a, b) => a.priority.index.compareTo(b.priority.index));
  }

  List<Task> getTasks() {
    return List.unmodifiable(_tasks);
  }
}
