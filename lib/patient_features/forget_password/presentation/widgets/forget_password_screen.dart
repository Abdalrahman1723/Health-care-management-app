import 'package:flutter/material.dart';
import '../views/forget_password_view.dart';

class ForgetPasswordScreen extends StatelessWidget {
  const ForgetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0BDCDC),
        title: const Text(
          'New Password',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
           color: Colors.white,
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: const SetPasswordScreen(),
    );
  }
}
