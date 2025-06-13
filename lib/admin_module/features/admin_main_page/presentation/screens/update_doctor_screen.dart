import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_care_app/admin_module/core/utils/admin_app_bar.dart';
import 'package:health_care_app/admin_module/features/admin_main_page/presentation/cubit/admin_main_page_cubit.dart';
import 'package:health_care_app/core/utils/doctor_specialties.dart';
import 'package:health_care_app/global/entities/doctor.dart';

class AdminUpdateDoctorScreen extends StatefulWidget {
  final DoctorEntity doctor;

  const AdminUpdateDoctorScreen({
    super.key,
    required this.doctor,
  });

  @override
  State<AdminUpdateDoctorScreen> createState() =>
      _AdminUpdateDoctorScreenState();
}

class _AdminUpdateDoctorScreenState extends State<AdminUpdateDoctorScreen> {
  // Controllers for fields
  late final TextEditingController _userNameController;
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController;
  late final TextEditingController _clinicNameController;
  late final TextEditingController _bioController;
  late final TextEditingController _focusController;
  late final TextEditingController _careerPathController;
  late final TextEditingController _highlightsController;
  late final TextEditingController _experienceYearsController;
  late final TextEditingController _workingHoursController;
  late final TextEditingController _photoUrlController;

  // Selected specialization
  late DoctorSpecialty _selectedSpecialty;

  // Form key
  final _formKey = GlobalKey<FormState>();

  // Password visibility toggles
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with doctor's data, providing default values for nullable fields
    _userNameController = TextEditingController(text: widget.doctor.userName);
    _nameController = TextEditingController(text: widget.doctor.fullName ?? '');
    _phoneController =
        TextEditingController(text: widget.doctor.phoneNumber ?? '');
    _emailController = TextEditingController(text: widget.doctor.email);
    _passwordController = TextEditingController(text: widget.doctor.password);
    _confirmPasswordController =
        TextEditingController(text: widget.doctor.password);
    _clinicNameController = TextEditingController(text: widget.doctor.clinic);
    _bioController = TextEditingController(text: widget.doctor.bio);
    _focusController = TextEditingController(text: widget.doctor.focus);
    _careerPathController =
        TextEditingController(text: widget.doctor.careerPath);
    _highlightsController =
        TextEditingController(text: widget.doctor.highlights);
    _experienceYearsController =
        TextEditingController(text: widget.doctor.experienceYears.toString());
    _workingHoursController = TextEditingController(
        text: widget.doctor.availableSlots.isNotEmpty
            ? widget.doctor.availableSlots
                .map((slot) => slot.toString())
                .join(', ')
            : '');
    _photoUrlController =
        TextEditingController(text: widget.doctor.imageUrl ?? '');

