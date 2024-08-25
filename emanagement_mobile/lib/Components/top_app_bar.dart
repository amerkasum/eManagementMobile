import 'package:emanagement_mobile/Presentation/login.dart';
import 'package:flutter/material.dart';

class eManagementTopAppBarPage extends StatelessWidget implements PreferredSizeWidget {
  @override
  final Size preferredSize;

  eManagementTopAppBarPage({Key? key})
      : preferredSize = const Size.fromHeight(kToolbarHeight),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.black,
      foregroundColor: Colors.white,
      title: const Text("User Profile"),
      actions: [
        IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () {
            // Set the userId to null in the UserSession
            UserSession().setUserId(null);

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

class UserSession {
  String? _userId;

  void setUserId(String? userId) {
    _userId = userId;
  }

  String? getUserId() {
    return _userId;
  }
}
