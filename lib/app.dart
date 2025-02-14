//the root of the app
import 'package:flutter/material.dart';
import 'package:health_care_app/config/routes/routes.dart';
import 'package:health_care_app/config/theme/app_theme.dart';
import 'package:health_care_app/core/utils/app_strings.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: AppStrings.appName,
      theme: appTheme(),
      routes: routes, //using routes instead of home
    );
  }
}