    _selectedSpecialty = widget.doctor.specialty;
  }

  @override
  void dispose() {
    // Dispose controllers to free up resources
    _userNameController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _clinicNameController.dispose();
    _bioController.dispose();
    _focusController.dispose();
    _careerPathController.dispose();
    _highlightsController.dispose();
    _experienceYearsController.dispose();
    _workingHoursController.dispose();
    _photoUrlController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final updatedDoctor = DoctorEntity(
        id: "1",
        userName: _userNameController.text,
        fullName: _nameController.text,
        email: _emailController.text,
        password: _passwordController.text,
        imageUrl: _photoUrlController.text,
        specialty: _selectedSpecialty,
        rating: widget.doctor.rating,
        reviewCount: widget.doctor.reviewCount,
        availableSlots: widget.doctor.availableSlots,
        bio: _bioController.text,
        focus: _focusController.text,
        careerPath: _careerPathController.text,
        highlights: _highlightsController.text,
        experienceYears: int.parse(_experienceYearsController.text),
        clinic: _clinicNameController.text,
        phoneNumber: _phoneController.text,
      );

      context.read<AdminMainPageCubit>().updateDoctor(updatedDoctor);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        textTheme: const TextTheme(
          titleMedium: TextStyle(color: Colors.black, fontSize: 18),
          bodyMedium: TextStyle(color: Colors.black, fontSize: 18),
          titleLarge: TextStyle(color: Colors.black, fontSize: 18),
          labelMedium: TextStyle(color: Colors.black, fontSize: 18),
          bodyLarge: TextStyle(color: Colors.black, fontSize: 18),
        ),
      ),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: adminAppBar(context: context, title: "Update Doctor"),
        body: SafeArea(
          child: BlocConsumer<AdminMainPageCubit, AdminMainPageState>(
            listener: (context, state) {
              // Always show success and pop
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Doctor updated successfully'),
                  backgroundColor: Colors.green,
                ),
              );
              Navigator.pop(context);
            },
            builder: (context, state) {
              return SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Username Field
                          TextFormField(
                            maxLength: 25,
                            controller: _userNameController,
                            decoration: const InputDecoration(
                              labelText: 'Username',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a username';
                              }
                              if (value.length < 3) {
                                return 'Username must be at least 3 characters';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          // Name Field
                          TextFormField(
                            maxLength: 25,
                            controller: _nameController,
                            decoration: const InputDecoration(
                              labelText: 'Doctor Name',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter the doctor\'s name';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          // Specialization Dropdown
                          DropdownButtonFormField<DoctorSpecialty>(
                            dropdownColor: Colors.blue,
                            value: _selectedSpecialty,
                            decoration: const InputDecoration(
                              labelText: 'Specialization',
                              border: OutlineInputBorder(),
                            ),
                            items: DoctorSpecialty.values.map((specialty) {
                              return DropdownMenuItem<DoctorSpecialty>(
                                value: specialty,
                                child: Text(specialty.name),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedSpecialty = value!;
                              });
                            },
                            validator: (value) {
                              if (value == null) {
                                return 'Please select a specialization';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          // Phone Number Field
                          TextFormField(
                            maxLength: 15,
                            controller: _phoneController,
                            decoration: const InputDecoration(
                              labelText: 'Phone Number',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.phone,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter the phone number';
                              }
                              if (!RegExp(r'^\d{10,15}$').hasMatch(value)) {
                                return 'Please enter a valid phone number';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          // Email Address Field
                          TextFormField(
                            maxLength: 30,
                            controller: _emailController,
                            decoration: const InputDecoration(
                              labelText: 'Email Address',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter the email address';
                              }
                              if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                  .hasMatch(value)) {
                                return 'Please enter a valid email address';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          // Photo URL Field
                          TextFormField(
                            maxLength: 200,
                            controller: _photoUrlController,
                            decoration: const InputDecoration(
                              labelText: 'Photo URL',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a photo URL';
                              }
                              if (!Uri.tryParse(value)!.hasAbsolutePath) {
                                return 'Please enter a valid URL';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          // Working Hours Field
                          TextFormField(
                            maxLength: 100,
                            controller: _workingHoursController,
                            decoration: const InputDecoration(
                              labelText: 'Working Hours',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter working hours';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          // Clinic Name Field
                          TextFormField(
                            maxLength: 50,
                            controller: _clinicNameController,
                            decoration: const InputDecoration(
                              labelText: 'Clinic Name',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter the clinic name';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          // Bio Field
                          TextFormField(
                            maxLength: 250,
                            controller: _bioController,
                            decoration: const InputDecoration(
                              labelText: 'Bio',
                              border: OutlineInputBorder(),
                            ),
                            maxLines: 3,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a bio';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          // Focus Field
                          TextFormField(
                            maxLength: 100,
                            controller: _focusController,
                            decoration: const InputDecoration(
                              labelText: 'Focus',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter the doctor\'s focus';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          // Career Path Field
                          TextFormField(
                            maxLength: 100,
                            controller: _careerPathController,
                            decoration: const InputDecoration(
                              labelText: 'Career Path',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter the career path';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          // Highlights Field
                          TextFormField(
                            maxLength: 100,
                            controller: _highlightsController,
                            decoration: const InputDecoration(
                              labelText: 'Highlights',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter the highlights';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          // Experience Years Field
                          TextFormField(
                            maxLength: 2,
                            controller: _experienceYearsController,
                            decoration: const InputDecoration(
                              labelText: 'Experience Years',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter the years of experience';
                              }
                              if (int.tryParse(value) == null ||
                                  int.parse(value) < 0) {
                                return 'Please enter a valid number of years';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 32),

                          // Password Field
                          TextFormField(
                            maxLength: 30,
                            controller: _passwordController,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              border: const OutlineInputBorder(),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isPasswordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isPasswordVisible = !_isPasswordVisible;
                                  });
                                },
                              ),
                            ),
                            obscureText: !_isPasswordVisible,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a password';
                              }
                              if (value.length < 8) {
                                return 'Password must be at least 8 characters long';
                              }
                              if (!RegExp(
                                      r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,}$')
                                  .hasMatch(value)) {
                                return 'Password must contain at least one letter, one number, and one special character';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          // Confirm Password Field
                          TextFormField(
                            maxLength: 30,
                            controller: _confirmPasswordController,
                            decoration: InputDecoration(
                              labelText: 'Confirm Password',
                              border: const OutlineInputBorder(),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isConfirmPasswordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isConfirmPasswordVisible =
                                        !_isConfirmPasswordVisible;
                                  });
                                },
                              ),
                            ),
                            obscureText: !_isConfirmPasswordVisible,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please confirm the password';
                              }
                              if (value != _passwordController.text) {
                                return 'Passwords do not match';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 32),

                          // Submit Button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed:
                                  state is DoctorsLoading ? null : _submitForm,
                              child: state is DoctorsLoading
                                  ? const CircularProgressIndicator()
                                  : const Text('Update Doctor'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
