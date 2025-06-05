import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_care_app/config/routes/routes.dart';
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
    return Theme(
      data: ThemeData(),
      child: BlocListener<LoginCubit, LoginState>(
        listener: (context, state) async {
          if (state is LoginLoading) {
            showDialog(context: context, builder: (_) => Center(child: CircularProgressIndicator()));
          } else if (state is LoginSuccess) {
            Navigator.pop(context);
            final prefs = await SharedPreferences.getInstance();
            await prefs.setString('token', state.loginEntity.token);
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MainScreen()));
            print("user Id: ${state.loginEntity.id}");
            print("token: ${state.loginEntity.token}");

          }else if (state is LoginFailure) {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("خطأ: ${state.error}")),
            );
          }
        },
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
                            onPressed: () async {
                              final token = await context.read<LoginCubit>().login(
                                email: _emailController.text,
                                password: _passwordController.text,
                              );

                              if (token != null) {
                                // خزني التوكن في SharedPreferences
                                final prefs = await SharedPreferences.getInstance();
                                await prefs.setString('token', token);

                                // بعدها اعملي التنقل للشاشة الرئيسية
                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MainScreen()));
                              } else {
                                // لو فشل اللوجن، ممكن تخلي الـ BlocListener يعرض رسالة الخطأ
                              }
                            },

                            child: Text("Login"),
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

                  ],
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
    builder: (context) =>
        AlertDialog(
          title: const Text('Error'),
          content: Text(
            message,
            style: const TextStyle(color: Colors.black),
            textAlign: TextAlign.center,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // إغلاق الـ Dialog
              },
              child: const Text('OK'),
            ),
          ],
        ),
  );
}
