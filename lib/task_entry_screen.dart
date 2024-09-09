import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'task.dart';
import 'task_manager.dart';

class TaskEntryScreen extends StatefulWidget {
  final TaskManager taskManager;

  const TaskEntryScreen({Key? key, required this.taskManager}) : super(key: key);

  @override
  _TaskEntryScreenState createState() => _TaskEntryScreenState();
}

class _TaskEntryScreenState extends State<TaskEntryScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  Priority _selectedPriority = Priority.Medium;
  bool _isSelectionMode = false;
  final Set<Task> _selectedTasks = {};

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _addTask() {
    setState(() {
      widget.taskManager.addTask(
        _titleController.text,
        _descriptionController.text,
        _selectedDate,
        _selectedPriority,
      );
      _titleController.clear();
      _descriptionController.clear();
      _selectedDate = DateTime.now();
      _selectedPriority = Priority.Medium;
    });
  }

  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _toggleTaskCompletion(Task task, bool isComplete) {
    setState(() {
      if (task.isComplete != isComplete) {
        task.isComplete = isComplete;
        if (task.isComplete) {
          _logTaskCompletion(task);
        }
      }
    });
  }

  void _logTaskCompletion(Task task) {
    print('Task "${task.title}" completed!');
  }

  void _toggleSelectionMode() {
    setState(() {
      _isSelectionMode = !_isSelectionMode;
      _selectedTasks.clear();
    });
  }

  void _toggleTaskSelection(Task task) {
    setState(() {
      if (_selectedTasks.contains(task)) {
        _selectedTasks.remove(task);
      } else {
        _selectedTasks.add(task);
      }
    });
  }

  void _deleteSelectedTasks() {
    setState(() {
      for (final task in _selectedTasks) {
        widget.taskManager.deleteTask(task);
      }
      _isSelectionMode = false;
      _selectedTasks.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Entry App'),
        actions: [
          if (!_isSelectionMode)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: _toggleSelectionMode,
            ),
        ],
      ),
      body: Column(
        children: [
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
                            _selectedPriority = value!;
                          });
                        },
                      ),
                      RadioListTile<Priority>(
                        title: const Text('Medium'),
                        value: Priority.Medium,
                        groupValue: _selectedPriority,
                        onChanged: (Priority? value) {
                          setState(() {
                            _selectedPriority = value!;
                          });
                        },
                      ),
                      RadioListTile<Priority>(
                        title: const Text('Low'),
                        value: Priority.Low,
                        groupValue: _selectedPriority,
                        onChanged: (Priority? value) {
                          setState(() {
                            _selectedPriority = value!;
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
          if (_isSelectionMode)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.black),
                    onPressed: _deleteSelectedTasks,
                  ),
                  ElevatedButton(
                    onPressed: _toggleSelectionMode,
                    child: const Text('Cancel Selection'),
                  ),
                ],
              ),
            ),
          Expanded(
            child: ListView.builder(
              itemCount: widget.taskManager.getTasks().length,
              itemBuilder: (context, index) {
                final task = widget.taskManager.getTasks()[index];
                return Dismissible(
                  key: Key(task.id),
                  onDismissed: (direction) {
                    widget.taskManager.deleteTask(task);
                    setState(() {}); // Refresh UI after deletion
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
                        _toggleTaskSelection(task);
                      },
                    )
                        : Switch(
                      value: task.isComplete,
                      onChanged: (bool value) => _toggleTaskCompletion(task, value),
                    ),
                    onTap: _isSelectionMode
                        ? () {
                      _toggleTaskSelection(task);
                    }
                        : null,
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
