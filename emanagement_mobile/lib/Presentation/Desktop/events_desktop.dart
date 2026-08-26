import 'dart:convert';
import 'dart:io';
import 'package:emanagement_mobile/Components/top_app_bar.dart';
import 'package:emanagement_mobile/Models/events_dto.dart';
import 'package:emanagement_mobile/Components/bottom_navigation_bar.dart';
import 'package:emanagement_mobile/Presentation/Desktop/event_form.dart';
import 'package:emanagement_mobile/Presentation/event_details.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart' show kIsWeb;

import '../../Context/api_handler.dart';
import '../../Services/Helpers/app_config.dart';

final ApiHandler apiHandler = ApiHandler(baseUrl: AppConfig.apiUrl);

class EventsDesktopPage extends StatefulWidget {
  const EventsDesktopPage({super.key});

  @override
  State<EventsDesktopPage> createState() => _EventsDesktopWidgetState();
}

class _EventsDesktopWidgetState extends State<EventsDesktopPage> {
  late List<EventsDto> data = [];
  late List<EventsDto> filteredData = [];
  String selectedStatus = 'All';
  final List<String> eventStatusNames = ['All', 'UPCOMING', 'FINISHED', 'ONGOING', 'CANCELLED'];

  Future<List<EventsDto>> getAll() async {
    final isDesktop = !kIsWeb && (Platform.isWindows || Platform.isMacOS || Platform.isLinux);
    //    final isDesktop = !Platform.isAndroid && (Platform.isWindows || Platform.isMacOS || Platform.isLinux);
    final response = await http.get(Uri.parse(apiHandler.baseUrl + '/api/Events/GetAll'),headers: <String, String>{
        "Content-type": "application/json; charset=UTF-8"
      },
    );

    /*final response = await http.get(Uri.parse(isDesktop ? 'http://localhost:5001/api/Events/GetAll' : 'http://10.0.2.2:5001/api/Events/GetAll'),headers: <String, String>{
        "Content-type": "application/json; charset=UTF-8"
      },
    );*/

    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse = jsonDecode(response.body);
      data = jsonResponse.map((model) => EventsDto.fromJson(model)).toList();
      filteredData = data; 
      setState(() {});
    } else {
      throw Exception('Failed to load events');
    }

    return data;
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'finished':
        return Colors.green;
      case 'ongoing':
        return Colors.blue;
      case 'upcoming':
        return Colors.orange;
      case 'cancelled':
        return Colors.grey;
      default:
        return Colors.black; 
    }
  }

  void filterEvents() {
    setState(() {
      if (selectedStatus == 'All') {
        filteredData = data;
      } else {
        filteredData = data.where((event) => event.eventStatusName == selectedStatus).toList();
      }
    });
  }

  @override
  void initState() {
    getAll();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = !kIsWeb && (Platform.isWindows || Platform.isMacOS || Platform.isLinux);
    return Scaffold(
      appBar: eManagementTopAppBarPage(title: "Events"),
      bottomNavigationBar: eManagementBottomNavigationBar(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0), 
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: selectedStatus,
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          selectedStatus = newValue;
                          filterEvents();
                        });
                      }
                    },
                    items: eventStatusNames.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(value: value, child: Text(value));
                    }).toList(),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 10.0),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.grey, width: 1.0),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.green, width: 1.0),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    dropdownColor: Colors.white,
                    isExpanded: true,
                  ),
                ),
                if (isDesktop)
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => EventForm()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Add Event'),
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(20),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,  
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                childAspectRatio: 1.0,  // Adjust this ratio for card size
              ),
              itemCount: filteredData.length,
              itemBuilder: (BuildContext context, int index) {
                final event = filteredData[index];
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EventDetailsPageWidget(eventId: event.id),
                      ),
                    );
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image(
                            image: AssetImage(event.imageUrl), 
                            width: double.infinity,
                            height: 250,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Image.asset("assets/default.jpg");
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            event.title,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            event.subtitle,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            event.eventStatusName,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: _getStatusColor(event.eventStatusName),
                              fontSize: 12,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            event.startDateFormatted,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
