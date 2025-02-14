import 'package:health_care_app/features/login/presentation/widgets/login_widget.dart';
import 'package:flutter/material.dart';

import '../../../../core/global/custom_text_filed/custom_text_field.dart';

class SignupView extends StatefulWidget {
  const SignupView({Key? key}) : super(key: key);

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();

  // bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),

                    // Full Name
                    const Text("Full Name *",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    CustomTextField(
                      controller: _fullNameController,
                      formKey: _formKey,
                      label: "Full Name",
                    ),

                    const SizedBox(height: 16),

                    // Email
                    const Text("Email *",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    CustomTextField(
                      controller: _emailController,
                      formKey: _formKey,
                      label: "Email",
                      isEmail: true,
                    ),

                    const SizedBox(height: 16),

                    // Password
                    const Text("Password *",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    CustomTextField(
                      controller: _passwordController,
                      formKey: _formKey,
                      label: "Password",
                      isPassword: true,
                    ),

                    const SizedBox(height: 16),

                    // Mobile Number
                    const Text("Mobile Number *",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    CustomTextField(
                      controller: _mobileController,
                      formKey: _formKey,
                      label: "Mobile Number",
                    ),

                    const SizedBox(height: 16),

                    // Date of Birth
                    const Text("Date of Birth *",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    CustomTextField(
                      controller: _dobController,
                      formKey: _formKey,
                      label: "DD / MM / YYYY",
                    ),

                    const SizedBox(height: 25),

                    // Sign Up Button
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
                              // تنفيذ عملية التسجيل
                            }
                          },
                          child: const Text(
                            "Sign Up",
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),

                    // Navigate to Login
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Already have an account?"),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginScreen()),
                            );
                          },
                          child: const Text(
                            "Log in",
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
