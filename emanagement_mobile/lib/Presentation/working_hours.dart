import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../Components/top_app_bar.dart';

class WorkingHoursPage extends StatefulWidget {
  const WorkingHoursPage({super.key});

  @override
  State<WorkingHoursPage> createState() => _WorkingHoursWidgetState();
}

class _WorkingHoursWidgetState extends State<WorkingHoursPage> {
late List<String> data = ["Monday", "Tuesday", "Wednesday" , "Thursday" , "Friday", "Saturday", "Sunday"];
Map<String, bool> switchValues = {};
Map<String, String> dates = {};

@override
  void initState() {
    super.initState();
    DateTime today = DateTime.now();

    for (int i = 0 ; i < data.length; i++) {
      switchValues[data[i]] = true;
      DateTime date = today.add(Duration(days: i));
      String formatedDate = DateFormat("dd.MM.yyyy").format(date).toString();
      dates[data[i]] = formatedDate;
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: eManagementTopAppBarPage(title: "Working Hours"),
      body: Column(
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  String day = data[index];
                  return SwitchListTile(
                    activeColor: Colors.black,
                    value: switchValues[day]!,
                    onChanged: (bool value) {
                      setState(() {
                        switchValues[day] = value;
                      });
                    },
                    title: Text(day,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    subtitle: Text(
                      dates[day]!,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: Colors.grey),
                    ),
                  );
                },
              ),
            ),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                shape: const BeveledRectangleBorder(borderRadius: BorderRadius.zero),
                backgroundColor: Colors.black,
                side: const BorderSide(
                  color: Colors.white,
                ),
              ),
              onPressed: () {
              },
              child: const Text("Save", style: TextStyle(color: Colors.white, fontSize: 18)),
            ),
          ],
        ),
    );
  }
}