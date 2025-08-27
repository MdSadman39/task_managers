import 'package:flutter/material.dart';
import 'package:task_managers/data/services/network_caller.dart';
import 'package:task_managers/data/utils/urls.dart';

import '../../data/model/task_model.dart';
import 'snack_bar_message.dart';

class TaskItemWidget extends StatefulWidget {
  const TaskItemWidget({super.key, required this.taskModel});

  final TaskModel taskModel;

  @override
  State<TaskItemWidget> createState() => _TaskItemWidgetState();
}

class _TaskItemWidgetState extends State<TaskItemWidget> {
  bool _getNewTaskListInProgress = false;
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 0,
      child: ListTile(
        tileColor: Colors.white,
        title: Text(widget.taskModel.title ?? ''),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.taskModel.description ?? ''),
            Text('Date: ${widget.taskModel.createdDate ?? ''}'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.0),
                    color: _getStatusColor(widget.taskModel.status ?? 'New'),
                  ),
                  child: Text(
                    widget.taskModel.status ?? 'New',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                Row(
                  children: [
                    IconButton(onPressed: () {}, icon: const Icon(Icons.edit)),
                    IconButton(
                      onPressed: () {
                        _deleteTaskItem(widget.taskModel.sId.toString());
                      },
                      icon: const Icon(Icons.delete, color: Colors.red),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _deleteTaskItem(String id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Task Item'),
          content: const Text('Are you sure you want to delete this task?'),
          actions: [
            TextButton(
              onPressed: () {
                _deleteTask(id);
                Navigator.pop(context);
              },
              child: const Text('Delete'),
            ),
            TextButton(
              onPressed: () {
                // Implement delete functionality
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteTask(String id) async {
    _getNewTaskListInProgress = true;
    setState(() {});
    final NetworkResponse response = await NetworkCaller.getRequest(
      url: Urls.deleteTaskUrl(id),
    );
    if (response.isSuccess) {
      showSnackBarMessage(context, 'Task deleted successfully');
    } else {
      showSnackBarMessage(context, response.errorMessage);
    }
    _getNewTaskListInProgress = false;
    setState(() {});
  }

  Color _getStatusColor(String status) {
    if (status == 'New') {
      return Colors.blue;
    } else if (status == 'Progress') {
      return Colors.yellow;
    } else if (status == 'Cancelled') {
      return Colors.red;
    } else {
      return Colors.green;
    }
  }
}
