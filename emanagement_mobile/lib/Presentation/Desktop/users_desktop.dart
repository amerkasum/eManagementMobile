import 'dart:convert';
import 'package:emanagement_mobile/Components/bottom_navigation_bar.dart';
import 'package:emanagement_mobile/Models/Desktop/users_desktop_dto.dart';
import 'package:emanagement_mobile/Presentation/Desktop/user_form.dart';
import 'package:emanagement_mobile/Presentation/profile.dart';
import 'package:emanagement_mobile/Services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../Components/top_app_bar.dart';

class UsersDesktopWidget extends StatefulWidget {
  const UsersDesktopWidget({super.key});

  @override
  State<UsersDesktopWidget> createState() => _UsersDesktopWidgetState();
}

class _UsersDesktopWidgetState extends State<UsersDesktopWidget> {
  UserService userService = UserService();
  late Future<List<UserDesktopDto>> usersFuture;
  List<UserDesktopDto> allUsers = [];
  List<UserDesktopDto> filteredUsers = [];
  TextEditingController searchController = TextEditingController();
  String? selectedContractType = 'Contract Type'; 
  String? selectedPosition = 'Position'; 
  String? selectedLeaveType = 'Availability';

  @override
  void initState() {
    super.initState();
    usersFuture = fetchUsers();
  }

