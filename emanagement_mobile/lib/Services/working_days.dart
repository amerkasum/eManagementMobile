import 'dart:convert';
import 'dart:io';

import 'package:emanagement_mobile/Context/api_handler.dart';
import 'package:emanagement_mobile/Models/Desktop/event_view_nodel.dart';
import 'package:emanagement_mobile/Models/Helpers/working_days_basic_dto.dart';
import 'package:emanagement_mobile/Models/Helpers/working_days_dto.dart';
import 'package:emanagement_mobile/Services/Helpers/app_config.dart';

class WorkingDaysService {
  
  final ApiHandler apiHandler = ApiHandler(baseUrl: AppConfig.apiUrl);

  Future<WorkingDaysDto> getWorkingDaysByUserId(int userId) async {
    final response = await apiHandler.getRequest('api/WorkingDays/GetByUserId?userId=$userId');
    return WorkingDaysDto.fromJson(response);
  }

  Future<void> editWorkingDays(List<WorkingDaysBasicDto> models) async {
  try {
    final List<Map<String, dynamic>> jsonList =
        models.map((e) => e.toJson()).toList();

    // Assuming apiHandler has a method that returns full response
    final response = await apiHandler.postListRequest(
      'api/WorkingDays/EditWorkingDays',
      body: jsonList,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      print("WorkingDays updated successfully");
    } else {
      print("Failed to update working days: ${response.body}");
    }
  } catch (e) {
    print("An error occurred while updating the working days: $e");
  }
}



}