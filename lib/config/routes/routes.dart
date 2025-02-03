import 'package:flutter/material.dart';
import 'package:quotes/features/random_quote/presentation/screens/quote_screen.dart';

class Routes {
  static const String initialRoute = '/';
  static const String favoriteQuoteRoute = '/favoriteQuote';
}

final routes = {
  Routes.initialRoute: (context) => const QuoteScreen(),
  Routes.favoriteQuoteRoute: (context) => Placeholder(), //there should be another screen here
};
