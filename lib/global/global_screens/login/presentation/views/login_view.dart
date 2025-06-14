import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_care_app/admin_module/features/admin_main_page/presentation/screens/admin_main_screen.dart';
import 'package:health_care_app/global/global_screens/login/presentation/cubit/login_state.dart';
import 'package:health_care_app/global/global_screens/signup/presentation/widgets/signup_widget.dart';
import 'package:flutter/material.dart';
import '../../../../../core/global/custom_text_filed/custom_text_field.dart';
import '../../../../../doctor_module/features/doctor_home/presentation/widgets/doctor_home_widget.dart';
import '../../../../../patient_features/forget_password/presentation/widgets/forget_password_screen.dart';
import '../../../../../patient_features/main page/presentation/screens/main_screen.dart';
import '../cubit/login_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Get screen size
    final size = MediaQuery.of(context).size;
    final padding = MediaQuery.of(context).padding;
    final screenHeight = size.height - padding.top - padding.bottom;

    return Theme(
      data: ThemeData(),
      child: BlocListener<LoginCubit, LoginState>(
        listener: (context, state) async {
          if (state is LoginLoading) {
            // عرض loading dialog
            showDialog(
                context: context,
                barrierDismissible: false, // منع الإغلاق بالضغط خارج النافذة
                builder: (_) =>
                    const Center(child: CircularProgressIndicator()));
          } else if (state is LoginSuccess) {
            // إغلاق loading dialog
            Navigator.pop(context);

            // حفظ البيانات في SharedPreferences
            final prefs = await SharedPreferences.getInstance();
            await prefs.setString('token', state.loginEntity.token);
            await prefs.setString('role', state.loginEntity.role);
            await prefs.setString('actorId', state.loginEntity.id.toString());
            await prefs.setInt(
                'patientId',
                state
                    .loginEntity.id); // حفظ patientId لاستخدامه في جلب المواعيد

            // التنقل حسب نوع المستخدم
            final role = state.loginEntity.role.trim().toLowerCase();
            if (role == 'patient') {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const MainScreen()));
            } else if (role == 'doctor') {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const DoctorHomeWidget()));
            } else if (role == 'superadmin') {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const AdminMainScreen())); //! added admin
            } else {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content:
                      Text("نوع مستخدم غير معروف: ${state.loginEntity.role}")));
            }

            print("user Id: ${state.loginEntity.id}");
            print("token: ${state.loginEntity.token}");
            print("role: ${state.loginEntity.role}");
          } else if (state is LoginFailure) {
            // إغلاق loading dialog
            Navigator.pop(context);

            // عرض رسالة الخطأ
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("خطأ: ${state.error}")),
            );
          }
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.06, // 6% of screen width
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                          height: screenHeight * 0.03), // 3% of screen height

                      // Welcome Text
                      Text(
                        "Welcome",
                        style: TextStyle(
                          fontSize: size.width * 0.065, // Responsive font size
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF0BDCDC),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.01),
                      Text(
                        "Welcome! Please log in to continue. Enter your email or mobile number and password to access your account. If you don't have an account, sign up now!",
                        style: TextStyle(
                          fontSize: size.width * 0.035, // Responsive font size
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.03),

                      // Email Input
                      Text(
                        "Email",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: size.width * 0.04,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.01),
                      CustomTextField(
                        controller: _emailController,
                        formKey: _formKey,
                        label: "Email",
                        isEmail: true,
                      ),
                      SizedBox(height: screenHeight * 0.02),

                      // Password Input
                      Text(
                        "Password",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: size.width * 0.04,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.01),
                      CustomTextField(
                        controller: _passwordController,
                        formKey: _formKey,
                        label: "Password",
                        isPassword: true,
                      ),
                      SizedBox(height: screenHeight * 0.01),

                      // Forget Password
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const ForgetPasswordScreen(),
                              ),
                            );
                          },
                          child: Text(
                            "Forget Password",
                            style: TextStyle(
                              color: const Color(0xFF0BDCDC),
                              fontSize: size.width * 0.035,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.03),

                      // Log In Button

                      Center(
                        child: SizedBox(
                          width: size.width * 0.5, // 50% of screen width
                          height: screenHeight * 0.06, // 6% of screen height
                          child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                context.read<LoginCubit>().login(
                                      email: _emailController.text.trim(),
                                      password: _passwordController.text.trim(),
                                    );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Text(
                              "Login",
                              style: TextStyle(
                                fontSize: size.width * 0.04,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.03),

                      // Sign Up
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have an account?",
                            style: TextStyle(
                              fontSize: size.width * 0.035,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SignUpScreen(),
                                ),
                              );
                            },
                            child: Text(
                              "Sign Up",
                              style: TextStyle(
                                color: const Color(0xFF0BDCDC),
                                fontWeight: FontWeight.bold,
                                fontSize: size.width * 0.035,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

void showErrorDialog(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Error'),
      content: Text(
        message,
        style: const TextStyle(color: Colors.black),
        textAlign: TextAlign.center,
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('OK'),
        ),
      ],
    ),
  );
}
