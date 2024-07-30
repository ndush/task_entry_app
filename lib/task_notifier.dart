// Mixin to log task completion.
import 'package:task_entry_app/task.dart';

mixin TaskNotifier {
  void logTaskCompletion(Task task) {
    print('Task "${task.title}" completed!'); // Log task completion message.
  }
}
