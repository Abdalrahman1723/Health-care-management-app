import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_care_app/global/global_screens/login/presentation/widgets/login_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../core/global/custom_text_filed/custom_text_field.dart';
import '../../../login/presentation/views/login_view.dart';
import '../cubit/register_cubit.dart';
import '../cubit/register_state.dart';

class SignupView extends StatefulWidget {
  const SignupView({Key? key}) : super(key: key);

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _personNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _dateOfBirthController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _nationalIDController = TextEditingController();
  final TextEditingController _chronicDiseasesController = TextEditingController();
  final TextEditingController _allergiesController = TextEditingController();
  final TextEditingController _currentMedicationsController = TextEditingController();
  final TextEditingController _insuranceProviderController = TextEditingController();

  String _selectedGender = 'Male';
  String _selectedBloodType = 'O';
  String _profilePicture = 'profile_url'; // Default value

  final List<String> _bloodTypes = ['O', 'A', 'B', 'AB'];
  final List<String> _genders = ['Male', 'Female'];

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(),
      child: BlocListener<RegisterCubit, RegisterState>(
        listener: (context, state) {
          if (state is RegisterLoading) {
            showDialog(context: context, builder: (_) => Center(child: CircularProgressIndicator()));
          } else if (state is RegisterSuccess) {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('تم التسجيل بنجاح')));
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
          } else if (state is RegisterFailure) {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('خطأ: ${state.error}')));
          }
        },
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

                      // Personal Name
                      const Text("Personal Name *",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      CustomTextField(
                        controller: _personNameController,
                        formKey: _formKey,
                        label: "Personal Name",
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
                        controller: _dateOfBirthController,
                        formKey: _formKey,
                        label: "Date of Birth (YYYY-MM-DD)",
                        onTap: () async {
                          final DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1900),
                            lastDate: DateTime.now(),
                          );
                          if (picked != null) {
                            _dateOfBirthController.text = DateFormat('yyyy-MM-dd').format(picked);
                          }
                        },
                      ),

                      const SizedBox(height: 16),

                      // Age
                      const Text("Age *",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      CustomTextField(
                        controller: _ageController,
                        formKey: _formKey,
                        label: "Age",
                        keyboardType: TextInputType.number,
                      ),

                      const SizedBox(height: 16),

                      // Gender
                      const Text("Gender *",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: _selectedGender,
                        items: _genders.map((String gender) {
                          return DropdownMenuItem<String>(
                            value: gender,
                            child: Text(gender),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedGender = newValue!;
                          });
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // National ID
                      const Text("National ID *",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      CustomTextField(
                        controller: _nationalIDController,
                        formKey: _formKey,
                        label: "National ID",
                      ),

                      const SizedBox(height: 16),

                      // Blood Type
                      const Text("Blood Type *",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: _selectedBloodType,
                        items: _bloodTypes.map((String bloodType) {
                          return DropdownMenuItem<String>(
                            value: bloodType,
                            child: Text(bloodType),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedBloodType = newValue!;
                          });
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Chronic Diseases
                      const Text("Chronic Diseases",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      CustomTextField(
                        controller: _chronicDiseasesController,
                        formKey: _formKey,
                        label: "Chronic Diseases (if any)",
                      ),

                      const SizedBox(height: 16),

                      // Allergies
                      const Text("Allergies",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      CustomTextField(
                        controller: _allergiesController,
                        formKey: _formKey,
                        label: "Allergies (if any)",
                      ),

                      const SizedBox(height: 16),

                      // Current Medications
                      const Text("Current Medications",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      CustomTextField(
                        controller: _currentMedicationsController,
                        formKey: _formKey,
                        label: "Current Medications (if any)",
                      ),

                      const SizedBox(height: 16),

                      // Insurance Provider
                      const Text("Insurance Provider",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      CustomTextField(
                        controller: _insuranceProviderController,
                        formKey: _formKey,
                        label: "Insurance Provider",
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
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                final cubit = context.read<RegisterCubit>();
                                cubit.register(
                                  username: _fullNameController.text,
                                  personName: _personNameController.text,
                                  phoneNumber: _mobileController.text,
                                  email: _emailController.text,
                                  password: _passwordController.text,
                                  profilePicture: _profilePicture,
                                  dateOfBirth: _dateOfBirthController.text,
                                  gender: _selectedGender,
                                  age: int.parse(_ageController.text),
                                  nationalID: _nationalIDController.text,
                                  bloodType: _selectedBloodType,
                                  chronicDiseases: _chronicDiseasesController
                                      .text,
                                  allergies: _allergiesController.text,
                                  currentMedications: _currentMedicationsController
                                      .text,
                                  insuranceProvider: _insuranceProviderController
                                      .text,
                                );
                              }
                            },
                            child: Text("تسجيل", style: TextStyle(color: Colors.white, fontSize: 25)),
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
          content: Text(message, style: const TextStyle(color: Colors.black),
            textAlign: TextAlign.center,),
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