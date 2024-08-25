import 'dart:io';

import 'package:emanagement_mobile/Components/bottom_navigation_bar.dart';
import 'package:emanagement_mobile/Models/tasks_dto.dart';
import 'package:emanagement_mobile/Presentation/Desktop/task_desktop_form.dart';
import 'package:emanagement_mobile/Presentation/task_details.dart';
import 'package:emanagement_mobile/Presentation/task_form.dart';
import 'package:emanagement_mobile/Services/task_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import '../Components/top_app_bar.dart'; 


class TasksPage extends StatefulWidget {
  const TasksPage({super.key});

  @override
  State<TasksPage> createState() => _TasksWidgetState();
}

class _TasksWidgetState extends State<TasksPage> {
  late List<TaskDto> data = [];
  late List<TaskDto> filteredData = [];
  String selectedPriority = 'Task priorities';
  String selectedStatus = 'Task statuses';
  final List<String> taskPriorities = ['Task priorities', 'LOW', 'MEDIUM', 'HIGH'];
  final List<String> taskStatuses = ["Task statuses", "CANCELLED", "FINISHED", "IN PROGRESS", "PENDING"];


  final taskService = TaskService();
  
  Future<void> fetchTasks() async {
    try {
      data = await taskService.getAll();
      setState(() {
        filteredData = data; 
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  void filterTasks(String priority, String status) {
    filteredData = data.where((task) {
      final priorityMatch = priority == 'Task priorities' || task.priority == _priorityStringToInt(priority);
      final statusMatch = status == 'Task statuses' || task.statusCode == _statusStringToInt(status);
      return priorityMatch && statusMatch;
    }).toList();
    setState(() {});
  }

  int _priorityStringToInt(String priority) {
    switch (priority) {
      case 'LOW':
        return 1;
      case 'MEDIUM':
        return 2;
      case 'HIGH':
        return 3;
      default:
        return 0;
    }
  }

  int _statusStringToInt(String status) {
    switch (status) {
      case 'PENDING':
        return 1;
      case 'IN PROGRESS':
        return 2;
      case 'FINISHED':
        return 3;
      case 'CANCELLED':
        return 4;
      default:
        return 0;
    }
  }

  Color _priorityColor(int priority) {
    switch (priority) {
      case 1:
        return Colors.grey;
      case 2:
        return Colors.blue;
      case 3:
        return Colors.red;
      default:
        return Colors.black;
    }
  }

  @override
  void initState() {
    fetchTasks();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = !kIsWeb && (Platform.isWindows || Platform.isMacOS || Platform.isLinux);
    return Scaffold(
      appBar: eManagementTopAppBarPage(),
      bottomNavigationBar: eManagementBottomNavigationBar(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: selectedPriority,
                    icon: const Icon(Icons.arrow_downward),
                    iconSize: 24,
                    elevation: 16,
                    style: const TextStyle(color: Colors.black),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedPriority = newValue!;
                        filterTasks(selectedPriority, selectedStatus);
                      });
                    },
                    items: taskPriorities
                        .map<DropdownMenuItem<String>>((String value) {
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
                        borderSide: const BorderSide(color: Colors.grey, width: 1.0),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    dropdownColor: Colors.white,
                    isExpanded: true,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: selectedStatus,
                    icon: const Icon(Icons.arrow_downward),
                    iconSize: 24,
                    elevation: 16,
                    style: const TextStyle(color: Colors.black),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedStatus = newValue!;
                        filterTasks(selectedPriority, selectedStatus);
                      });
                    },
                    items: taskStatuses
                        .map<DropdownMenuItem<String>>((String value) {
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
                        borderSide: const BorderSide(color: Colors.grey, width: 1.0),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    dropdownColor: Colors.white,
                    isExpanded: true,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredData.length,
              itemBuilder: (context, index) {
                final task = filteredData[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TaskDetails(taskId: task.id),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                    child: Container(
                      height: 70,
                      decoration: BoxDecoration(
                        color: Colors.white70,
                        borderRadius: BorderRadius.circular(8.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(5, 0, 0, 0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      task.name,
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                                    ),
                                    Padding(
                                      padding: const EdgeInsetsDirectional.fromSTEB(5, 0, 0, 0),
                                      child: Text(
                                        '(${_priorityIntToString(task.priority)})',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: _priorityColor(task.priority),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Container(
                                      width: 20,
                                      height: 20,
                                      clipBehavior: Clip.antiAlias,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Image(
                                        image: AssetImage("assets/user.jpg"),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsetsDirectional.fromSTEB(5, 0, 0, 0),
                                      child: Text(task.usersAssigned),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 5, 0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  _statusCodeToString(task.statusCode),
                                  style: TextStyle(
                                    color: _statusColor(task.statusCode),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                Text(task.location),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          LayoutBuilder(
            builder: (context, constraints) {
              return SizedBox(
                width: isDesktop ? 200 : constraints.maxWidth,
                child: GestureDetector(
                  onTap: () {
                    if (kIsWeb || (!Platform.isWindows && !Platform.isLinux && !Platform.isMacOS)) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => TaskForm()), 
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => TaskDesktopForm()), 
                      );
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.all(isDesktop ? 5 : 15),
                    margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: Text(
                        "Add",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ),
                ),
              );
            },
          )
        ],
      ),
    );
  }

  String _priorityIntToString(int priority) {
    switch (priority) {
      case 1:
        return 'LOW';
      case 2:
        return 'MEDIUM';
      case 3:
        return 'HIGH';
      default:
        return 'UNKNOWN';
    }
  }

  String _statusCodeToString(int statusCode) {
    switch (statusCode) {
      case 1:
        return 'PENDING';
      case 2:
        return 'IN PROGRESS';
      case 3:
        return 'FINISHED';
      case 4:
        return 'CANCELLED';
      default:
        return 'UNKNOWN';
    }
  }

  Color _statusColor(int statusCode) {
    switch (statusCode) {
      case 1:
        return Colors.grey;
      case 2:
        return Colors.blue;
      case 3:
        return Colors.green;
      case 4:
        return Colors.red;
      default:
        return Colors.black;
    }
  }
}

