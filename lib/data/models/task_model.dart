class TaskModel{
  late final String id;
  late final String tittle;
  late final String description;
  late final String status;
  late final String createdDate;

  TaskModel.fromJson(Map<String, dynamic> jsonData) {
    id = jsonData['_id'] ?? '';
    tittle = jsonData['tittle'] ?? '';
    description = jsonData['description'] ?? '';
    status = jsonData['status'];
    createdDate = jsonData['createdDate'] ?? '';
  }

}