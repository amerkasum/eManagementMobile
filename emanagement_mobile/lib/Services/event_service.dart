import 'dart:convert';
import 'dart:io';

import 'package:emanagement_mobile/Context/api_handler.dart';
import 'package:emanagement_mobile/Models/Desktop/event_view_nodel.dart';
import 'Helpers/app_config.dart';

class EventService {
  
  final ApiHandler apiHandler = ApiHandler(baseUrl: AppConfig.apiUrl);

  // eventService.createEvent
 dynamic createEvent(EventViewModel event) async {
  try {
  
      final response = await apiHandler.postRequest(
        'api/Events/Add',
        body: event.toJson()
      );
      print('Response Body: ${response}');

      return response;
    } catch (e) {
      throw Exception("Create event failed: $e");
    }
  }

  dynamic deleteEvent(int id) async {
    final response = await apiHandler.deleteRequest(
      ('api/Events/Delete?id=$id'),
    );

    final data = response;
    return data;
  }

}
