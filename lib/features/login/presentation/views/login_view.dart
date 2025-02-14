import 'package:health_care_app/config/routes/routes.dart';
import 'package:health_care_app/features/password_manager/presentation/view/password_manager_view.dart';
import 'package:health_care_app/features/signup/presentation/widgets/signup_widget.dart';
import 'package:flutter/material.dart';
import '../../../../core/global/custom_text_filed/custom_text_field.dart';
import '../../../all_appointments/presentation/views/all_appointment_view.dart';
import '../../../doctors/presentation/widgets/doctors_widget.dart';
import '../../../forget_password/presentation/widgets/forget_password_screen.dart';

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
    return Theme(
      data: ThemeData(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),

                  // Welcome Text
                  const Text(
                    "Welcome",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0BDCDC),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Welcome! Please log in to continue. Enter your email or mobile number and password to access your account. If you don’t have an account, sign up now!",
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 24),

                  // Email Input
                  const Text(
                    "Email",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  CustomTextField(
                    controller: _emailController,
                    formKey: _formKey,
                    label: "Email",
                    isEmail: true,
                  ),
                  const SizedBox(height: 16),

                  // Password Input
                  const Text(
                    "Password",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  CustomTextField(
                    controller: _passwordController,
                    formKey: _formKey,
                    label: "Password",
                    isPassword: true,
                  ),
                  const SizedBox(height: 10),

                  // Forget Password
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const ForgetPasswordScreen()));
                      },
                      child: const Text(
                        "Forget Password",
                        style: TextStyle(color: Color(0xFF0BDCDC)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Log In Button
                  Center(
                    child: SizedBox(
                      width: 200,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0BDCDC),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            // تنفيذ عملية تسجيل الدخول
                            Navigator.pushNamed(context, Routes.mainScreen);
                            // context.go(AppRoute.mainScreen);
                          }
                        },
                        child: const Text(
                          "Log In",
                          style: TextStyle(fontSize: 25, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Sign Up
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don’t have an account?"),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignUpScreen()),
                          );
                        },
                        child: const Text(
                          "Sign Up",
                          style: TextStyle(
                              color: Color(0xFF0BDCDC),
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),

                  // Navigation to Other Screens
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const DoctorsScreen()));
                    },
                    child: const Text("Doctors"),
                  ),

                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const AllAppointmentsScreen()));
                    },
                    child: const Text("AllAppointments"),
                  ),

                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const PasswordManagerScreen()));
                    },
                    child: const Text("Password Manager"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
