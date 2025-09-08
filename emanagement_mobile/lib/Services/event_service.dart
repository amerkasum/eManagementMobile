import 'dart:convert';
import 'dart:io';

import 'package:emanagement_mobile/Context/api_handler.dart';
import 'package:emanagement_mobile/Models/Desktop/event_view_nodel.dart';

final isDesktop = !Platform.isAndroid && (Platform.isWindows || Platform.isMacOS || Platform.isLinux);
class EventService {
  
  final ApiHandler apiHandler = ApiHandler(baseUrl: isDesktop ? 'http://localhost:5001' : 'https://10.0.2.2:5001');

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
