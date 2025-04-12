import 'package:health_care_app/admin_module/features/admin_main_page/presentation/screens/admin_main_screen.dart';

class Routes {
  static const String mainScreen = '/MainScreen';
}

final routes = {
  Routes.mainScreen: (context) => const AdminMainScreen(),
};
