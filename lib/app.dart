//the root of the app
import 'package:flutter/material.dart';
import 'package:quotes/config/routes/routes.dart';
import 'package:quotes/config/theme/app_theme.dart';
import 'package:quotes/core/utils/app_strings.dart';

class QuoteApp extends StatelessWidget {
  const QuoteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: AppStrings.appName,
      theme: appTheme(),
      routes: routes, //using routes insted of home
    );
  }
}
