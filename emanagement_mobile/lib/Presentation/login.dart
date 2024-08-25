import 'dart:io' show Platform; 
import 'package:emanagement_mobile/Services/user_service.dart';
import 'package:flutter/foundation.dart' show kIsWeb; 
import 'package:flutter/material.dart';
import '../Components/input_field.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  UserService userService = UserService();

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Determine if running on a desktop platform
    final isDesktop = !kIsWeb && (Platform.isWindows || Platform.isMacOS || Platform.isLinux);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              // icon
              const SizedBox(height: 50),
              const Icon(Icons.laptop, size: 100),
              const SizedBox(height: 50),

              // some message
              isDesktop ?  const Text("Administrator Panel",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ) :
              const Text("Sign In",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 50),

              // username text field
              LayoutBuilder(
                builder: (context, constraints) {
                  return Container(
                    width: isDesktop ? 500 : constraints.maxWidth, // Adjust width for desktop and mobile
                    margin: const EdgeInsets.symmetric(horizontal: 25),
                    child: InputField(
                      controller: usernameController,
                      hintText: "Username",
                      obscureText: false,
                    ),
                  );
                },
              ),
              const SizedBox(height: 10),

              // password text field
              LayoutBuilder(
                builder: (context, constraints) {
                  return Container(
                    width: isDesktop ? 500 : constraints.maxWidth, // Adjust width for desktop and mobile
                    margin: const EdgeInsets.symmetric(horizontal: 25),
                    child: InputField(
                      controller: passwordController,
                      hintText: "Password",
                      obscureText: true,
                    ),
                  );
                },
              ),

              // sign in button
              const SizedBox(height: 20),
              LayoutBuilder(
                builder: (context, constraints) {
                  return SizedBox(
                    width: isDesktop ? 500 : constraints.maxWidth, // Adjust width for desktop and mobile
                    child: GestureDetector(
                      onTap: () => userService.signIn(context, usernameController.text, passwordController.text), // Pass context to onClick
                      child: Container(
                        padding: EdgeInsets.all(isDesktop ? 20 : 15),
                        margin: const EdgeInsets.symmetric(horizontal: 25),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Center(
                          child: Text(
                            "Sign In",
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
