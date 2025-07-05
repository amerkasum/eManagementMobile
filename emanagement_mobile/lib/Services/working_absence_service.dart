import 'dart:io';

import 'package:emanagement_mobile/Context/api_handler.dart';
import 'package:emanagement_mobile/Models/user_session.dart';

import 'package:emanagement_mobile/Models/working_absence_basic_dto.dart';
import 'package:emanagement_mobile/Models/working_absence_view_model.dart';

final isDesktop = !Platform.isAndroid && (Platform.isWindows || Platform.isMacOS || Platform.isLinux);
class WorkingAbsenceService {
  final ApiHandler apiHandler = ApiHandler(baseUrl: isDesktop ? 'http://localhost:5001' : 'http://10.0.2.2:5001');

  Future<List<WorkingAbsenceBasicDto>> getWorkingAbsences() async {
    final response = await apiHandler.getRequest('api/WorkingAbsence/GetWorkingAbsences?userId=${UserSession().userId}');
    final List<dynamic> jsonResponse = response as List<dynamic>;
    return jsonResponse.map((model) => WorkingAbsenceBasicDto.fromJson(model)).toList();
  }

  Future<void> changeStatus(int workingAbsenceId, String statusName) async {
    try {
      await apiHandler.postRequest('api/WorkingAbsence/ChangeStatus?workingAbsenceId=$workingAbsenceId&statusName=$statusName');
    } catch (e) {
      throw Exception('Failed to change working absence status: $e');
    }
  }

  Future<void> createWorkingAbsence(WorkingAbsenceViewModel workingAbsence) async {
    try {
     
      final userJson = workingAbsence.toJson(); 
  
      final response = await apiHandler.postRequest(
        'api/WorkingAbsence/Add',
        body: userJson, 
      );
  
      if (response.statusCode == 201) {

        print("User created successfully");
      } else {
        print("Failed to create user: ${response.body}");
      }
    } catch (e) {
      print("An error occurred while creating the user: $e");
    }
  }
}
