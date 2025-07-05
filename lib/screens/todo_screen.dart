import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/todo_model.dart';
import '../widgets/task_input_widget.dart';
import '../widgets/task_list_widget.dart';
import '../widgets/task_stats_widget.dart';

class TodoScreen extends StatelessWidget {
  const TodoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'To-Do',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w300,
          ),
        ),
        centerTitle: true,
        actions: [
          Consumer<TodoModel>(
            builder: (context, todoModel, child) {
              if (todoModel.completedTasksCount > 0) {
                return TextButton(
                  onPressed: () {
                    _showClearCompletedDialog(context, todoModel);
                  },
                  child: Text(
                    'Clear',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          TaskStatsWidget(),
          TaskInputWidget(),
          Expanded(
            child: TaskListWidget(),
          ),
        ],
      ),
    );
  }

  void _showClearCompletedDialog(BuildContext context, TodoModel todoModel) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Completed Tasks'),
        content: const Text('Are you sure you want to delete all completed tasks?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              todoModel.clearCompleted();
              Navigator.pop(context);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}