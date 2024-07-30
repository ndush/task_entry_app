import 'package:flutter/material.dart';
import 'task_entry_screen.dart';

// Main function to run the app.
void main() {
  runApp(const TaskEntryApp()); // Run the TaskEntryApp widget.
}

// Main app widget for the task entry application.
class TaskEntryApp extends StatelessWidget {
  const TaskEntryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Entry App', // Title of the application.
      debugShowCheckedModeBanner: false, // Hide the debug banner.
      theme: ThemeData(
        primarySwatch: Colors.orange, // Set the primary color theme.
      ),
      home: const TaskEntryScreen(), // Set the home screen to TaskEntryScreen.
    );
  }
}
