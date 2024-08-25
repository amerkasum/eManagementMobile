import 'package:emanagement_mobile/Context/api_handler.dart';
import 'package:emanagement_mobile/Models/Desktop/event_view_nodel.dart';


class EventService {
  final ApiHandler apiHandler = ApiHandler(baseUrl: 'https://localhost:5001');



  Future<void> createEvent(EventViewModel user) async {
    try {
     
      final eventJson = user.toJson(); 
  
      final response = await apiHandler.postRequest(
        'api/Events/Add',
        body: eventJson, 
      );
  
      if (response.statusCode == 201) {

        print("Event created successfully");
      } else {
        print("Failed to create user: ${response.body}");
      }
    } catch (e) {
      print("An error occurred while creating the event: $e");
    }
  }
}
