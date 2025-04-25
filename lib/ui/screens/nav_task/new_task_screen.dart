import 'package:flutter/material.dart';
import 'package:task_manager/data/models/task_status_count.dart';
import 'package:task_manager/data/models/task_status_count_list_model.dart';
import 'package:task_manager/data/service/network_client.dart';
import 'package:task_manager/data/utils/urls.dart';
import 'package:task_manager/ui/screens/nav_task/add_new_task_screen.dart';
import 'package:task_manager/ui/widgets/snack_bar_message.dart';
import 'package:task_manager/ui/widgets/summary_card.dart';
import 'package:task_manager/ui/widgets/task_card.dart';

class NewTaskScreen extends StatefulWidget {
  const NewTaskScreen({super.key});

  @override
  State<NewTaskScreen> createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends State<NewTaskScreen> {
  bool _isLoading = false;
  List<TaskStatusCountModel> _statusCounts = [];

  @override
  void initState() {
    super.initState();
    _fetchTaskStatusCounts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddTask,
        child: const Icon(Icons.add),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildSummarySection(),
            const SizedBox(height: 8),
            _buildTaskList(),
          ],
        ),
      ),
    );
  }

  void _navigateToAddTask() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AddNewTaskScreen()),
    );
  }

  Widget _buildSummarySection() {
    // Ideally use _statusCounts instead of static values once API is fully integrated
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: 110,
        child: ListView.builder(
            itemCount: _statusCounts.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return SummaryCard(
                  title: _statusCounts[index].status,
                  count: _statusCounts[index].count);
            }),
      ),
    );
  }

  Widget _buildTaskList() {
    return ListView.separated(
      itemCount: 5,
      // Replace with dynamic list length when available
      primary: false,
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemBuilder: (_, index) => const TaskCard(taskStatus: TaskStatus.sNew),
      separatorBuilder: (_, __) => const SizedBox(height: 8),
    );
  }

  Future<void> _fetchTaskStatusCounts() async {
    setState(() => _isLoading = true);

    final response =
        await NetworkClient.getRequest(url: Urls.taskStatusCountUrl);

    if (response.isSuccess) {
      final parsed = TaskStatusCountListModel.fromJson(response.data ?? {});
      _statusCounts = parsed.statusCountList;
    } else {
      showSnackBarMessage(context, response.errorMessage.toString(), 1,
          isError: true);
    }

    setState(() => _isLoading = false);
  }
}
