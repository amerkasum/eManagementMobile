import 'package:emanagement_mobile/Models/task_details.dart';
import 'package:emanagement_mobile/Services/task_service.dart';
import 'package:flutter/material.dart';

import '../Components/top_app_bar.dart';

class TaskDetails extends StatefulWidget {
  final int taskId;

  const TaskDetails({super.key, required this.taskId});

  @override
  State<TaskDetails> createState() => _TaskDetailsState();
}

class _TaskDetailsState extends State<TaskDetails> {
  late Future<TaskDetailsDto> data;
  int? _selectedReview;
  TaskService taskService = TaskService();

  Future<TaskDetailsDto> _loadTaskDetails() async {
    try {
      TaskDetailsDto taskDetails = await taskService.fetchTaskDetails(widget.taskId);
      return taskDetails;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load task details: $e')),
      );
      rethrow;
    } 
  }

  Future<void> _changeStatus(int taskId, String statusName) async {
    try {
      await taskService.changeStatus(taskId, statusName);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Task status updated successfully')),
      );
      if (statusName == 'FINISHED') {
        setState(() {}); // Refresh the page if needed
      } else {
        Navigator.pop(context); // Optionally go back after finishing the task
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update task status: $e')),
      );
    }
  }

  Future<void> _submitReview(int taskId, int review) async {
    try {
      await taskService.submitReview(taskId, review);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Review submitted successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to submit review: $e')),
      );
    }
  }

  Color _priorityColor(String priority) {
    switch (priority.toUpperCase()) {
      case 'LOW':
        return Colors.grey;
      case 'MEDIUM':
        return Colors.blue;
      case 'HIGH':
        return Colors.red;
      default:
        return Colors.black;
    }
  }

  Color _statusColor(String status) {
    switch (status.toUpperCase()) {
      case 'PENDING':
        return Colors.grey;
      case 'IN PROGRESS':
        return Colors.blue;
      case 'FINISHED':
        return Colors.green;
      case 'CANCELLED':
        return Colors.red;
      default:
        return Colors.black;
    }
  }

  @override
  void initState() {
    super.initState();
    data = _loadTaskDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: eManagementTopAppBarPage(),
      body: FutureBuilder<TaskDetailsDto>(
        future: data,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No data found'));
          }

          final taskDetails = snapshot.data!;

          return SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Task Details section...
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(10, 0, 10, 10),
                  child: Container(
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.white70,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(5, 5, 5, 5),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                taskDetails.name,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                              Text(taskDetails.location),
                              Text(
                                taskDetails.dueDateFormatted,
                                style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                taskDetails.status,
                                style: TextStyle(
                                  color: _statusColor(taskDetails.status),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                taskDetails.priority,
                                style: TextStyle(
                                  color: _priorityColor(taskDetails.priority),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                taskDetails.calculatedDays,
                                style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // Description section...
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(10, 0, 10, 10),
                  child: Container(
                    width: double.infinity,
                    height: 300,
                    decoration: const BoxDecoration(
                      color: Colors.white70,
                    ),
                    child: Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(5, 5, 5, 5),
                      child: Text(taskDetails.description),
                    ),
                  ),
                ),
                // User list...
                ...taskDetails.users.map((user) => Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(10, 0, 10, 10),
                  child: ListTile(
                    title: Text(
                      user.fullName,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      user.positionName,
                      style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
                    ),
                    tileColor: Colors.white70,
                    dense: false,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                )),
                if (taskDetails.status.toUpperCase() == 'FINISHED' && taskDetails.allowedReview)
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(10, 0, 10, 10),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white70, // Set your desired background color here
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          const Text(
                            "Review this task",
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(5, (index) {
                              int rating = index + 1;
                              return IconButton(
                                icon: Icon(
                                  _selectedReview != null && _selectedReview! >= rating
                                      ? Icons.star
                                      : Icons.star_border,
                                  color: Colors.amber,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _selectedReview = rating;
                                  });
                                  _submitReview(widget.taskId, rating);
                                },
                              );
                            }),
                          ),
                        ],
                      ),
                    ),
                  ),
                
                // Status change buttons...
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(10, 0, 10, 0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(10, 0, 10, 0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            // Status Buttons...
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 10,20),
                              child: ElevatedButton(
                                onPressed: () async {
                                  await _changeStatus(widget.taskId, 'CANCELLED');
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(horizontal: 24),
                                  elevation: 3,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Text(
                                  'Cancel',
                                  style: TextStyle(
                                    fontFamily: 'Readex Pro',
                                    letterSpacing: 0,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 10, 20),
                              child: ElevatedButton(
                                onPressed: () async {
                                  await _changeStatus(widget.taskId, 'IN PROGRESS');
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(horizontal: 24),
                                  elevation: 3,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Text(
                                  'Start',
                                  style: TextStyle(
                                    fontFamily: 'Readex Pro',
                                    letterSpacing: 0,
                                  ),
                                ),
                              ),
                            ),
                            Padding(padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 10, 20),
                            child: ElevatedButton(
                                onPressed: () async {
                                  await _changeStatus(widget.taskId, 'FINISHED');
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(horizontal: 24),
                                  elevation: 3,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Text(
                                  'Finish',
                                  style: TextStyle(
                                    fontFamily: 'Readex Pro',
                                    letterSpacing: 0,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
