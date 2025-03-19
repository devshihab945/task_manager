import 'package:flutter/material.dart';
import 'package:task_manager/ui/screens/nav_task/add_new_task_screen.dart';
import 'package:task_manager/ui/widgets/summary_card.dart';
import 'package:task_manager/ui/widgets/task_card.dart';

class NewTaskScreen extends StatefulWidget {
  const NewTaskScreen({super.key});

  @override
  State<NewTaskScreen> createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends State<NewTaskScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          onPressed: _onTapAddNewTask, child: const Icon(Icons.add)),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildSummarySection(),
            ListView.separated(
              itemCount: 5,
              // if both column children need to scroll, then set primary to false
              // if only one child needs to scroll, then set primary to true can also use expanded
              primary: false,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return const TaskCard(
                  taskStatus: TaskStatus.sNew,
                );
              },
              separatorBuilder: (context, index) => const SizedBox(
                height: 8,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onTapAddNewTask() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddNewTaskScreen(),
      ),
    );
  }

  Widget _buildSummarySection() {
    return const SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SummaryCard(
            title: 'New',
            count: 12,
          ),
          SummaryCard(
            title: 'Progress',
            count: 23,
          ),
          SummaryCard(
            title: 'Complete',
            count: 25,
          ),
          SummaryCard(
            title: 'Cancelled',
            count: 10,
          ),
        ],
      ),
    );
  }
}
