import 'dart:io'; // For platform detection on non-web platforms
import 'package:emanagement_mobile/Presentation/Desktop/users_desktop.dart';
import 'package:flutter/foundation.dart' show kIsWeb; // For web platform detection
import 'package:emanagement_mobile/Models/user_session.dart';
import 'package:emanagement_mobile/Presentation/event_details.dart';
import 'package:emanagement_mobile/Presentation/events.dart';
import 'package:emanagement_mobile/Presentation/profile.dart';
import 'package:emanagement_mobile/Presentation/tasks.dart';
import 'package:emanagement_mobile/Presentation/users.dart';
import 'package:flutter/material.dart';

class eManagementBottomNavigationBar extends StatefulWidget {
  @override
  eManagementBottomNavigationBarState createState() =>
      eManagementBottomNavigationBarState();
}

class eManagementBottomNavigationBarState
    extends State<eManagementBottomNavigationBar> {
  int _selectedIndex = 0;
  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();

    // Check if it's a web platform
    if (kIsWeb) {
      // Web platform logic can be added here if needed
      _screens = [
        const EventsPage(),
        ProfilePage(userId: UserSession().userId!),
        const UsersPage(),
        const TasksPage(),
        const EventDetailsPageWidget(eventId: 1),
      ];
    } else {
      // Non-web platforms (Desktop)
      if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
        _screens = [
          const EventsPage(),
          ProfilePage(userId: UserSession().userId!),
          const UsersDesktopWidget(),
          const TasksPage(),
          const EventDetailsPageWidget(eventId: 1),
        ];
      } else {
        // Mobile or other non-desktop platforms
        _screens = [
          const EventsPage(),
          ProfilePage(userId: UserSession().userId!),
          const UsersPage(),
          const TasksPage(),
          const EventDetailsPageWidget(eventId: 1),
        ];
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          backgroundColor: Colors.black,
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          backgroundColor: Colors.black,
          label: 'Profile',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.list),
          backgroundColor: Colors.black,
          label: 'Employees',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.task),
          backgroundColor: Colors.black,
          label: 'Tasks',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.event),
          backgroundColor: Colors.black,
          label: 'Events',
        ),
      ],
      currentIndex: _selectedIndex,
      onTap: (int index) {
        setState(() {
          _selectedIndex = index;
        });

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => _screens[index]),
        );
      },
    );
  }
}
