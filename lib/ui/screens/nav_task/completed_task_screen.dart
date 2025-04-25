import 'package:flutter/material.dart';
import 'package:task_manager/data/models/task_list_model.dart';
import 'package:task_manager/data/models/task_model.dart';
import 'package:task_manager/data/service/network_client.dart';
import 'package:task_manager/data/utils/urls.dart';
import 'package:task_manager/ui/widgets/centered_circular_progress_indicator.dart';
import 'package:task_manager/ui/widgets/snack_bar_message.dart';
import 'package:task_manager/ui/widgets/task_card.dart';

class CompleteTaskScreen extends StatefulWidget {
  const CompleteTaskScreen({super.key});

  @override
  State<CompleteTaskScreen> createState() => _CompleteTaskScreenState();
}

class _CompleteTaskScreenState extends State<CompleteTaskScreen> {

  bool _getCompletedTaskInProgress = false;
  List<TaskModel> _completedTaskList = [];

  @override
  void initState() {
    super.initState();
    _getAllCompletdTaskList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Visibility(
        visible: _getCompletedTaskInProgress == false,
        replacement: const CenteredCircularProgressIndicator(),
        child: ListView.separated(
          itemCount: _completedTaskList.length,
          itemBuilder: (context, index) {
            return TaskCard(
              taskStatus: TaskStatus.cancelled,
              taskModel: _completedTaskList[index],
              refreshList: _getAllCompletdTaskList,
            );
          },
          separatorBuilder: (context, index) => const SizedBox(
            height: 8,
          ),
        ),
      ),



    );
  }

  Future<void> _getAllCompletdTaskList() async {
    setState(() => _getCompletedTaskInProgress = true);

    final response = await NetworkClient.getRequest(url: Urls.completedTaskListUrl);

    if (response.isSuccess) {
      final data = TaskListModel.fromJson(response.data ?? {});
      _completedTaskList = data.taskList;
    } else {
      showSnackBarMessage(context, response.errorMessage.toString(), 1,
          isError: true);
    }

    setState(() => _getCompletedTaskInProgress = false);
  }

}