  Future<void> deleteUser(int userId) async {
    final success = await userService.deleteUser(userId);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User deleted successfully')),
      );
      setState(() {
        usersFuture = fetchUsers(); // Re-fetch users
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to delete user')),
      );
    }
  }

  Future<List<UserDesktopDto>> fetchUsers() async {
    final response = await http.get(Uri.parse('https://localhost:5001/api/Users/GetUsersDesktop'));

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      allUsers = jsonResponse.map((data) => UserDesktopDto.fromJson(data)).toList();
      setState(() {
        filteredUsers = allUsers; // Initialize filtered users after data fetch
      });
      return allUsers;
    } else {
      throw Exception('Failed to load users');
    }
  }

  void filterUsers(String query) {
    setState(() {
      filteredUsers = allUsers
          .where((user) =>
              user.fullName.toLowerCase().contains(query.toLowerCase()) &&
              (selectedContractType == null || selectedContractType == 'Contract Type' || user.contractType == selectedContractType) &&
              (selectedPosition == null || selectedPosition == 'Position' || user.position == selectedPosition) &&
              (selectedLeaveType == null || selectedLeaveType == 'Availability' || user.availability == selectedLeaveType))
          .toList();
    });
  }

  void filterByContractType(String? contractType) {
    setState(() {
      selectedContractType = contractType;
      filterUsers(searchController.text);
    });
  }

  void filterByPosition(String? position) {
    setState(() {
      selectedPosition = position;
      filterUsers(searchController.text);
    });
  }

  void filterByLeaveType(String? leaveType) {
    setState(() {
      selectedLeaveType = leaveType;
      filterUsers(searchController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: eManagementTopAppBarPage(title: "Employees"),
        bottomNavigationBar: eManagementBottomNavigationBar(),
        body: SafeArea(
          top: true,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Users',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => UserForm()),
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
                      child: const Text('Add new user'),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    // Search Input
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: TextField(
                          controller: searchController,
                          decoration: InputDecoration(
                            labelText: 'Search',
                            labelStyle: const TextStyle(color: Colors.black),
                            filled: true,
                            fillColor: Colors.white,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: Colors.white, width: 1),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: Colors.black, width: 1),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: Colors.white, width: 1),
                            ),
                            floatingLabelBehavior: FloatingLabelBehavior.auto,
                          ),
                          onChanged: filterUsers,
                        ),
                      ),
                    ),
                    // Select List 1 (Contract Type Filter)
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          value: selectedContractType,
                          hint: const Text('Contract Type'),
                          items: <String>[
                            "Contract Type",
                            'Full Time',
                            'Part Time',
                            'Temporary',
                            'Contractor',
                            'Internship',
                            'Consultant',
                            'Fixed Term',
                            'Zero Hour',
                            'Seasonal',
                            'Probationary',
                            'Remote',
                            'On Call',
                          ].map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (value) {
                            filterByContractType(value);
                          },
                        ),
                      ),
                    ),
                    // Select List 2 (Position Filter)
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          value: selectedPosition,
                          hint: const Text('Position'),
                          items: <String>[
                            'Position',
                            'Software Developer',
                            'Data Scientist',
                            'Product Manager',
                            'Graphic Designer',
                            'System Administrator',
                            'Marketing Specialist',
                            'UX Researcher',
                            'Sales Manager',
                            'Business Analyst',
                            'Network Engineer',
                            'Database Administrator',
                            'Frontend Developer',
                            'Backend Developer',
                            'Devops Engineer',
                            'Quality Assurance Tester',
                            'Technical Support Specialist',
                            'Human Resources Manager',
                            'Content Creator',
                            'IT Consultant',
                            'Web Designer',
                          ].map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (value) {
                            filterByPosition(value);
                          },
                        ),
                      ),
                    ),
                    // Select List 3 (Leave Type Filter)
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          value: selectedLeaveType,
                          hint: const Text('Leave Type'),
                          items: <String>[
                            'Availability',
                            'Available',
                            'Sick Leave',
                            'Vacation Leave',
                            'Personal Leave',
                            'Parental Leave',
                            'Bereavement Leave',
                            'Jury Duty',
                            'Military Leave',
                            'Unpaid Leave',
                            'Public Holiday',
                            'Study Leave',
                            'Sabbatical',
                            'Compensatory Leave',
                            'Volunteer Leave',
                            'Family And Medical Leave',
                            'Half Day Leave',
                            'Emergency Leave',
                            'Casual Leave',
                            'Administrative Leave',
                            'Floating Holiday',
                            'Religious Leave',
                          ].map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (value) {
                            filterByLeaveType(value);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: FutureBuilder<List<UserDesktopDto>>(
                    future: usersFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(child: Text('No users found.'));
                      }

                      // DataTable with the filtered users
                      return SingleChildScrollView(
                        scrollDirection:
                        Axis.horizontal,
                        child: DataTable(
                          columns: const [
                            DataColumn(label: Text('Full Name')),
                            DataColumn(label: Text('Email')),
                            DataColumn(label: Text('Phone Number')),
                            DataColumn(label: Text('Contract Type')),
                            DataColumn(label: Text('Contract Expire Date')),
                            DataColumn(label: Text('Position')),
                            DataColumn(label: Text('Availability')),
                            DataColumn(label: Text('Actions')),
                          ],
                          rows: filteredUsers.map((user) {
                            return DataRow(
                              cells: [
                                DataCell(
                                  Row(
                                    children: [
                                      // Image with a fixed width and height
                                      Container(
                                        width: 30,
                                        height: 30,
                                        clipBehavior: Clip.antiAlias,
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                        ),
                                        child: Image(
                                          image: AssetImage(user.imageUrl),
                                          fit: BoxFit.cover,
                                          errorBuilder:  (context, error, stacTrace) {
                                            return Image.asset("assets/user.jpg");
                                          },
                                        ),
                                      ),
                                      // Text displaying the user's full name
                                      Text(user.fullName),
                                    ],
                                  ),
                                ),
                                DataCell(Text(user.email)),
                                DataCell(Text(user.phoneNumber)),
                                DataCell(Text(user.contractType)),
                                DataCell(Text(user.formattedContractExpireDate)),
                                DataCell(Text(user.position)),
                                DataCell(
                                  Text(
                                    user.availability,
                                    style: TextStyle(
                                      color: user.availability == 'Available' ? Colors.green : Colors.red, 
                                    ),
                                  ),
                                ),
                                DataCell(
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.info),
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => ProfilePage(userId: user.id), 
                                            ),
                                          );
                                        },
                                        color: Colors.green,
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          deleteUser(user.id); 
                                        },
                                        color: Colors.red,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
