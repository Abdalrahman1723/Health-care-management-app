import 'package:health_care_app/features/main%20page/presentation/screens/main_screen.dart';
import 'package:health_care_app/features/personal%20profile/user_profile_screen.dart';
import 'package:health_care_app/features/specializations/presentation/screens/specializations_screen.dart';

class Routes {
  static const String initialRoute = '/';
  static const String specializationsScreen = '/SpecializationsScreen';
  static const String userProfileScreen = '/UserProfileScreen';
}

final routes = {
  Routes.initialRoute: (context) => const MainScreen(),
  Routes.specializationsScreen: (context) => const SpecializationsScreen(),
  Routes.userProfileScreen: (context) => const UserProfileScreen(),
};
