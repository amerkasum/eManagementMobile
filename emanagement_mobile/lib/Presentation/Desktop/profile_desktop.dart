import 'dart:convert';
import 'dart:io' show Platform;

import 'package:emanagement_mobile/Components/bottom_navigation_bar.dart';
import 'package:emanagement_mobile/Components/top_app_bar.dart';
import 'package:emanagement_mobile/Models/user_profile_dto.dart';
import 'package:emanagement_mobile/Presentation/working_days_form.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProfileDesktopPage extends StatefulWidget {
  final int userId;

  const ProfileDesktopPage({super.key, required this.userId});

  @override
  State<ProfileDesktopPage> createState() => _ProfileDesktopPageWidgetState();
}

class _ProfileDesktopPageWidgetState extends State<ProfileDesktopPage> {
  late Future<UserProfileDto> data;
  bool showAbout = false;
  bool showWorkingDays = false;

  @override
  void initState() {
    super.initState();
    data = getUserProfileDto(widget.userId);
  }

  Future<UserProfileDto> getUserProfileDto(int userId) async {
    final isDesktop = !Platform.isAndroid && (Platform.isWindows || Platform.isMacOS || Platform.isLinux);
    final response = await http.get(Uri.parse(isDesktop ? 'https://localhost:5001/api/Users/GetUserProfile?userId=$userId' : 
    'http://10.0.2.2:5001/api/Users/GetUserProfile?userId=$userId'));

    if (response.statusCode == 200) {
      return UserProfileDto.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      throw Exception('Failed to load user profile');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = !Platform.isAndroid && (Platform.isWindows || Platform.isMacOS || Platform.isLinux);
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
                final width = isDesktop ? 900.0 : constraints.maxWidth;

                return SingleChildScrollView(
                  child: Center(
                    child: SizedBox(
                      width: width,
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: [
                            // Profile Image and Name Row
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image(
                                    image: AssetImage(userProfile.imageUrl),
                                    width: 150,
                                    height: 150,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Image.asset("assets/user.jpg");
                                    },
                                  ),
                                ),
                                const SizedBox(width: 20),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      userProfile.fullName,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 26,
                                      ),
                                    ),
                                    Text(
                                      userProfile.jobPosition,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 18,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.circle,
                                          color: userProfile.availability == 'Available' ? Colors.green : Colors.red,
                                          size: 14,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          userProfile.availability,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 18,
                                            color: userProfile.availability == 'Available' ? Colors.green : Colors.red,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 30),

                            // Profile Information Section (Email, Phone, DOB, Residency)
                            Card(
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  children: [
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
                                    ),
                                    const Divider(),
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
                                    ),
                                    const Divider(),
                                    ListTile(
                                      leading: const Icon(Icons.calendar_month),
                                      title: Text(
                                        '${userProfile.formattedDateOfBirth} (${DateTime.now().year - userProfile.dateOfBirth.year} years old)',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ),
                                      subtitle: const Text('Date of birth'),
                                    ),
                                    const Divider(),
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
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 30),

                            // About and Working Days Buttons
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      showAbout = !showAbout;
                                      showWorkingDays = false;
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.black,
                                    foregroundColor: Colors.white, // Text color
                                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12), // Slightly wider, same height
                                  ),
                                  child: const Text('About'),
                                ),
                                const SizedBox(width: 10),
                                ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => WorkingDaysPage(userId: userProfile.id),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                ),
                                child: const Text('Working Days'),
                              ),

                              ],
                            ),

                            const SizedBox(height: 30),

                            // Conditional Rendering for About Section
                            if (showAbout)
                              Card(
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Text(
                                    userProfile.about,
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ),
                              ),
                          ],
                        ),
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
