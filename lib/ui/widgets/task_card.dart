import 'package:flutter/material.dart';

enum TaskStatus {
  sNew,
  progress,
  completed,
  cancelled,
}

class TaskCard extends StatelessWidget {
  const TaskCard({
    super.key,
    required this.taskStatus,
  });

  final TaskStatus taskStatus;

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
              'Tittle will show here...',
              style: textTheme.titleLarge,
            ),
            Text(
              'Description will show here...',
              style: textTheme.bodyLarge,
            ),
            Text('Date time will show here...'),
            Row(
              children: [
                Chip(
                  label: Text(
                    _getTaskStatus()
                    ,
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
                IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.edit,
                      color: Colors.green,
                    )),
                IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.delete,
                      color: Colors.redAccent,
                    )),
              ],
            )
          ],
        ),
      ),
    );
  }

  Color _getStatusChipColor() {
    switch (taskStatus) {
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

  String _getTaskStatus() {
    switch (taskStatus) {
      case TaskStatus.sNew:
        return 'New';
      case TaskStatus.progress:
        return 'Progress';
      case TaskStatus.completed:
        return 'Completed';
      case TaskStatus.cancelled:
        return 'Cancelled';
    }
  }

}
