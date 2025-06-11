import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_care_app/core/utils/app_colors.dart';
import 'package:health_care_app/patient_features/main%20page/presentation/widgets/avatar.dart';
import 'package:health_care_app/patient_features/personal%20profile/presentation/cubit/user_profile_cubit.dart';
import 'package:health_care_app/patient_features/personal%20profile/presentation/cubit/user_profile_state.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  DateTime? _selectedDate;
  final _formKey = GlobalKey<FormState>();
  final _picker = ImagePicker();
  String? _imagePath;
  //------------controllers
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  //------------medical info controllers
  final _bloodTypeController = TextEditingController();
  final _chronicDiseasesController = TextEditingController();
  final _allergiesController = TextEditingController();
  final _currentMedicationsController = TextEditingController();
  //------patient id
  String patientID =
      "3"; //! this is a temp (later should be actorId) with shared pref
  String _selectedGender = 'male'; // Default value with lowercase to match API
  // Track initial values
  String _initialName = '';
  String _initialPhone = '';
  String _initialGender = 'male';
  DateTime? _initialDate;
  bool _isUpdating = false; // Add flag to track update operation
  // Track initial medical values
  String _initialBloodType = '';
  String _initialChronicDiseases = '';
  String _initialAllergies = '';
  String _initialCurrentMedications = '';

  bool get _hasChanges {
    return _nameController.text != _initialName ||
        _phoneController.text != _initialPhone ||
        _selectedGender != _initialGender ||
        _selectedDate != _initialDate ||
        _bloodTypeController.text != _initialBloodType ||
        _chronicDiseasesController.text != _initialChronicDiseases ||
        _allergiesController.text != _initialAllergies ||
        _currentMedicationsController.text != _initialCurrentMedications;
  }

  @override
  void initState() {
    super.initState();
    // Fetch user data when screen loads
    context.read<UserProfileCubit>().fetchUserData(patientID);
    _loadImageFromPrefs();
  }

  Future<void> _loadImageFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final savedImagePath = prefs.getString('profile_image');
    if (savedImagePath != null) {
      setState(() {
        _imagePath = savedImagePath;
      });
    }
  }

  Future<void> _saveImageToPrefs(String imagePath) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('profile_image', imagePath);
  }

  Future<void> _pickImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 50,
      );

      if (pickedFile != null) {
        setState(() {
          _imagePath = pickedFile.path;
        });
        await _saveImageToPrefs(pickedFile.path);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to pick image'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _bloodTypeController.dispose();
    _chronicDiseasesController.dispose();
    _allergiesController.dispose();
    _currentMedicationsController.dispose();
    super.dispose();
  }

  //-----------------update profile function PUT
  void _updateProfile() {
    late final age = DateTime.now().year - _selectedDate!.year;
    if (_formKey.currentState!.validate()) {
      _isUpdating = true; // Set flag before update
      final updateData = {
        'personName': _nameController.text,
        'phoneNumber': _phoneController.text,
        'gender': _selectedGender,
        if (_selectedDate != null)
          'dateOfBirth': _selectedDate!.toIso8601String(),
        "NationalID": "30307010103319", //just a temp value
        "age": age,
        //unchanged values
        "bloodType": _bloodTypeController.text,
        "chronicDiseases": _chronicDiseasesController.text,
        "allergies": _allergiesController.text,
        "currentMedications": _currentMedicationsController.text,
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

          // Initialize medical info controllers
          _bloodTypeController.text = state.userData.bloodType ?? "";
          _chronicDiseasesController.text =
              state.userData.chronicDiseases ?? "";
          _allergiesController.text = state.userData.allergies ?? "";
          _currentMedicationsController.text =
              state.userData.currentMedications ?? "";

          // Store initial values
          _initialName = state.userData.name;
          _initialPhone = _phoneController.text;
          _initialGender = state.userData.gender;
          _initialDate = state.userData.dateOfBirth;
          _initialBloodType = _bloodTypeController.text;
          _initialChronicDiseases = _chronicDiseasesController.text;
          _initialAllergies = _allergiesController.text;
          _initialCurrentMedications = _currentMedicationsController.text;

          // Show success message if this is after an update
          if (_isUpdating) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Profile updated successfully'),
                backgroundColor: Colors.green,
              ),
            );
            _isUpdating = false; // Reset the flag
          }
        } else if (state is ProfileError) {
          _isUpdating = false; // Reset the flag on error
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
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
                          onTap: _pickImage,
                          child: Stack(
                            children: [
                              CircleAvatar(
                                radius: 60,
                                backgroundImage: _imagePath != null
                                    ? FileImage(File(_imagePath!))
                                    : const AssetImage('assets/images/man.png')
                                        as ImageProvider,
                              ),
                              Positioned(
                                bottom: 1,
                                right: 1,
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      width: 3,
                                      color: Colors.white,
                                    ),
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(50),
                                    ),
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        offset: const Offset(2, 4),
                                        color: Colors.black.withOpacity(0.3),
                                        blurRadius: 3,
                                      ),
                                    ],
                                  ),
                                  child: const Padding(
                                    padding: EdgeInsets.all(2.0),
                                    child: Icon(
                                      Icons.edit_outlined,
                                      color: Colors.black,
                                      size: 18,
                                    ),
                                  ),
                                ),
                              ),
                            ],
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
