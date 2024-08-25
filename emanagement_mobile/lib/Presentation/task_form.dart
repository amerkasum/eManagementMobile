import 'package:emanagement_mobile/Components/bottom_navigation_bar.dart';
import 'package:emanagement_mobile/Models/Helpers/select_list_helper.dart';
import 'package:emanagement_mobile/Presentation/tasks.dart';
import 'package:emanagement_mobile/Services/Helpers/helpers.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:emanagement_mobile/Models/Desktop/task_view_model.dart';

import '../Components/top_app_bar.dart';

class MultiSelectDialog extends StatefulWidget {
  final List<SelectListHelper> users;
  final List<SelectListHelper> selectedUsers;

  MultiSelectDialog({required this.users, required this.selectedUsers});

  @override
  _MultiSelectDialogState createState() => _MultiSelectDialogState();
}

class _MultiSelectDialogState extends State<MultiSelectDialog> {
  late List<SelectListHelper> _tempSelectedUsers;

  @override
  void initState() {
    super.initState();
    _tempSelectedUsers = List.from(widget.selectedUsers);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Select Users'),
      content: SingleChildScrollView(
        child: ListBody(
          children: widget.users.map((user) {
            return CheckboxListTile(
              value: _tempSelectedUsers.contains(user),
              title: Text(user.name),
              controlAffinity: ListTileControlAffinity.leading,
              onChanged: (bool? value) {
                setState(() {
                  if (value == true) {
                    _tempSelectedUsers.add(user);
                  } else {
                    _tempSelectedUsers.remove(user);
                  }
                });
              },
            );
          }).toList(),
        ),
      ),
      actions: <Widget>[
        ElevatedButton(
          child: Text('Cancel'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        ElevatedButton(
          child: Text('OK'),
          onPressed: () {
            Navigator.pop(context, _tempSelectedUsers);
          },
        ),
      ],
    );
  }
}

class TaskForm extends StatefulWidget {
  @override
  _TaskFormState createState() => _TaskFormState();
}

class _TaskFormState extends State<TaskForm> {
  TaskViewModel _taskViewModel = TaskViewModel(
    name: '',
    description: '',
    dueDate: null,
    priority: 1,
    taskPriorityId: 1,
    taskStatusId: 1,
    cityId: 1,
    userIds: [],
  );

  ApiService apiService = ApiService();
  List<SelectListHelper> _priorities = []; 
  List<SelectListHelper> _users = [];
  List<SelectListHelper> _cities = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      // Fetch users and task priorities from the API
      List<SelectListHelper> fetchedUsers = await apiService.fetchUsers();
      List<SelectListHelper> fetchedPriorities = await apiService.fetchTaskPriosities();
      List<SelectListHelper> fetchedCities = await apiService.fetchCities();

      setState(() {
        _users = fetchedUsers;
        _priorities = fetchedPriorities;
        _cities = fetchedCities;
      });
    } catch (e) {
      print('Failed to fetch data: $e');
    }
  }
 
  Future<void> _submitForm() async {
    final url = 'https://localhost:5001/api/Tasks/Add';

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(_taskViewModel.toJson()),
    );

    if (response.statusCode == 200) {
      // Successfully submitted
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Task submitted successfully')),
      );
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const TasksPage()),
        (route) => false, // Remove all previous routes
      );
    } else {
      // Error occurred
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to submit task')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: eManagementTopAppBarPage(),
      bottomNavigationBar: eManagementBottomNavigationBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: _priorities.isEmpty || _users.isEmpty
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // Title input
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            _taskViewModel.name = value;
                          });
                        },
                        decoration: InputDecoration(
                          labelText: 'Title',
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    // Description input
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        maxLines: 5,
                        onChanged: (value) {
                          setState(() {
                            _taskViewModel.description = value;
                          });
                        },
                        decoration: InputDecoration(
                          labelText: 'Description',
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    // Due Date input
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: TextEditingController(
                          text: _taskViewModel.dueDate != null
                              ? _taskViewModel.dueDate!.toLocal().toString().split(' ')[0] // Date format: YYYY-MM-DD
                              : '',
                        ),
                        decoration: InputDecoration(
                          labelText: 'Due Date',
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        readOnly: true,
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: _taskViewModel.dueDate ?? DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2101),
                          );
                          if (pickedDate != null) {
                            setState(() {
                              _taskViewModel.dueDate = pickedDate;
                            });
                          }
                        },
                      ),
                    ),                  
                    // Task Priority dropdown
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DropdownButtonFormField<int>(
                        value: _taskViewModel.taskPriorityId, // Adjust index for selection
                        decoration: InputDecoration(
                          labelText: 'Task Priority',
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        items: _priorities
                            .map((priority) => DropdownMenuItem(
                                  value: priority.id,
                                  child: Text(priority.name),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            _taskViewModel.taskPriorityId = value!;
                          });
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DropdownButtonFormField<int>(
                        value: _taskViewModel.cityId,
                        decoration: InputDecoration(
                          labelText: 'Location',
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        items: _cities
                            .map((city) => DropdownMenuItem(
                                  value: city.id,
                                  child: Text(city.name),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            _taskViewModel.cityId = value!;
                          });
                        },
                      ),
                    ),
                    // Users multi-select dropdown
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () async {
                          final List<SelectListHelper>? selectedUsers = await showDialog<List<SelectListHelper>>(
                            context: context,
                            builder: (BuildContext context) {
                              return MultiSelectDialog(
                                users: _users,
                                selectedUsers: _taskViewModel.userIds.map((id) => _users.firstWhere((user) => user.id == id)).toList(),
                              );
                            },
                          );

                          if (selectedUsers != null) {
                            setState(() {
                              _taskViewModel.userIds = selectedUsers.map((user) => user.id).toList();
                            });
                          }
                        },
                        child: InputDecorator(
                          decoration: InputDecoration(
                            labelText: 'Assign Users',
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(_taskViewModel.userIds.isNotEmpty
                              ? _users.where((user) => _taskViewModel.userIds.contains(user.id)).map((user) => user.name).join(', ')
                              : 'Select users'),
                        ),
                      ),
                    ),
                    // Task Status dropdown
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DropdownButtonFormField<int>(
                        value: _taskViewModel.taskStatusId,
                        decoration: InputDecoration(
                          labelText: 'Task Status',
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        items: [
                          DropdownMenuItem(value: 1, child: Text('Pending')),
                          DropdownMenuItem(value: 2, child: Text('In Progress')),
                          DropdownMenuItem(value: 3, child: Text('Completed')),
                          DropdownMenuItem(value: 4, child: Text('Cancelled')),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _taskViewModel.taskStatusId = value!;
                          });
                        },
                      ),
                    ),
                    // Submit button
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: _submitForm,
                        child: Text('Submit'),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

class ApiService {
  Future<List<SelectListHelper>> fetchUsers() async {
    final response = await http.get(Uri.parse('https://localhost:5001/api/Users'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => SelectListHelper.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }

  Future<List<SelectListHelper>> fetchTaskPriosities() async {
    final response = await http.get(Uri.parse('https://localhost:5001/api/TaskPriorities'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => SelectListHelper.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load task priorities');
    }
  }

  Future<List<SelectListHelper>> fetchCities() async {
    final response = await http.get(Uri.parse('https://localhost:5001/api/Cities'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => SelectListHelper.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load cities');
    }
  }
}
