import 'package:health_care_app/features/main%20page/presentation/screens/main_screen.dart';
import 'package:health_care_app/features/specializations/presentation/screens/specializationsScreen.dart';
class Routes {
  static const String initialRoute = '/';
  static const String specializationsScreen = '/SpecializationsScreen';
}

final routes = {
  Routes.initialRoute: (context) => const MainScreen(),
  Routes.specializationsScreen: (context) => const SpecializationsScreen(), //there should be another screen here
};
