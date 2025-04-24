import 'package:flutter/material.dart';
import 'package:task_manager/data/service/network_client.dart';
import 'package:task_manager/data/utils/urls.dart';
import 'package:task_manager/ui/widgets/centered_circular_progress_indicator.dart';
import 'package:task_manager/ui/widgets/screen_background.dart';
import 'package:task_manager/ui/widgets/snack_bar_message.dart';
import 'package:task_manager/ui/widgets/tm_app_bar.dart';

class AddNewTaskScreen extends StatefulWidget {
  const AddNewTaskScreen({super.key});

  @override
  State<AddNewTaskScreen> createState() => _AddNewTaskScreenState();
}

class _AddNewTaskScreenState extends State<AddNewTaskScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TMAppBar(),
      body: ScreenBackground(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 80),
                Text(
                  'Add New Task',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _titleController,
                  hintText: 'Title',
                  textInputAction: TextInputAction.next,
                  validatorMessage: 'Please enter a title',
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _descriptionController,
                  hintText: 'Description',
                  textInputAction: TextInputAction.done,
                  validatorMessage: 'Please enter a description',
                  maxLines: 5,
                ),
                const SizedBox(height: 24),
                _isSubmitting
                    ? const CenteredCircularProgressIndicator()
                    : SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _onTapAddNewTask,
                    child: const Text('Add Task'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required TextInputAction textInputAction,
    required String validatorMessage,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      textInputAction: textInputAction,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.grey),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: const OutlineInputBorder(),
      ),
      validator: (value) {
        if (value?.trim().isEmpty ?? true) {
          return validatorMessage;
        }
        return null;
      },
    );
  }

  void _onTapAddNewTask() {
    if (_formKey.currentState?.validate() ?? false) {
      _submitTask();
    }
  }

  Future<void> _submitTask() async {
    setState(() => _isSubmitting = true);

    final requestBody = {
      'title': _titleController.text.trim(),
      'description': _descriptionController.text.trim(),
      'status': 'New',
    };

    final response = await NetworkClient.postRequest(
      url: Urls.createTaskUrl,
      body: requestBody,
    );

    setState(() => _isSubmitting = false);

    if (response.isSuccess) {
      _clearFields();
      showSnackBarMessage(context, 'Task added successfully', 1);
    } else {
      showSnackBarMessage(
        context,
        response.errorMessage.toString(),
        1,
        isError: true,
      );
    }
  }

  void _clearFields() {
    _titleController.clear();
    _descriptionController.clear();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
