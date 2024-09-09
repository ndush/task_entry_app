import 'package:flutter/material.dart';
import 'task_entry_screen.dart';
import 'task_manager.dart';

void main() {
  runApp(TaskEntryApp());
}

class TaskEntryApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Entry App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: TaskEntryScreen(taskManager: TaskManager()), // Inject TaskManager
    );
  }
}
