import 'dart:developer';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_care_app/global/entities/doctor.dart';
import 'package:health_care_app/core/utils/doctor_specialties.dart';
import '../../../../../core/api/api_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'add_doctor_state.dart';

class AddDoctorCubit extends Cubit<AddDoctorState> {
  final ApiClient apiClient;
  String? authToken;

  AddDoctorCubit({required this.apiClient}) : super(AddDoctorInitial());

  // Validate doctor data before submission
  Map<String, String> _validateDoctorData({
    required String userName,
    required String fullName,
    required String specialization,
    required String email,
    required String password,
    required String phoneNumber,
    required String photo,
    required String workingHours,
    required String profile,
    required String focus,
    required String careerPath,
    required String highlights,
    required String clinicName,
    required int experienceYears,
    required int rating,
    required int reviewsCount,
  }) {
    final errors = <String, String>{};

    // Username validation
    if (userName.isEmpty) {
      errors['userName'] = 'Username is required';
    } else if (userName.length < 3) {
      errors['userName'] = 'Username must be at least 3 characters';
    }

    // Full name validation
    if (fullName.isEmpty) {
      errors['fullName'] = 'Full name is required';
    }

    // Specialization validation
    if (specialization.isEmpty) {
      errors['specialization'] = 'Specialization is required';
    } else {
      try {
        DoctorSpecialty.values.firstWhere(
          (e) =>
              e.toString().split('.').last.toLowerCase() ==
              specialization.toLowerCase(),
        );
      } catch (e) {
        errors['specialization'] = 'Invalid specialization';
      }
    }

    // Email validation
    if (email.isEmpty) {
      errors['email'] = 'Email is required';
    } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      errors['email'] = 'Invalid email format';
    }

    // Password validation
    if (password.isEmpty) {
      errors['password'] = 'Password is required';
    } else if (password.length < 8) {
      errors['password'] = 'Password must be at least 8 characters';
    } else if (!RegExp(
            r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,}$')
        .hasMatch(password)) {
      errors['password'] =
          'Password must contain at least one letter, one number, and one special character';
    }

    // Phone number validation
    if (phoneNumber.isEmpty) {
      errors['phoneNumber'] = 'Phone number is required';
    }

    // Photo URL validation
    if (photo.isEmpty) {
      errors['photo'] = 'Photo URL is required';
    } else {
      final uri = Uri.tryParse(photo);
      if (uri == null || !uri.hasAbsolutePath) {
        errors['photo'] = 'Invalid photo URL';
      }
    }

    // Working hours validation
    if (workingHours.isEmpty) {
      errors['workingHours'] = 'Working hours are required';
    }

    // Profile validation
    if (profile.isEmpty) {
      errors['profile'] = 'Profile is required';
    }

    // Focus validation
    if (focus.isEmpty) {
      errors['focus'] = 'Focus area is required';
    }

    // Career path validation
    if (careerPath.isEmpty) {
      errors['careerPath'] = 'Career path is required';
    }

    // Highlights validation
    if (highlights.isEmpty) {
      errors['highlights'] = 'Highlights are required';
    }

    // Clinic name validation
    if (clinicName.isEmpty) {
      errors['clinicName'] = 'Clinic name is required';
    }

    // Experience years validation
    if (experienceYears < 0) {
      errors['experienceYears'] = 'Experience years cannot be negative';
    }

    // Rating validation
    if (rating < 0 || rating > 10) {
      errors['rating'] = 'Rating must be between 0 and 10';
    }

    // Reviews count validation
    if (reviewsCount < 0) {
      errors['reviewsCount'] = 'Reviews count cannot be negative';
    }

    return errors;
  }

  // Add new doctor
  Future<void> addDoctor({
    required String userName,
    required String fullName,
    required String specialization,
    required String email,
    required String password,
    required String phoneNumber,
    required String photo,
    required String workingHours,
    required String profile,
    required String focus,
    required String careerPath,
    required String highlights,
    required String clinicName,
    required int experienceYears,
    required int rating,
    required int reviewsCount,
  }) async {
    emit(AddDoctorLoading());

    // Validate input data
    final errors = _validateDoctorData(
      userName: userName,
      fullName: fullName,
      specialization: specialization,
      email: email,
      password: password,
      phoneNumber: phoneNumber,
      photo: photo,
      workingHours: workingHours,
      profile: profile,
      focus: focus,
      careerPath: careerPath,
      highlights: highlights,
      clinicName: clinicName,
      experienceYears: experienceYears,
      rating: rating,
      reviewsCount: reviewsCount,
    );

    if (errors.isNotEmpty) {
      log('Validation errors: $errors', name: 'ADD_DOCTOR');
      emit(AddDoctorValidationError(errors));
      return;
    }

    try {
      // Get token from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      authToken = prefs.getString('token');

      if (authToken == null) {
        emit(const AddDoctorError('Authentication token not found'));
        return;
      }

      log('Adding new doctor...', name: 'ADD_DOCTOR');
      log('Request data: {userName: $userName, fullName: $fullName, specialization: $specialization, ...}',
          name: 'ADD_DOCTOR');

      final response = await apiClient.post(
        "Admin/doctors/add",
        headers: {
          'Authorization': 'Bearer $authToken',
          'Content-Type': 'application/json',
        },
        body: {
          'userName': userName,
          'fullName': fullName,
          'specialization': specialization,
          'email': email,
          'password': password,
          'phoneNumber': phoneNumber,
          'photo': photo,
          'workingHours': workingHours,
          'profile': profile,
          'focus': focus,
          'careerPath': careerPath,
          'highlights': highlights,
          'clinicName': clinicName,
          'experienceYears': experienceYears,
          'rating': rating,
          'reviewsCount': reviewsCount,
        },
      );

      if (response != null) {
        log('Doctor added successfully', name: 'ADD_DOCTOR');
        final doctor = DoctorEntity.fromJson(response as Map<String, dynamic>);
        emit(AddDoctorSuccess(doctor));
      } else {
        log('Failed to add doctor', name: 'ADD_DOCTOR');
        emit(const AddDoctorError('Failed to add doctor'));
      }
    } catch (e) {
      log('Error adding doctor: $e', name: 'ADD_DOCTOR');
      emit(AddDoctorError(e.toString()));
    }
  }
}
