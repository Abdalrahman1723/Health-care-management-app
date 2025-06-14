import 'package:health_care_app/admin_module/features/add_doctor/presentation/screens/admin_add_doctor_screen.dart';
import 'package:health_care_app/patient_features/notifications/presentation/screens/notifications_screen.dart';
import 'package:health_care_app/patient_features/personal%20profile/presentation/screens/medical_history_screen.dart';
import '../../patient_features/ML_predection/presentation/screens/prediction_screen.dart';
import '../../patient_features/all_appointment_completed/presentation/views/all_appointment_complete_view.dart';
import '../../patient_features/app settings/presentation/screens/notification_settings_screen.dart';
import 'package:health_care_app/patient_features/app%20settings/presentation/screens/settings_screen.dart';
import 'package:health_care_app/global/global_screens/login/presentation/widgets/login_widget.dart';
import 'package:health_care_app/global/global_screens/login_and_signup/presentation/views/login_and_signup_view.dart';
import 'package:health_care_app/patient_features/main%20page/presentation/screens/main_screen.dart';
import 'package:health_care_app/patient_features/personal%20profile/presentation/screens/edit_profile_screen.dart';
import 'package:health_care_app/global/global_screens/signup/presentation/widgets/signup_widget.dart';
import 'package:health_care_app/patient_features/specializations/presentation/screens/specializations_screen.dart';
import 'package:health_care_app/global/global_screens/welcome/welcome.dart';
import '../../patient_features/app settings/presentation/screens/password_manager_view.dart';
import '../../patient_features/appointment_details/presentation/views/all_appointment_details_view.dart';
import '../../patient_features/doctors/presentation/widgets/doctors_widget.dart';
import '../../patient_features/personal profile/presentation/screens/user_profile_screen.dart';
import 'package:go_router/go_router.dart';

class Routes {
  //---------

  static const String welcome = "/"; //?initial route
  static const String mainScreen = '/MainScreen';
  static const String specializationsScreen = '/SpecializationsScreen';
  static const String userProfileScreen = '/UserProfileScreen';
  static const String settingsScreen = '/SettingsScreen';
  static const String editProfileScreen = '/EditProfileScreen';
  static const String notificationSettingsScreen =
      '/NotificationSettingsScreen';
  static const String login = "/LoginScreen";
  static const String loginAndSignup = "/LoginAndSignupScreen";
  static const String signup = "/SignUpScreen";
  static const String passwordManager = "/PasswordManagerScreen";
  static const String allDoctors = "/DoctorsWidget";
  static const String favDoctors = "/FavDoctors";
  static const String notificationsScreen = "/NotificationsScreen";
  static const String addReviewScreen = "/AddReviewScreen";
  static const String allAppointments = "/AllAppointments";
  static const String appointmentDetailsScreen = "/AppointmentDetailsScreen";
  static const String adminAddDoctorScreen = '/AdminAddDoctorScreen';
  static const String doctorProfileScreen = '/DoctorProfileScreen';
  static const String medicalHistoryScreen = '/MedicalHistoryScreen';
  static const String predictionScreen = '/PredictionScreen';
}

final routes = {
  Routes.welcome: (context) => const WelcomeScreen(),
  Routes.mainScreen: (context) => const MainScreen(),
  Routes.specializationsScreen: (context) => const SpecializationsScreen(),
  Routes.userProfileScreen: (context) => const UserProfileScreen(),
  Routes.settingsScreen: (context) => const SettingsScreen(),
  Routes.editProfileScreen: (context) => const EditProfileScreen(),
  Routes.notificationSettingsScreen: (context) =>
      const NotificationSettingsScreen(),
  Routes.login: (context) => const LoginScreen(),
  Routes.loginAndSignup: (context) => const LoginAndSignupScreen(),
  Routes.signup: (context) => const SignUpScreen(),
  Routes.passwordManager: (context) => const PasswordManagerScreen(),
  Routes.allDoctors: (context) => const DoctorsWidget(),
  // Routes.favDoctors: (context) => const FavDoctors(), //handel favorite doctors
  Routes.notificationsScreen: (context) => const NotificationsScreen(),
  // Routes.addReviewScreen: (context) => const AddReviewScreen(), //!
  Routes.adminAddDoctorScreen: (context) => const AdminAddDoctorScreen(),
  Routes.medicalHistoryScreen: (context) => const MedicalHistoryScreen(),
  Routes.predictionScreen: (context) => const PredictionScreen(),
  Routes.allAppointments: (context) => const CompleteAppointmentsScreen(),
  Routes.appointmentDetailsScreen: (context) =>
      const AppointmentDetailsScreen(),
};

//---------------------------helana
class AppRoute {
  static const String login = "/";
  static const String loginAndSignup = "/";
  static const String welcome = "/";
  static const String signup = "/";
  static const String mainScreen = '/MainScreen';
  static const String specializationsScreen = '/SpecializationsScreen';
  static const String userProfileScreen = '/UserProfileScreen';
  static const String settingsScreen = '/SettingsScreen';
  static const String editProfileScreen = '/EditProfileScreen';
  static const String notificationSettingsScreen =
      '/NotificationSettingsScreen';

  static final router = GoRouter(
    routes: [
      GoRoute(
        path: welcome,
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
        path: loginAndSignup,
        builder: (context, state) => const LoginAndSignupScreen(),
      ),

      GoRoute(
        path: signup,
        builder: (context, state) => const SignUpScreen(),
      ),

      GoRoute(
        path: login,
        builder: (context, state) => const LoginScreen(),
      ),
      // Main Screens
      GoRoute(
        path: mainScreen,
        builder: (context, state) => const MainScreen(),
      ),
      GoRoute(
        path: Routes.specializationsScreen,
        builder: (context, state) => const SpecializationsScreen(),
      ),
      GoRoute(
        path: Routes.userProfileScreen,
        builder: (context, state) => const UserProfileScreen(),
      ),
      GoRoute(
        path: Routes.settingsScreen,
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: Routes.editProfileScreen,
        builder: (context, state) => const EditProfileScreen(),
      ),
      GoRoute(
        path: Routes.notificationSettingsScreen,
        builder: (context, state) => const NotificationSettingsScreen(),
      ),
    ],
  );
}
