import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'task.dart';
import 'task_notifier.dart';

// The main widget for the task entry screen, which is stateful.
class TaskEntryScreen extends StatefulWidget {
  const TaskEntryScreen({super.key});

  @override
  _TaskEntryScreenState createState() => _TaskEntryScreenState();
}

// State class for TaskEntryScreen, managing the state and functionality.
class _TaskEntryScreenState extends State<TaskEntryScreen> with TaskNotifier {
  final List<Task> _tasks = []; // List to store the tasks.
  final TextEditingController _titleController = TextEditingController(); // Controller for the title input field.
  final TextEditingController _descriptionController = TextEditingController(); // Controller for the description input field.
  DateTime _selectedDate = DateTime.now(); // Default date for new tasks.
  Priority _selectedPriority = Priority.Medium; // Default priority level for new tasks.

  // Method to add a new task to the list.
  void _addTask() {
    setState(() {
      if (_titleController.text.isNotEmpty) { // Ensure title is not empty.
        _tasks.add(Task(
          title: _titleController.text,
          description: _descriptionController.text,
          dueDate: _selectedDate,
          priority: _selectedPriority,
        ));
        _titleController.clear(); // Clear the title field.
        _descriptionController.clear(); // Clear the description field.
        _selectedDate = DateTime.now(); // Optionally reset the date to the current date.
        _selectedPriority = Priority.Medium; // Optionally reset the priority to medium.
        _sortTasks(); // Sort tasks by priority after adding a new one.
      }
    });
  }

  // Method to show a date picker and update the selected date.
  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked; // Update the selected date.
      });
    }
  }

  // Method to toggle the completion status of a task.
  void _toggleTaskCompletion(Task task, bool isComplete) {
    setState(() {
      if (task.isComplete != isComplete) {
        task.isComplete = isComplete; // Update the task's completion status.
        if (task.isComplete) {
          logTaskCompletion(task); // Log completion if task is marked complete.
        }
      }
    });
  }

  // Method to sort tasks by priority in descending order (High to Low).
  void _sortTasks() {
    _tasks.sort((a, b) => a.priority.index.compareTo(b.priority.index)); // Sort tasks by priority index.
  }

  @override
  void dispose() {
    _titleController.dispose(); // Dispose of the title controller when the widget is removed.
    _descriptionController.dispose(); // Dispose of the description controller when the widget is removed.
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Entry App'), // App bar title.
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0), // Padding for the input fields and buttons.
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _titleController, // Controller for the title field.
                    decoration: const InputDecoration(
                      labelText: 'Enter Task Title', // Label for the title input field.
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10), // Spacing between fields.
                  TextField(
                    controller: _descriptionController, // Controller for the description field.
                    decoration: const InputDecoration(
                      labelText: 'Enter Task Description', // Label for the description input field.
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: Text('Due Date: ${DateFormat('yyyy-MM-dd').format(_selectedDate)}'), // Display the selected date.
                      ),
                      ElevatedButton(
                        onPressed: () => _selectDate(context), // Button to open the date picker.
                        child: const Text('Select Date'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Column(
                    children: [
                      const Text('Priority:'), // Label for priority selection.
                      RadioListTile<Priority>(
                        title: const Text('High'), // Option for High priority.
                        value: Priority.High,
                        groupValue: _selectedPriority,
                        onChanged: (Priority? value) {
                          setState(() {
                            _selectedPriority = value!; // Update the selected priority.
                          });
                        },
                      ),
                      RadioListTile<Priority>(
                        title: const Text('Medium'), // Option for Medium priority.
                        value: Priority.Medium,
                        groupValue: _selectedPriority,
                        onChanged: (Priority? value) {
                          setState(() {
                            _selectedPriority = value!; // Update the selected priority.
                          });
                        },
                      ),
                      RadioListTile<Priority>(
                        title: const Text('Low'), // Option for Low priority.
                        value: Priority.Low,
                        groupValue: _selectedPriority,
                        onChanged: (Priority? value) {
                          setState(() {
                            _selectedPriority = value!; // Update the selected priority.
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _addTask, // Button to add a new task.
                    child: const Text('Add Task'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: _tasks.length, // Number of tasks to display.
              itemBuilder: (context, index) {
                final task = _tasks[index]; // Get the task at the current index.
                return ListTile(
                  title: Text(task.title), // Display the task title.
                  subtitle: Text(
                    '${task.description} - Due: ${DateFormat('yyyy-MM-dd').format(task.dueDate)} - Priority: ${task.priority.toString().split('.').last}', // Display the task details.
                  ),
                  trailing: Switch(
                    value: task.isComplete, // Switch to toggle task completion status.
                    onChanged: (bool value) => _toggleTaskCompletion(task, value),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
