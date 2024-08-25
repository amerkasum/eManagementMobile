import 'package:emanagement_mobile/Context/api_handler.dart';
import 'package:emanagement_mobile/Models/Desktop/users_desktop_dto.dart';
import 'package:emanagement_mobile/Models/user_session.dart';
import 'package:emanagement_mobile/Models/Desktop/user_view_model.dart';
import 'package:emanagement_mobile/Models/users_dto.dart';
import 'package:emanagement_mobile/Presentation/events.dart';
import 'package:flutter/material.dart';

class UserService {
  final ApiHandler apiHandler = ApiHandler(baseUrl: 'https://localhost:5001');

  Future<List<UserDto>> getAllUsers() async {
    final response = await apiHandler.getRequest('api/Users/GetUsers');
    final List<dynamic> jsonResponse = response as List<dynamic>;
    return jsonResponse.map((model) => UserDto.fromJson(model)).toList();
  }

  Future<List<UserDesktopDto>> getAllDesktopUsers() async {
    final response = await apiHandler.getRequest('api/Users/GetUsersDesktop');
    final List<dynamic> jsonResponse = response as List<dynamic>;
    return jsonResponse.map((model) => UserDesktopDto.fromJson(model)).toList();
  }

   Future<bool> deleteUser(int userId) async {
    await apiHandler.deleteRequest(
      ('api/Users/Delete?id=$userId'),
    );

    return true;
  }

  Future<void> signIn(BuildContext context, String username, String password) async {
    try {
      final response = await apiHandler.postRequest(
        'api/Users/SignIn?username=$username&password=$password'
      );

      // Save the userId
      UserSession().userId = response['userId']; // Save the userId in UserSession

      // Navigate to EventsPage
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const EventsPage()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("An error occurred: $e")),
      );
    }
  }

  Future<void> createUser(UserViewModel user) async {
    try {
     
      final userJson = user.toJson(); 
  
      final response = await apiHandler.postRequest(
        'api/Users/Register',
        body: userJson, 
      );
  
      if (response.statusCode == 201) {

        print("User created successfully");
      } else {
        print("Failed to create user: ${response.body}");
      }
    } catch (e) {
      print("An error occurred while creating the user: $e");
    }
  }
}
