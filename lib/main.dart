import 'package:flutter/material.dart';
import 'task_entry_screen.dart';

void main() {
  runApp(const TaskEntryApp());
}

class TaskEntryApp extends StatelessWidget {
  const TaskEntryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Entry App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: const TaskEntryScreen(),
    );
  }
}
