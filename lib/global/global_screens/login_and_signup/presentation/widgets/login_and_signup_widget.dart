import 'package:health_care_app/core/utils/app_colors.dart';
import 'package:health_care_app/global/global_screens/login_and_signup/presentation/views/login_and_signup_view.dart';
import 'package:flutter/material.dart';

class LoginAndSignupWidget extends StatelessWidget {
  const LoginAndSignupWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.authColor,
      body: LoginAndSignupScreen(),
    );
  }
}
