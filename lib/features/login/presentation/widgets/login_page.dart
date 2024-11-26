import 'package:ecomerce_ieee/core/utils/app_color.dart';
import 'package:ecomerce_ieee/features/login/presentation/views/login_view_body.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.authColor,
      body: LoginViewBody(),
    );
  }
}
