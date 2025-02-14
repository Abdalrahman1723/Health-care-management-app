import 'package:health_care_app/features/app%20settings/presentation/screens/notification_settings_screen.dart';
import 'package:health_care_app/features/app%20settings/presentation/screens/settings_screen.dart';
import 'package:health_care_app/features/main%20page/presentation/screens/main_screen.dart';
import 'package:health_care_app/features/personal%20profile/presentation/screens/edit_profile_screen.dart';
import 'package:health_care_app/features/specializations/presentation/screens/specializations_screen.dart';
import '../../features/personal profile/presentation/screens/user_profile_screen.dart';

class Routes {
  static const String initialRoute = '/';
  static const String specializationsScreen = '/SpecializationsScreen';
  static const String userProfileScreen = '/UserProfileScreen';
  static const String settingsScreen = '/SettingsScreen';
  static const String editProfileScreen = '/EditProfileScreen';
  static const String notificationSettingsScreen = '/NotificationSettingsScreen';
  
}

final routes = {
  Routes.initialRoute: (context) => const MainScreen(),
  Routes.specializationsScreen: (context) => const SpecializationsScreen(),
  Routes.userProfileScreen: (context) => const UserProfileScreen(),
  Routes.settingsScreen: (context) => const SettingsScreen(),
  Routes.editProfileScreen: (context) => const EditProfileScreen(),
  Routes.notificationSettingsScreen: (context) => const NotificationSettingsScreen(),
};
