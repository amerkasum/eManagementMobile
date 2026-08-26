import 'dart:convert';
import 'dart:io';

import 'package:emanagement_mobile/Context/api_handler.dart';
import 'package:emanagement_mobile/Models/Desktop/event_view_nodel.dart';
import 'Helpers/app_config.dart';

class EventService {
  
  final ApiHandler apiHandler = ApiHandler(baseUrl: AppConfig.apiUrl);

  // eventService.createEvent
Future<void> createEvent(EventViewModel event) async {
  try {
      final eventJson = event.toJson();
  
      final response = await apiHandler.postRequest(
        'api/Events/Add',
        body: eventJson,
      );
  
      print('Response Body: ${response.body}');
    } catch (e) {
      print('Error creating event: $e');
    }
  }

}
