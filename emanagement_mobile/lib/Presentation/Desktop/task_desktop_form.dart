import 'package:emanagement_mobile/Components/bottom_navigation_bar.dart';
import 'package:emanagement_mobile/Models/Helpers/select_list_helper.dart';
import 'package:emanagement_mobile/Presentation/tasks.dart';
import 'package:emanagement_mobile/Services/Helpers/helpers.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:emanagement_mobile/Models/Desktop/task_view_model.dart';

import '../../Components/top_app_bar.dart';

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

class TaskDesktopForm extends StatefulWidget {
  @override
  _TaskFormState createState() => _TaskFormState();
}

class _TaskFormState extends State<TaskDesktopForm> {
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
            : Column(
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
                          borderRadius: BorderRadius.circular(0), // 0 border radius
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
                          borderRadius: BorderRadius.circular(0), // 0 border radius
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
                          borderRadius: BorderRadius.circular(0), // 0 border radius
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
                          borderRadius: BorderRadius.circular(0), // 0 border radius
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
                          borderRadius: BorderRadius.circular(0), // 0 border radius
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
                            borderRadius: BorderRadius.circular(0), // 0 border radius
                          ),
                        ),
                        child: Text(_taskViewModel.userIds.isNotEmpty
                            ? _taskViewModel.userIds.map((id) => _users.firstWhere((user) => user.id == id).name).join(', ')
                            : 'Select Users'),
                      ),
                    ),
                  ),
                  // Submit button
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15), // Adjust padding if needed
                          backgroundColor: Colors.black, // Black background
                          foregroundColor: Colors.white, // White text
                        ),
                        onPressed: _submitForm,
                        child: Text('Submit'),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

