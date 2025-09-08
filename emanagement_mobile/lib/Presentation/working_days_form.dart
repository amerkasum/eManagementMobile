import 'package:emanagement_mobile/Models/Helpers/working_days_basic_dto.dart';
import 'package:emanagement_mobile/Models/Helpers/working_days_dto.dart';
import 'package:emanagement_mobile/Services/working_days.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../Components/top_app_bar.dart';
import '../Services/user_service.dart';

class WorkingDaysPage extends StatefulWidget {
  final int userId;

  const WorkingDaysPage({super.key, required this.userId});

  @override
  State<WorkingDaysPage> createState() => _WorkingDaysWidgetState();
}

class _WorkingDaysWidgetState extends State<WorkingDaysPage> {
  final WorkingDaysService _workingDaysService = WorkingDaysService();

  late Future<WorkingDaysDto> _workingDaysFuture;
  Map<int, bool> switchValues = {};

  @override
  void initState() {
    super.initState();
    _workingDaysFuture = _workingDaysService.getWorkingDaysByUserId(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: eManagementTopAppBarPage(title: "Working Days"),
      body: FutureBuilder<WorkingDaysDto>(
        future: _workingDaysFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return const Center(child: Text('No working days data found.'));
          }

          final data = snapshot.data!;

          return Column(
            children: [
              const SizedBox(height: 20),

              // Profile Image and Name
              Row(
                children: [
                  const SizedBox(width: 16),
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.grey[200],
                    backgroundImage: data.imageUrl != null && data.imageUrl!.isNotEmpty
                        ? AssetImage(data.imageUrl!)
                        : AssetImage('assets/user.jpg') as ImageProvider,
                  ),

                  const SizedBox(width: 16),
                  Text(
                    data.fullName,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),

              const SizedBox(height: 20),

              // Working Days List
              Expanded(
                child: ListView.builder(
                  itemCount: data.workingDays.length,
                  itemBuilder: (context, index) {
                    final day = data.workingDays[index];

                    // Initialize switch state if not already
                    switchValues.putIfAbsent(day.workingDayId, () => day.isWorking);

                    return SwitchListTile(
                      activeColor: Colors.black,
                      value: switchValues[day.workingDayId]!,
                      onChanged: (bool value) {
                        setState(() {
                          switchValues[day.workingDayId] = value;
                        });
                      },
                      title: Text(
                        day.dayName,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      subtitle: Text(
                        day.shiftName,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 12, color: Colors.grey),
                      ),
                    );
                  },
                ),
              ),

              // Save Button
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  shape: const BeveledRectangleBorder(borderRadius: BorderRadius.zero),
                  backgroundColor: Colors.black,
                  side: const BorderSide(color: Colors.white),
                ),
                onPressed: () async {
                  for (var day in data.workingDays) {
                    day.isWorking = switchValues[day.workingDayId] ?? day.isWorking;
                  }
                
                  await _workingDaysService.editWorkingDays(data.workingDays);
                
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Working days updated successfully'),
                      backgroundColor: Colors.green,
                    ),
                  );
                
                  await Future.delayed(const Duration(milliseconds: 500));
                  Navigator.of(context).pop();
                },


                child: const Text("Save", style: TextStyle(color: Colors.white, fontSize: 18)),
              ),
            ],
          );
        },
      ),
    );
  }
}
