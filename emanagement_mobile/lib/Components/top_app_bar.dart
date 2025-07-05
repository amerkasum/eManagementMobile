import 'dart:io';

import 'package:emanagement_mobile/Models/user_session.dart';
import 'package:emanagement_mobile/Presentation/Desktop/profile_desktop.dart';
import 'package:emanagement_mobile/Presentation/login.dart';
import 'package:emanagement_mobile/Presentation/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import this for MouseCursor
import 'package:flutter/foundation.dart' show kIsWeb; // To check if it's web

class eManagementTopAppBarPage extends StatelessWidget implements PreferredSizeWidget {
  @override
  final Size preferredSize;
  final String title;

  eManagementTopAppBarPage({Key? key, required this.title})
      : preferredSize = const Size.fromHeight(kToolbarHeight),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get the user session data
    final userSession = UserSession();
    final fullName = userSession.fullName ?? "User";
    final imageUrl = userSession.imageUrl ?? "assets/user.jpg";

    return AppBar(
      backgroundColor: Colors.black,
      foregroundColor: Colors.white,
      title: Text(title),
      actions: [
        MouseRegion(
          cursor: SystemMouseCursors.click, // Change cursor to pointer on hover
          child: GestureDetector(
            onTap: () {
              // Check if it's a desktop platform
              if (Platform.isAndroid || !Platform.isAndroid && (Platform.isWindows || Platform.isMacOS || Platform.isLinux)) {
                // Navigate to ProfileDesktopPage if it's a desktop
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ProfileDesktopPage(userId: userSession.userId!),
                  ),
                );
              } else {
                // Navigate to ProfilePage if it's not a desktop (mobile)
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ProfilePage(userId: userSession.userId!),
                  ),
                );
              }
            },
            child: Row(
              children: [
                // Display the user image if it exists
                CircleAvatar(
                  backgroundImage: AssetImage(imageUrl),
                  backgroundColor: Colors.grey,
                  radius: 18, // Adjust the size as needed
                ),
                const SizedBox(width: 10),
                // Display the fullName
                Text(
                  fullName,
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),
                const SizedBox(width: 20),
              ],
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () {
            // Clear the user session
            UserSession().clearSession();

            // Navigate back to the login page
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => LoginPage()),
            );
          },
        ),
      ],
    );
  }
}
