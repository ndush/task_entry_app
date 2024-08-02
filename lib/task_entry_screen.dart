import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'task.dart';
import 'task_notifier.dart';

class TaskEntryScreen extends StatefulWidget {
  const TaskEntryScreen({super.key});

  @override
  _TaskEntryScreenState createState() => _TaskEntryScreenState();
}

class _TaskEntryScreenState extends State<TaskEntryScreen> with TaskNotifier {
  // List to store tasks
  final List<Task> _tasks = [];
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  DateTime _selectedDate = DateTime.now(); // Default to current date
  Priority _selectedPriority = Priority.Medium; // Default priority
  bool _isSelectionMode = false; // Track if selection mode is active
  final Set<Task> _selectedTasks = {}; // Store selected tasks

  // Method to add a new task
  void _addTask() {
    setState(() {
      if (_titleController.text.isNotEmpty) {
        _tasks.add(Task(
          id: Uuid().v4(), // Generate a unique ID for the task
          title: _titleController.text,
          description: _descriptionController.text,
          dueDate: _selectedDate,
          priority: _selectedPriority,
        ));
        _titleController.clear();
        _descriptionController.clear();
        _selectedDate = DateTime.now(); // Reset date to now
        _selectedPriority = Priority.Medium; // Reset priority to default
        _sortTasks(); // Ensure tasks are sorted by priority
      }
    });
  }

  // Method to select a date using a date picker
  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked; // Update selected date
      });
    }
  }

  // Method to toggle task completion status
  void _toggleTaskCompletion(Task task, bool isComplete) {
    setState(() {
      if (task.isComplete != isComplete) {
        task.isComplete = isComplete;
        if (task.isComplete) {
          logTaskCompletion(task); // Log task completion using mixin method
        }
      }
    });
  }

  // Method to sort tasks by priority
  void _sortTasks() {
    _tasks.sort((a, b) => a.priority.index.compareTo(b.priority.index));
  }

  // Method to delete a single task
  void _deleteTask(Task task) {
    setState(() {
      _tasks.remove(task); // Remove task from the list
    });
  }

  // Method to toggle between selection and normal modes
  void _toggleSelectionMode() {
    setState(() {
      _isSelectionMode = !_isSelectionMode; // Switch selection mode
      _selectedTasks.clear(); // Clear any previous selections
    });
  }

  // Method to toggle selection of a task
  void _toggleTaskSelection(Task task) {
    setState(() {
      if (_selectedTasks.contains(task)) {
        _selectedTasks.remove(task); // Deselect the task
      } else {
        _selectedTasks.add(task); // Select the task
      }
    });
  }

  // Method to delete all selected tasks
  void _deleteSelectedTasks() {
    setState(() {
      _tasks.removeWhere((task) => _selectedTasks.contains(task)); // Remove selected tasks
      _isSelectionMode = false; // Exit selection mode
      _selectedTasks.clear(); // Clear selections
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Entry App'),
        actions: [
          if (!_isSelectionMode) // Show edit icon only when not in selection mode
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: _toggleSelectionMode,
            ),
        ],
      ),
      body: Column(
        children: [
          // Form for adding new tasks
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: 'Enter Task Title',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Enter Task Description',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: Text('Due Date: ${DateFormat('yyyy-MM-dd').format(_selectedDate)}'),
                      ),
                      ElevatedButton(
                        onPressed: () => _selectDate(context),
                        child: const Text('Select Date'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Column(
                    children: [
                      const Text('Priority:'),
                      RadioListTile<Priority>(
                        title: const Text('High'),
                        value: Priority.High,
                        groupValue: _selectedPriority,
                        onChanged: (Priority? value) {
                          setState(() {
                            _selectedPriority = value!; // Update priority
                          });
                        },
                      ),
                      RadioListTile<Priority>(
                        title: const Text('Medium'),
                        value: Priority.Medium,
                        groupValue: _selectedPriority,
                        onChanged: (Priority? value) {
                          setState(() {
                            _selectedPriority = value!; // Update priority
                          });
                        },
                      ),
                      RadioListTile<Priority>(
                        title: const Text('Low'),
                        value: Priority.Low,
                        groupValue: _selectedPriority,
                        onChanged: (Priority? value) {
                          setState(() {
                            _selectedPriority = value!; // Update priority
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _addTask,
                    child: const Text('Add Task'),
                  ),
                ],
              ),
            ),
          ),
          // Controls for selection mode
          if (_isSelectionMode)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.black),
                    onPressed: _deleteSelectedTasks, // Delete selected tasks
                  ),
                  ElevatedButton(
                    onPressed: _toggleSelectionMode, // Cancel selection mode
                    child: const Text('Cancel Selection'),
                  ),
                ],
              ),
            ),
          // List of tasks
          Expanded(
            child: ListView.builder(
              itemCount: _tasks.length,
              itemBuilder: (context, index) {
                final task = _tasks[index];
                return Dismissible(
                  key: Key(task.id), // Unique key for each task
                  onDismissed: (direction) {
                    _deleteTask(task); // Delete task on swipe
                  },
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  child: ListTile(
                    title: Text(task.title),
                    subtitle: Text(
                      '${task.description} - Due: ${DateFormat('yyyy-MM-dd').format(task.dueDate)} - Priority: ${task.priority.toString().split('.').last}',
                    ),
                    trailing: _isSelectionMode
                        ? Checkbox(
                      value: _selectedTasks.contains(task),
                      onChanged: (bool? value) {
                        _toggleTaskSelection(task); // Toggle task selection
                      },
                    )
                        : Switch(
                      value: task.isComplete,
                      onChanged: (bool value) => _toggleTaskCompletion(task, value), // Toggle task completion
                    ),
                    onTap: _isSelectionMode
                        ? () {
                      _toggleTaskSelection(task); // Select or deselect task
                    }
                        : null,
                  ),
                );
              },
            ),
          ),
        ],
      ),
      backgroundColor: Colors.orange, // Set background color
    );
  }
}
