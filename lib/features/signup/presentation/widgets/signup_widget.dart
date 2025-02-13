import 'package:ecomerce_ieee/core/utils/app_color.dart';
import 'package:ecomerce_ieee/features/login_and_signup/presentation/views/login_and_signup_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../views/signup_view.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
appBar: AppBar(
  backgroundColor: Color(0xFF0BDCDC),
 title:  const Text(
    'New Account',
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

      body: SignupView(),
    );
  }
}
