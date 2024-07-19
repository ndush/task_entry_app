import 'package:flutter/material.dart';

void main() {
  runApp(const TaskEntryApp());
}

// The main app widget.
class TaskEntryApp extends StatelessWidget {
  const TaskEntryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Entry App', // Title of the app
      debugShowCheckedModeBanner: false, // Removes the debug banner in the top right corner.
      theme: ThemeData(
        primarySwatch: Colors.orange, // Primary color theme for the app.
      ),
      home: const TaskEntryScreen(), // The main screen of the app.
    );
  }
}

// Stateful widget for the task entry screen.
class TaskEntryScreen extends StatefulWidget {
  const TaskEntryScreen({super.key});

  @override
  _TaskEntryScreenState createState() => _TaskEntryScreenState();
}

// State class for the TaskEntryScreen.
class _TaskEntryScreenState extends State<TaskEntryScreen> {
  final List<String> _tasks = []; // List to store the tasks.
  final TextEditingController _taskController = TextEditingController(); // Controller for the text field.

  // Method to add a task to the list.
  void _addTask() {
    setState(() {
      if (_taskController.text.isNotEmpty) {
        _tasks.add(_taskController.text); // Add the text from the controller to the list.
        _taskController.clear(); // Clear the text field after adding the task.
      }
    });
  }

  @override
  void dispose() {
    _taskController.dispose(); // Dispose of the controller when the widget is removed from the tree.
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Entry App'), // Title of the app bar.
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Padding around the content.
        child: Column(
          children: [
            TextField(
              controller: _taskController, // Controller for handling the input.
              decoration: const InputDecoration(
                labelText: 'Enter Task', // Label shown in the text field.
                border: OutlineInputBorder(), // Border style for the text field.
              ),
            ),
            const SizedBox(height: 10), // Space between the text field and the button.
            ElevatedButton(
              onPressed: _addTask, // Action to perform when the button is pressed.
              child: const Text('Add Task'), // Text displayed on the button.
            ),
            const SizedBox(height: 20), // Space between the button and the list view.
            Expanded(
              child: ListView.builder(
                itemCount: _tasks.length, // Number of items in the list.
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_tasks[index]), // Display each task in a list tile.
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
