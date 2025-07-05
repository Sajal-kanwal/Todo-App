import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

enum TaskPriority {
  low(name: 'Low', color:  Color(0xFF4CAF50)),
  medium(name: 'Medium', color:  Color(0xFFFF9800)),
  high(name: 'High', color:  Color(0xFFF44336));

  const TaskPriority({required this.name, required this.color});
  final String name;
  final Color color;
}

class Task {
  final String id;
  String title;
  bool isCompleted;
  TaskPriority priority;
  DateTime createdAt;

  Task({
    required this.id,
    required this.title,
    this.isCompleted = false,
    this.priority = TaskPriority.medium,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Task copyWith({
    String? id,
    String? title,
    bool? isCompleted,
    TaskPriority? priority,
    DateTime? createdAt,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
      priority: priority ?? this.priority,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class TodoModel extends ChangeNotifier {
  final List<Task> _tasks = [];

  List<Task> get tasks => _tasks;

  List<Task> get completedTasks => _tasks.where((task) => task.isCompleted).toList();

  List<Task> get pendingTasks => _tasks.where((task) => !task.isCompleted).toList();

  int get totalTasks => _tasks.length;

  int get completedTasksCount => completedTasks.length;

  int get pendingTasksCount => pendingTasks.length;

  void addTask(String title, TaskPriority priority) {
    if (title.trim().isEmpty) return;

    final task = Task(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title.trim(),
      priority: priority,
    );

    _tasks.add(task);
    _sortTasks();
    notifyListeners();
  }

  void toggleTask(String id) {
    final index = _tasks.indexWhere((task) => task.id == id);
    if (index >= 0) {
      _tasks[index].isCompleted = !_tasks[index].isCompleted;
      _sortTasks();
      notifyListeners();
    }
  }

  void deleteTask(String id) {
    _tasks.removeWhere((task) => task.id == id);
    notifyListeners();
  }

  void updateTask(String id, String newTitle, TaskPriority newPriority) {
    final index = _tasks.indexWhere((task) => task.id == id);
    if (index >= 0) {
      _tasks[index].title = newTitle.trim();
      _tasks[index].priority = newPriority;
      _sortTasks();
      notifyListeners();
    }
  }

  void clearCompleted() {
    _tasks.removeWhere((task) => task.isCompleted);
    notifyListeners();
  }

  void _sortTasks() {
    _tasks.sort((a, b) {
      // First sort by completion status (pending first)
      if (a.isCompleted != b.isCompleted) {
        return a.isCompleted ? 1 : -1;
      }
      
      // Then sort by priority (high to low)
      final priorityOrder = {
        TaskPriority.high: 3,
        TaskPriority.medium: 2,
        TaskPriority.low: 1,
      };
      
      return priorityOrder[b.priority]!.compareTo(priorityOrder[a.priority]!);
    });
  }
}