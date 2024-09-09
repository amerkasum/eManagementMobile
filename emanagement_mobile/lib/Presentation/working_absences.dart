import 'dart:io';

import 'package:emanagement_mobile/Components/bottom_navigation_bar.dart';
import 'package:emanagement_mobile/Models/user_session.dart';
import 'package:emanagement_mobile/Models/working_absence_basic_dto.dart';
import 'package:emanagement_mobile/Presentation/working_absence_form.dart';
import 'package:emanagement_mobile/Services/working_absence_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../Components/top_app_bar.dart';

class WorkingAbsencePage extends StatefulWidget {
  const WorkingAbsencePage({super.key});

  @override
  State<WorkingAbsencePage> createState() => _WorkingAbsenceWidgetState();
}

class _WorkingAbsenceWidgetState extends State<WorkingAbsencePage> {
  late List<WorkingAbsenceBasicDto> data = [];
  late List<WorkingAbsenceBasicDto> filteredData = [];
  WorkingAbsenceService workingAbsenceService = WorkingAbsenceService();

  String selectedStatus = 'ALL';
  String searchQuery = '';

  Future<void> _changeStatus(int workingAbsenceId, String statusName) async {
    try {
      await workingAbsenceService.changeStatus(workingAbsenceId, statusName);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Task status updated successfully')),
      );
      // Refresh the page by re-fetching the data
      await getWorkingAbsences();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update task status: $e')),
      );
    }
  }

  Future<void> getWorkingAbsences() async {
    try {
      List<WorkingAbsenceBasicDto> workingAbsences = await workingAbsenceService.getWorkingAbsences();
      setState(() {
        data = workingAbsences;
        filteredData = workingAbsences;
      });
    } catch (e) {
      rethrow;
    }
  }

  @override
  void initState() {
    super.initState();
    getWorkingAbsences();
  }

  void filterData() {
    setState(() {
      filteredData = data.where((absence) {
        final matchesStatus = selectedStatus == 'ALL' || absence.absenceStatus == selectedStatus;
        final matchesSearch = absence.fullName.toLowerCase().contains(searchQuery.toLowerCase());
        return matchesStatus && matchesSearch;
      }).toList();
    });
  }

  Color _getStatusColor(String status) {
    switch (status.toUpperCase()) {
      case 'REQUEST':
        return Colors.blue;
      case 'REJECTED':
        return Colors.red;
      case 'APPROVED':
        return Colors.green;
      case 'CANCELLED':
        return Colors.grey;
      default:
        return Colors.black; // Fallback color
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = !kIsWeb && (Platform.isWindows || Platform.isMacOS || Platform.isLinux);
    return Scaffold(
      appBar: eManagementTopAppBarPage(title: "Working Absences"),
      bottomNavigationBar: eManagementBottomNavigationBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'Search by Name',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value;
                        filterData();
                      });
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Filter by Status',
                      border: OutlineInputBorder(),
                    ),
                    value: selectedStatus,
                    items: [
                      DropdownMenuItem(value: 'ALL', child: Text('ALL')),
                      DropdownMenuItem(value: 'REQUEST', child: Text('REQUEST')),
                      DropdownMenuItem(value: 'APPROVED', child: Text('APPROVED')),
                      DropdownMenuItem(value: 'REJECTED', child: Text('REJECTED')),
                      DropdownMenuItem(value: 'CANCELLED', child: Text('CANCELLED')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        selectedStatus = value ?? 'ALL';
                        filterData();
                      });
                    },
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => WorkingAbsenceFormPage()),
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
                      child: const Text('Absence Request'),
                    ),
                  ),
                  
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: filteredData.length,
                itemBuilder: (context, index) {
                  final absence = filteredData[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Card(
                      elevation: 3,
                      child: ExpansionTile(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  backgroundImage: AssetImage(absence.imageUrl),
                                  radius: 20,
                                ),
                                const SizedBox(width: 10), 
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      absence.absenceType.toUpperCase(),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                    Text(
                                      absence.fullName,
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  absence.absenceStatus.toUpperCase(),
                                  style: TextStyle(
                                    color: _getStatusColor(absence.absenceStatus),
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  absence.date,
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(left: 5.0, top: 5.0, bottom: 5.0, right: 5.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  absence.note,
                                  style: const TextStyle(fontSize: 16, color: Colors.black),
                                ),
                                const SizedBox(height: 10),
                                if (UserSession().role == 'ADMINISTRATOR')
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      ElevatedButton(
                                        onPressed: () {
                                          _changeStatus(absence.id, 'REJECTED');
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red,
                                          foregroundColor: Colors.white,
                                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                        ),
                                        child: const Text('REJECT'),
                                      ),
                                      const SizedBox(width: 10),
                                      ElevatedButton(
                                        onPressed: () {
                                          _changeStatus(absence.id, 'APPROVED');
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.green,
                                          foregroundColor: Colors.white,
                                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                        ),
                                        child: const Text('APPROVE'),
                                      ),
                                      const SizedBox(width: 10),
                                      ElevatedButton(
                                        onPressed: () {
                                          _changeStatus(absence.id, 'CANCELLED');
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.grey,
                                          foregroundColor: Colors.white,
                                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                        ),
                                        child: const Text('CANCEL'),
                                      ),
                                    ],
                                  ),
                              ],
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
      ),
    );
  }
}
