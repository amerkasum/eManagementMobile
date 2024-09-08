import 'dart:io';
import 'package:emanagement_mobile/Models/Desktop/event_view_nodel.dart';
import 'package:emanagement_mobile/Models/user_session.dart';
import 'package:emanagement_mobile/Presentation/events.dart';
import 'package:emanagement_mobile/Services/event_service.dart';
import 'package:flutter/material.dart';
import 'package:emanagement_mobile/Models/Helpers/select_list_helper.dart';
import 'package:emanagement_mobile/Services/Helpers/helpers.dart';
import 'package:emanagement_mobile/Components/bottom_navigation_bar.dart';
import 'package:emanagement_mobile/Presentation/Desktop/users_desktop.dart';
import 'package:image_picker/image_picker.dart';
import 'package:emanagement_mobile/Models/user_session.dart' as user_session;

import '../../Components/top_app_bar.dart';

class EventForm extends StatefulWidget {
  @override
  _EventFormState createState() => _EventFormState();
}

class _EventFormState extends State<EventForm> {
  final _formKey = GlobalKey<FormState>();

  EventViewModel eventViewModel = EventViewModel(); 
  List<SelectListHelper> eventStatuses = [];

  ApiService apiService = ApiService();
  EventService eventService = EventService();

  File? _profileImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _fetchDropdownData();
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _fetchDropdownData() async {
    try {
      final eventStatusesFetchedData = await apiService.fetchEventStatuses();
      setState(() {
        eventStatuses = eventStatusesFetchedData;
      });
    } catch (e) {
      print('Failed to fetch data: $e');
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: eventViewModel.date ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        eventViewModel.date = pickedDate;
      });
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();

      eventViewModel.createdById = user_session.UserSession().userId;

      if (_profileImage != null) {
        final imagePath = 'assets/event_images/${DateTime.now().millisecondsSinceEpoch}.jpg';
        await _profileImage!.copy(imagePath);

        eventViewModel.imageUrl = imagePath;
      }

      await eventService.createEvent(eventViewModel);

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const EventsPage()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      appBar: eManagementTopAppBarPage(title: "Add Event"),
      bottomNavigationBar: eManagementBottomNavigationBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32.0),
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: _pickImage,
                      child: Container(
                        width: isDesktop ? 500 : double.infinity,
                        height: 300,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey, width: 2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: _profileImage != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.file(
                                  _profileImage!,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Center(
                                child: Icon(
                                  Icons.add_a_photo,
                                  size: 40,
                                  color: Colors.grey[700],
                                ),
                              ),
                      ),
                    ),
                    SizedBox(width: isDesktop ? 16 : 0),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Title',
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                            ),
                            onSaved: (value) => eventViewModel.title = value ?? '',
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a title';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Subtitle',
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                            ),
                            onSaved: (value) => eventViewModel.subtitle = value ?? '',
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a subtitle';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          DropdownButtonFormField(
                            decoration: const InputDecoration(
                              labelText: 'Event Status',
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                            ),
                            items: eventStatuses.map((SelectListHelper status) {
                              return DropdownMenuItem(
                                value: status.id,
                                child: Text(status.name),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                eventViewModel.eventStatusId = value;
                              });
                            },
                            onSaved: (value) {
                              eventViewModel.eventStatusId;
                            },
                            validator: (value) {
                              if (value == null) {
                                return 'Please select an event status';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          GestureDetector(
                            onTap: () => _selectDate(context),
                            child: AbsorbPointer(
                              child: TextFormField(
                                decoration: const InputDecoration(
                                  labelText: 'Event Date',
                                  border: OutlineInputBorder(),
                                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                                ),
                                controller: TextEditingController(
                                  text: eventViewModel.date != null
                                      ? '${eventViewModel.date!.toLocal().toString().split(' ')[0]}'
                                      : '',
                                ),
                                validator: (value) {
                                  if (eventViewModel.date == null) {
                                    return 'Please select an event date';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextFormField(
                  maxLines: 5,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  ),
                  onSaved: (value) => eventViewModel.description = value ?? '',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      _formKey.currentState?.save();
                      _submitForm();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 32),
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                  child: const Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
