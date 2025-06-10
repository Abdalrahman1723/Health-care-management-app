import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_care_app/core/utils/app_colors.dart';
import 'package:health_care_app/patient_features/main%20page/presentation/widgets/avatar.dart';
import 'package:health_care_app/patient_features/personal%20profile/presentation/cubit/user_profile_cubit.dart';
import 'package:health_care_app/patient_features/personal%20profile/presentation/cubit/user_profile_state.dart';
import 'package:health_care_app/patient_features/personal%20profile/presentation/widgets/gradient_button.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  DateTime? _selectedDate;
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  String patientID =
      "1"; //! this is a temp (later should be actorId) with shared pref
  String _selectedGender = 'male'; // Default value with lowercase to match API
  // Track initial values
  String _initialName = '';
  String _initialPhone = '';
  String _initialGender = 'male';
  DateTime? _initialDate;

  bool get _hasChanges {
    return _nameController.text != _initialName ||
        _phoneController.text != _initialPhone ||
        _selectedGender != _initialGender ||
        _selectedDate != _initialDate;
  }

  @override
  void initState() {
    super.initState();
    // Fetch user data when screen loads
    context.read<UserProfileCubit>().fetchUserData(patientID);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _updateProfile() {
    late final age = DateTime.now().year - _selectedDate!.year;
    if (_formKey.currentState!.validate()) {
      final updateData = {
        'personName': _nameController.text, //?name is not updated
        'phoneNumber': _phoneController.text, //?phone is not updated
        'gender': _selectedGender,
        if (_selectedDate != null)
          'dateOfBirth': _selectedDate!.toIso8601String(),
        "NationalID": "30307010103319", //just a temp value
        "age": age,
      };
      _selectedDate = _initialDate;
      context.read<UserProfileCubit>().updateUserData(updateData, patientID);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserProfileCubit, UserProfileState>(
      listener: (context, state) {
        if (state is ProfileLoaded) {
          // Populate form fields with user data
          _nameController.text = state.userData.name;
          _phoneController.text = state.userData.phoneNumber ?? "";
          _emailController.text = state.userData.email;
          _selectedDate = state.userData.dateOfBirth;
          _selectedGender = state.userData.gender;

          // Store initial values
          _initialName = state.userData.name;
          _initialPhone = _phoneController.text;
          _initialGender = state.userData.gender;
          _initialDate = state.userData.dateOfBirth;
        } else if (state is ProfileError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(250),
            child: AppBar(
              leading: IconButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(Colors.transparent),
                ),
                onPressed: () => Navigator.pop(context),
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Colors.white,
                ),
              ),
              automaticallyImplyLeading: false,
              flexibleSpace: Container(
                padding: const EdgeInsets.only(top: 12),
                decoration:
                    BoxDecoration(gradient: AppColors.containerBackground),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        "Profile",
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                      const SizedBox(height: 8.0),
                      Center(
                        child: InkWell(
                          onTap: () {
                            //image picker
                          },
                          child: avatar(
                            context: context,
                            editIconSize: 18,
                            avatarSize: 60,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              centerTitle: true,
            ),
          ),
          body: state is ProfileLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //--------------name---------------//
                            Text(
                              'Full Name',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(color: Colors.black),
                            ),
                            TextFormField(
                              maxLength: 50,
                              controller: _nameController,
                              style: Theme.of(context).textTheme.displayMedium,
                              decoration: const InputDecoration(
                                hintText: 'Enter your full name',
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your name';
                                }
                                return null;
                              },
                              onChanged: (_) => setState(() {}),
                            ),
                            const SizedBox(height: 16.0),
                            //--------------phone number---------------//
                            Text(
                              'Phone Number',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(color: Colors.black),
                            ),
                            TextFormField(
                              controller: _phoneController,
                              style: Theme.of(context).textTheme.displayMedium,
                              decoration: const InputDecoration(
                                hintText: 'Enter your phone number',
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.phone,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your phone number';
                                }
                                return null;
                              },
                              onChanged: (_) => setState(() {}),
                            ),
                            const SizedBox(height: 16.0),
                            //--------------email---------------//
                            Text(
                              'Email',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(color: Colors.black),
                            ),
                            TextFormField(
                              readOnly: true,
                              initialValue: "abdalrahman@gmail.com", //!temp
                              // controller: _emailController,
                              style: Theme.of(context).textTheme.displayMedium,
                              decoration: const InputDecoration(
                                hintText: 'Enter your email',
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your email';
                                }
                                if (!value.contains('@')) {
                                  return 'Please enter a valid email';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16.0),
                            //--------------gender---------------//
                            Text(
                              'Gender',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(color: Colors.black),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: _selectedGender,
                                  isExpanded: true,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  items: ['male', 'female'].map((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(
                                        value[0].toUpperCase() +
                                            value.substring(1),
                                        style: const TextStyle(
                                            color: Colors.black),
                                      ), // Capitalize first letter for display
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    if (newValue != null) {
                                      setState(() {
                                        _selectedGender = newValue;
                                      });
                                    }
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(height: 16.0),
                            //--------------DOB---------------//
                            Text(
                              'Date of Birth',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(color: Colors.black),
                            ),
                            GestureDetector(
                              onTap: () async {
                                DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: _selectedDate ?? DateTime.now(),
                                  firstDate: DateTime(1900),
                                  lastDate: DateTime.now(),
                                );
                                if (pickedDate != null &&
                                    pickedDate != _selectedDate) {
                                  setState(() {
                                    _selectedDate = pickedDate;
                                  });
                                }
                              },
                              child: AbsorbPointer(
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    hintText: _selectedDate == null
                                        ? 'DD/MM/YYYY'
                                        : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                                    border: const OutlineInputBorder(),
                                    suffixIcon: const Icon(Icons.date_range),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 18),
                            //=============update profile button=============//
                            Center(
                              child: Container(
                                width: 200,
                                decoration: BoxDecoration(
                                  gradient: _hasChanges
                                      ? AppColors.containerBackground
                                      : const LinearGradient(
                                          colors: [Colors.grey, Colors.grey],
                                        ),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: InkWell(
                                  onTap: _hasChanges ? _updateProfile : null,
                                  borderRadius: BorderRadius.circular(30),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 30, vertical: 15),
                                    child: Center(
                                      child: Text(
                                        'Update profile',
                                        style: TextStyle(
                                          color: _hasChanges
                                              ? Colors.white
                                              : Colors.white.withOpacity(0.7),
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
        );
      },
    );
  }
}
