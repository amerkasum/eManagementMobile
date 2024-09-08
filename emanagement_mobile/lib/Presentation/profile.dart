import 'dart:convert';
import 'dart:io' show Platform;

import 'package:emanagement_mobile/Components/bottom_navigation_bar.dart';
import 'package:emanagement_mobile/Components/top_app_bar.dart';
import 'package:emanagement_mobile/Models/user_profile_dto.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProfilePage extends StatefulWidget {
  final int userId;

  const ProfilePage({super.key, required this.userId});

  @override
  State<ProfilePage> createState() => _ProfilePageWidgetState();
}

class _ProfilePageWidgetState extends State<ProfilePage> {
  late Future<UserProfileDto> data;

  @override
  void initState() {
    super.initState();
    data = getUserProfileDto(widget.userId);
  }

  Future<UserProfileDto> getUserProfileDto(int userId) async {
    final response = await http.get(
        Uri.parse('https://localhost:5001/api/Users/GetUserProfile?userId=$userId'));

    if (response.statusCode == 200) {
      return UserProfileDto.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      throw Exception('Failed to load user profile');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = !kIsWeb && (Platform.isWindows || Platform.isMacOS || Platform.isLinux);

    return Scaffold(
      appBar: eManagementTopAppBarPage(title: "Profile"),
      bottomNavigationBar: eManagementBottomNavigationBar(),
      body: FutureBuilder<UserProfileDto>(
        future: data,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final userProfile = snapshot.data!;
            return LayoutBuilder(
              builder: (context, constraints) {
                final width = isDesktop ? 500.0 : constraints.maxWidth;

                return SingleChildScrollView(
                  child: Center(
                    child: SizedBox(
                      width: width,
                      child: Column(
                        children: [
                          const SizedBox(height: 50),
                          Container(
                            width: 120,
                            height: 120,
                            clipBehavior: Clip.antiAlias,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: Image(
                              image: AssetImage(userProfile.imageUrl),
                              fit: BoxFit.cover,
                              errorBuilder:  (context, error, stacTrace) {
                                return Image.asset("assets/user.jpg");
                              },
                            ),
                          ),
                          const SizedBox(height: 50),
                          Text(
                            userProfile.fullName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                            ),
                          ),
                          Text(
                            userProfile.jobPosition,
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 20),
                          ListTile(
                            leading: const Icon(Icons.email),
                            title: Text(
                              userProfile.email,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            subtitle: const Text('Email'),
                            tileColor: Colors.white70,
                            dense: false,
                            shape: const Border(bottom: BorderSide(color: Colors.black12)),
                          ),
                          ListTile(
                            leading: const Icon(Icons.phone),
                            title: Text(
                              userProfile.phoneNumber,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            subtitle: const Text('Phone number'),
                            tileColor: Colors.white70,
                            dense: false,
                            shape: const Border(bottom: BorderSide(color: Colors.black12)),
                          ),
                          ListTile(
                            leading: const Icon(Icons.calendar_month),
                            title: Text(
                              '${userProfile.formattedDateOfBirth} (${DateTime.now().year - userProfile.dateOfBirth.year} years old)',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 19,
                              ),
                            ),
                            subtitle: const Text('Date of birth'),
                            tileColor: Colors.white70,
                            dense: false,
                            shape: const Border(bottom: BorderSide(color: Colors.black12)),
                          ),
                          ListTile(
                            leading: Icon(
                              Icons.circle,
                              color: userProfile.availability == 'Available' ? Colors.green : Colors.red, 
                            ),
                            title: Text(
                              userProfile.availability,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: userProfile.availability == 'Available' ? Colors.green : Colors.red, 
                              ),
                            ),
                            subtitle: const Text('Availability'),
                            tileColor: Colors.white70,
                            dense: false,
                            shape: const Border(bottom: BorderSide(color: Colors.black12)),
                          ),
                          ListTile(
                            leading: const Icon(Icons.location_city),
                            title: Text(
                              userProfile.residence,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            subtitle: const Text('Residency'),
                            tileColor: Colors.white70,
                            dense: false,
                          ),
                          const SizedBox(height: 20),
                          const Align(
                            alignment: AlignmentDirectional.centerStart,
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                              child: Text(
                                "About",
                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Padding(padding: const EdgeInsetsDirectional.fromSTEB(5, 5, 5, 5),
                            child: Container(
                              width: double.infinity,
                              height: 200,
                              decoration: BoxDecoration(
                                color: Colors.white70,
                                border: Border.all(
                                  color: Colors.black12,
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              child: Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(5, 5, 5, 5),
                                child: Text(userProfile.about),
                              ),
                            ),
                          )
                          
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(child: Text('No data available'));
          }
        },
      ),
    );
  }
}
