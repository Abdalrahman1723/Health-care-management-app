import 'package:flutter/material.dart';
import 'package:health_care_app/features/main%20page/presentation/screens/main_screen.dart';
class Routes {
  static const String initialRoute = '/';
  static const String favoriteQuoteRoute = '/favoriteQuote';
}

final routes = {
  Routes.initialRoute: (context) => const MainScreen(),
  Routes.favoriteQuoteRoute: (context) => const Placeholder(), //there should be another screen here
};
