// task_notifier.dart
import 'package:task_entry_app/task.dart';//A mixin is a way to add extra features to a class

mixin TaskNotifier {
  void logTaskCompletion(Task task) {
    print('Task "${task.title}" completed!'); // Log task completion message.
  }
}
