import 'package:get/get.dart';
import 'package:task_manager/data/models/login_model.dart';
import 'package:task_manager/data/models/task_list_model.dart';
import 'package:task_manager/data/models/task_model.dart';
import 'package:task_manager/data/service/network_client.dart';
import 'package:task_manager/data/utils/urls.dart';
import 'package:task_manager/ui/controllers/auth_controller.dart';

class NewTaskController extends GetxController {
  bool _getNewTaskInProgress = false;

  bool get getNewTaskInProgress => _getNewTaskInProgress;

  String? _errorMessage;

  String? get errorMessage => _errorMessage;

  List<TaskModel> _newTaskList = [];

  List<TaskModel> get newTaskList => _newTaskList;

  Future<bool> getNewTaskList() async {
    bool isSuccess = false;

    _getNewTaskInProgress = true;
    update();

    final response = await NetworkClient.getRequest(url: Urls.newTaskListUrl);

    if (response.isSuccess) {
      final parsed = TaskListModel.fromJson(response.data ?? {});
      _newTaskList = parsed.taskList;

      isSuccess = true;
    } else {
      _errorMessage = response.errorMessage;
    }

    _getNewTaskInProgress = false;
    update();

    return isSuccess;
  }
}
