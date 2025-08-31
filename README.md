Credentials:

ADMINISTRATOR (Desktop)
Username: **administrator**
Password: **test**

EMPPLOYEE (Mobile, web)
Username: **employee**
Password: **test**


Recommender system:
[Reccomender sistem.docx](https://github.com/user-attachments/files/21048353/Reccomender.sistem.docx)

Apk i windows: https://www.sendspace.com/file/byp8k7 (zanemariti)

fit-build-2025-08-25.zip.001 password: fit







import 'package:flutter/material.dart';

enum NotificationType { success, error, info, warning }

class NotificationHelper {
  static void show(BuildContext context, String message, NotificationType type) {
    Color backgroundColor;

    switch (type) {
      case NotificationType.success:
        backgroundColor = Colors.green;
        break;
      case NotificationType.error:
        backgroundColor = Colors.red;
        break;
      case NotificationType.info:
        backgroundColor = Colors.blue;
        break;
      case NotificationType.warning:
        backgroundColor = Colors.yellow.shade700;
        break;
    }

    final snackBar = SnackBar(
      content: Text(message, style: TextStyle(color: Colors.white)),
      backgroundColor: backgroundColor,
      behavior: SnackBarBehavior.floating,
      duration: Duration(seconds: 3),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}


Future<void> createUser(BuildContext context, UserViewModel user) async {
  try {
    final userJson = user.toJson();

    final response = await apiHandler.postRequest(
      'api/Users/Register',
      body: userJson,
    );

    if (response.statusCode == 201) {
      NotificationHelper.show(context, "User created successfully", NotificationType.success);
    } else {
      NotificationHelper.show(context, "Failed to create user: ${response.body}", NotificationType.error);
    }
  } catch (e) {
    NotificationHelper.show(context, "An error occurred: $e", NotificationType.error);
  }
}

