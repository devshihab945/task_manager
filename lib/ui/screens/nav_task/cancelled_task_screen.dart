import 'package:flutter/material.dart';
import 'package:task_manager/ui/widgets/task_card.dart';

class CancelledTaskScreen extends StatefulWidget {
  const CancelledTaskScreen({super.key});

  @override
  State<CancelledTaskScreen> createState() => _CancelledTaskScreenState();
}

class _CancelledTaskScreenState extends State<CancelledTaskScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: ListView.separated(
        itemCount: 5,
        itemBuilder: (context, index) {
          return const TaskCard( status: 'Cancelled', color: Colors.red,);
        },
        separatorBuilder: (context, index) => const SizedBox(
          height: 8,
        ),
      ),



    );
  }
}
