import 'package:emanagement_mobile/Context/api_handler.dart';
import 'package:emanagement_mobile/Models/task_details.dart';
import 'package:emanagement_mobile/Models/tasks_dto.dart';
import 'package:emanagement_mobile/Models/user_session.dart';
class TaskService {
  final ApiHandler apiHandler = ApiHandler(baseUrl: 'https://localhost:5001');

  Future<List<TaskDto>> getAll() async {
    try {
      final response = await apiHandler.getRequest('api/Tasks/GetAll');
      final List<dynamic> jsonResponse = response;
      List<TaskDto> data = jsonResponse.map((model) => TaskDto.fromJson(model)).toList();
      return data;
    } catch (e) {
      throw Exception('Failed to load tasks: $e');
    }
  }

  Future<TaskDetailsDto> fetchTaskDetails(int taskId) async {
    try {
      final response = await apiHandler.getRequest('api/Tasks/Details?taskId=$taskId&userId=${UserSession().userId}');
      return TaskDetailsDto.fromJson(response);
    } catch (e) {
      throw Exception('Failed to load task details: $e');
    }
  }

  Future<void> changeStatus(int taskId, String statusName) async {
    try {
      await apiHandler.postRequest('api/Tasks/ChangeStatus?taskId=$taskId&statusName=$statusName');
    } catch (e) {
      throw Exception('Failed to change task status: $e');
    }
  }

  Future<void> submitReview(int taskId, int review) async {
    try {
      await apiHandler.postRequest('api/TaskReview/Review?userId=${UserSession().userId}&taskId=$taskId&review=$review');
    } catch (e) {
      throw Exception('Failed to submit review: $e');
    }
  }
}
