import 'package:flutter/material.dart';
import 'package:task_manager/ui/widgets/task_card.dart';

class CompleteTaskScreen extends StatefulWidget {
  const CompleteTaskScreen({super.key});

  @override
  State<CompleteTaskScreen> createState() => _CompleteTaskScreenState();
}

class _CompleteTaskScreenState extends State<CompleteTaskScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: ListView.separated(
        itemCount: 5,
        itemBuilder: (context, index) {
          return const TaskCard(taskStatus: TaskStatus.completed,);
        },
        separatorBuilder: (context, index) => const SizedBox(
          height: 8,
        ),
      ),



    );
  }
}
