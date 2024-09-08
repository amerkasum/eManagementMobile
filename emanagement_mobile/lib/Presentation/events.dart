import 'dart:convert';
import 'dart:io';
import 'package:emanagement_mobile/Models/events_dto.dart';
import 'package:emanagement_mobile/Components/bottom_navigation_bar.dart';
import 'package:emanagement_mobile/Presentation/Desktop/event_form.dart';
import 'package:emanagement_mobile/Presentation/event_details.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart' show kIsWeb;

import '../Components/top_app_bar.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({super.key});

  @override
  State<EventsPage> createState() => _EventsWidgetState();
}

class _EventsWidgetState extends State<EventsPage> {
  late List<EventsDto> data = [];
  late List<EventsDto> filteredData = [];
  String selectedStatus = 'All';
  final List<String> eventStatusNames = ['All', 'UPCOMING', 'FINISHED', 'ONGOING', 'CANCELLED'];

  Future<List<EventsDto>> getAll() async {
    final response = await http.get(
      Uri.parse('https://localhost:5001/api/Events/GetAll'),
      headers: <String, String>{
        "Content-type": "application/json; charset=UTF-8"
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse = jsonDecode(response.body);
      data = jsonResponse.map((model) => EventsDto.fromJson(model)).toList();
      filteredData = data; // Initially show all events
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
        return Colors.black; // Default color if the status doesn't match any case
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
            padding: const EdgeInsets.all(15.0), // Adjust the padding as needed
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
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
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
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: filteredData.length,
              itemBuilder: (BuildContext context, int index) {
                final event = filteredData[index];
                return Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EventDetailsPageWidget(eventId: event.id),
                        ),
                      );
                    },
                    child: Container(
                      width: 442,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.white70,
                        borderRadius: const BorderRadius.all(Radius.circular(8)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image(
                              image: AssetImage(event.imageUrl), // Gets a random image of 600x600 pixels
                              width: 120,
                              height: 200,
                              fit: BoxFit.cover,
                              errorBuilder:  (context, error, stacTrace) {
                                return Image.asset("assets/default.jpg");
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(125, 0, 0, 0),
                            child: Text(
                              event.title,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(126, 25, 0, 0),
                            child: Text(
                              event.subtitle,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(125, 75, 0, 0),
                            child: Text(
                              event.eventStatusName,
                              style: TextStyle(fontWeight: FontWeight.w600, color: _getStatusColor(event.eventStatusName), letterSpacing: 1.2, fontSize: 12),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end, // Aligns the text to the right
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(5), // Adds 5px padding
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
                        ],
                      ),
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
