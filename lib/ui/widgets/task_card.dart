import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:task_manager/data/models/task_model.dart';
import 'package:task_manager/data/service/network_client.dart';
import 'package:task_manager/data/utils/urls.dart';
import 'package:task_manager/ui/widgets/snack_bar_message.dart';

enum TaskStatus {
  sNew,
  progress,
  completed,
  cancelled,
}

class TaskCard extends StatefulWidget {
  const TaskCard({
    super.key,
    required this.taskStatus,
    required this.taskModel,
    required this.refreshList,
  });

  final TaskStatus taskStatus;
  final TaskModel taskModel;
  final VoidCallback refreshList;

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  bool _inProgress = false;

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return Card(
      elevation: 0,
      color: Colors.white,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.taskModel.tittle,
              style: textTheme.titleLarge,
            ),
            Text(
              widget.taskModel.description,
              style: textTheme.bodyLarge,
            ),
            // TODO: format date with Date formatter (intl)
            Text(
              'Date: ${widget.taskModel.createdDate.isNotEmpty ? DateFormat.yMd().add_jm().format(DateTime.parse(widget.taskModel.createdDate)) : 'No date'}',
            ),
            Row(
              children: [
                Chip(
                  label: Text(
                    widget.taskModel.status,
                    style: TextStyle(color: Colors.white),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  backgroundColor: _getStatusChipColor(),
                  side: BorderSide.none,
                ),
                const Spacer(),
                Visibility(
                  visible: _inProgress == false,
                  replacement: const CircularProgressIndicator(),
                  child: Row(
                    children: [
                      IconButton(
                          onPressed: _showUpdateStatusDialog,
                          icon: Icon(
                            Icons.edit,
                            color: Colors.green,
                          )),
                      IconButton(
                          onPressed: () {
                            _deleteTask(widget.taskModel.id);
                          },
                          icon: Icon(
                            Icons.delete,
                            color: Colors.redAccent,
                          )),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Color _getStatusChipColor() {
    switch (widget.taskStatus) {
      case TaskStatus.sNew:
        return Colors.blue;
      case TaskStatus.progress:
        return Colors.purple;
      case TaskStatus.completed:
        return Colors.green;
      case TaskStatus.cancelled:
        return Colors.red;
    }
  }

  void _showUpdateStatusDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Update Status'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  onTap: () {
                    _popDialog();
                    if (isSelected('New')) return;
                    _updateTaskStatus('New');
                  },
                  leading: const Icon(Icons.new_label),
                  title: Text('New'),
                  trailing: isSelected('New') ? const Icon(Icons.check) : null,
                ),
                ListTile(
                  onTap: () {
                    _popDialog();
                    if (isSelected('Progress')) return;
                    _updateTaskStatus('Progress');
                  },
                  leading: const Icon(Icons.access_time),
                  title: Text('Progress'),
                  trailing:
                      isSelected('Progress') ? const Icon(Icons.check) : null,
                ),
                ListTile(
                  onTap: () {
                    _popDialog();
                    if (isSelected('Completed')) return;
                    _updateTaskStatus('Completed');
                  },
                  leading: const Icon(Icons.check_circle),
                  title: Text('Completed'),
                  trailing:
                      isSelected('Completed') ? const Icon(Icons.check) : null,
                ),
                ListTile(
                  onTap: () {
                    _popDialog();
                    if (isSelected('Cancelled')) return;
                    _updateTaskStatus('Cancelled');
                  },
                  leading: const Icon(Icons.cancel),
                  title: Text('Cancelled'),
                  trailing:
                      isSelected('Cancelled') ? const Icon(Icons.check) : null,
                ),
              ],
            ),
          );
        });
  }

  void _popDialog() {
    Navigator.pop(context);
  }

  bool isSelected(String status) => widget.taskModel.status == status;

  Future<void> _updateTaskStatus(String status) async {
    setState(() => _inProgress = true);

    final NetworkResponse response = await NetworkClient.getRequest(
        url: Urls.updateTaskStatusUrl(widget.taskModel.id, status));

    if (response.isSuccess) {
      widget.refreshList();
    } else {
      showSnackBarMessage(context, response.errorMessage.toString(), 1,
          isError: true);
    }

    setState(() => _inProgress = false);
  }

  Future<void> _deleteTask(String id) async {
    setState(() => _inProgress = true);

    final NetworkResponse response =
        await NetworkClient.getRequest(url: Urls.deleteTaskUrl(id));

    if (response.isSuccess) {
      widget.refreshList();
    } else {
      showSnackBarMessage(context, response.errorMessage.toString(), 1,
          isError: true);
    }

    setState(() => _inProgress = false);
  }
}
