import 'package:flutter/material.dart';

class PasswordManagerScreen extends StatelessWidget {
  const PasswordManagerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF0BDCDC),
        title: const Text(
          'Log In',
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
      body: PasswordManagerScreen(),
    );
  }
}
