import 'package:emanagement_mobile/Models/user_session.dart';
import 'package:emanagement_mobile/Presentation/working_absences.dart';
import 'package:emanagement_mobile/Services/Helpers/helpers.dart';
import 'package:emanagement_mobile/Services/working_absence_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:emanagement_mobile/Components/bottom_navigation_bar.dart';
import 'package:emanagement_mobile/Components/top_app_bar.dart';
import 'package:emanagement_mobile/Models/Helpers/select_list_helper.dart';
import 'package:emanagement_mobile/Models/working_absence_view_model.dart';

class WorkingAbsenceFormPage extends StatefulWidget {
  @override
  _WorkingAbsenceFormPageState createState() => _WorkingAbsenceFormPageState();
}

class _WorkingAbsenceFormPageState extends State<WorkingAbsenceFormPage> {
  final _formKey = GlobalKey<FormState>();
  ApiService apiService = ApiService();
  WorkingAbsenceService workingAbsenceService = WorkingAbsenceService();

  WorkingAbsenceViewModel _workingAbsence = WorkingAbsenceViewModel(
    absenceTypeId: 1,
    startDate: DateTime.now(),
    endDate: null,
    note: '',
    userId: 0,
  );

  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();

  List<SelectListHelper> _absenceTypes = [];
  bool _isDailyAbsence = false; // Checkbox state

  Future<void> _fetchData() async {
    try {
      List<SelectListHelper> fetchedAbsenceTypes = await apiService.fetchAbsenceTypes();
      setState(() {
        _absenceTypes = fetchedAbsenceTypes;
      });
    } catch (e) {
      print('Failed to fetch data: $e');
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();

      _workingAbsence.userId = UserSession().userId ?? 0;

      await workingAbsenceService.createWorkingAbsence(_workingAbsence);
      
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const WorkingAbsencePage()),
        (route) => false, 
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: eManagementTopAppBarPage(title: "Working Absence Form"),
      bottomNavigationBar: eManagementBottomNavigationBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownButtonFormField<int>(
                decoration: const InputDecoration(
                  labelText: 'Absence Type',
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 1.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 1.0),
                  ),
                ),
                value: _workingAbsence.absenceTypeId, 
                items: _absenceTypes.map((SelectListHelper item) {
                  return DropdownMenuItem<int>(
                    value: item.id,
                    child: Text(item.name),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _workingAbsence.absenceTypeId = value ?? 0;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select an absence type';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              TextFormField(
                controller: _startDateController,
                decoration: InputDecoration(
                  labelText: 'Start Date',
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 1.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 1.0),
                  ),
                ),
                readOnly: true,
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      _workingAbsence.startDate = pickedDate;
                      _startDateController.text =
                          DateFormat('yyyy-MM-dd').format(pickedDate);
                    });
                  }
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a start date';
                  }
                  return null;
                },
              ),

              SizedBox(height: 16),

              // Conditionally Show End Date Picker
              if (!_isDailyAbsence) ...[
                TextFormField(
                  controller: _endDateController,
                  decoration: InputDecoration(
                    labelText: 'End Date (optional)',
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 1.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 1.0),
                    ),
                  ),
                  readOnly: true,
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );
                    if (pickedDate != null) {
                      setState(() {
                        _workingAbsence.endDate = pickedDate;
                        _endDateController.text =
                            DateFormat('yyyy-MM-dd').format(pickedDate);
                      });
                    }
                  },
                ),
                SizedBox(height: 16),
              ],

              // Note
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Note (optional)',
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 1.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 1.0),
                  ),
                ),
                onChanged: (value) {
                  _workingAbsence.note = value;
                },
                maxLines: 7, 
                minLines: 5, 
              ),

              SizedBox(height: 16),

              Row(
                 mainAxisAlignment: MainAxisAlignment.start,
                 children: [
                   ElevatedButton(
                     style: ElevatedButton.styleFrom(
                       backgroundColor: Colors.black,
                       foregroundColor: Colors.white,
                       padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                       textStyle: const TextStyle(fontSize: 18),
                       shape: RoundedRectangleBorder(
                         borderRadius: BorderRadius.circular(8.0),
                       ),
                     ),
                     onPressed: () {
                       if (_formKey.currentState!.validate()) {
                         print(_workingAbsence.toJson());
                         _submitForm();
                       }
                     },
                     child: const Text('Submit'),
                   ),
                   const SizedBox(width: 16),
                  
                  Checkbox(
                     value: _isDailyAbsence,
                     onChanged: (bool? value) {
                       setState(() {
                         _isDailyAbsence = value ?? false;
                         if (_isDailyAbsence) {
                           _workingAbsence.endDate = null;
                           _endDateController.clear();
                         }
                       });
                     },
                   ),
                   const Text(
                     'Daily Absence',
                     style: TextStyle(fontWeight: FontWeight.bold),
                   ),
                   const SizedBox(width: 8),
               
                   // Tooltip for additional information
                   const Tooltip(
                     message:
                         'A daily absence refers to an absence lasting only one day. In this case, the end date is not required, as the absence begins and ends on the same day.',
                     child: Icon(
                       Icons.help_outline,
                       color: Colors.black,
                     ),
                   ),
                 ],
               ),

            ],
          ),
        ),
      ),
    );
  }
}
