import 'dart:convert';
import 'package:emanagement_mobile/Models/event_details_dto.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../Components/top_app_bar.dart';

class EventDetailsPageWidget extends StatefulWidget {
  final int eventId;

  const EventDetailsPageWidget({super.key, required this.eventId});

  @override
  State<EventDetailsPageWidget> createState() => _EventDetailsPageWidgetState();
}

class _EventDetailsPageWidgetState extends State<EventDetailsPageWidget> {
  late Future<EventDetailsDto> eventDetails;

  @override
  void initState() {
    super.initState();
    eventDetails = fetchEventDetails(widget.eventId);
  }

  Future<EventDetailsDto> fetchEventDetails(int eventId) async {
    final response = await http.get(Uri.parse('https://localhost:5001/api/Events/Details?eventId=$eventId'));

    if (response.statusCode == 200) {
      return EventDetailsDto.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load event details');
    }
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: eManagementTopAppBarPage(),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
            child: FutureBuilder<EventDetailsDto>(
              future: eventDetails,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  final event = snapshot.data!;
                  return SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image(
                            image: AssetImage(event.imageUrl),
                            width: double.infinity,
                            height: 200,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(0, 5, 0, 0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                event.title,
                                textAlign: TextAlign.start,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                              Text(
                                event.eventStatusName,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: _getStatusColor(event.eventStatusName),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(0, 5, 0, 0),
                          child: Text(
                            event.subtitle,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(0, 5, 0, 0),
                          child: Container(
                            width: double.infinity,
                            height: 364,
                            decoration: BoxDecoration(
                              color: Colors.white70,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(5, 5, 5, 5),
                              child: Text(
                                event.description,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(0, 5, 0, 0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Created by ${event.createdByFullName}',
                                style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                event.formattedDate,
                                style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  return const Center(child: Text('No data available'));
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
