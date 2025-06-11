import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_care_app/core/utils/app_colors.dart';
import 'package:health_care_app/patient_features/personal%20profile/presentation/cubit/user_profile_cubit.dart';
import 'package:health_care_app/patient_features/personal%20profile/presentation/cubit/user_profile_state.dart';
import 'package:health_care_app/patient_features/personal%20profile/presentation/widgets/icon_container.dart';

class MedicalHistoryScreen extends StatefulWidget {
  const MedicalHistoryScreen({super.key});

  @override
  State<MedicalHistoryScreen> createState() => _MedicalHistoryScreenState();
}

class _MedicalHistoryScreenState extends State<MedicalHistoryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _bloodTypeController = TextEditingController();
  final _chronicDiseasesController = TextEditingController();
  final _allergiesController = TextEditingController();
  final _currentMedicationsController = TextEditingController();
  String patientID =
      "3"; //! this is a temp (later should be actorId) with shared pref
  bool _isUpdating = false;

  // Track initial values
  String _initialBloodType = '';
  String _initialChronicDiseases = '';
  String _initialAllergies = '';
  String _initialCurrentMedications = '';

  bool get _hasChanges {
    return _bloodTypeController.text != _initialBloodType ||
        _chronicDiseasesController.text != _initialChronicDiseases ||
        _allergiesController.text != _initialAllergies ||
        _currentMedicationsController.text != _initialCurrentMedications;
  }

  @override
  void initState() {
    super.initState();
    context.read<UserProfileCubit>().fetchUserData(patientID);
  }

  @override
  void dispose() {
    _bloodTypeController.dispose();
    _chronicDiseasesController.dispose();
    _allergiesController.dispose();
    _currentMedicationsController.dispose();
    super.dispose();
  }

  void _updateMedicalInfo() {
    if (_formKey.currentState!.validate()) {
      final state = context.read<UserProfileCubit>().state;
      if (state is ProfileLoaded) {
        _isUpdating = true;
        final updateData = {
          // Medical info to update
          "bloodType": _bloodTypeController.text,
          "chronicDiseases": _chronicDiseasesController.text,
          "allergies": _allergiesController.text,
          "currentMedications": _currentMedicationsController.text,
          // Unchanged values from current state
          "personName": state.userData.name,
          "profilePicture": state.userData.imageUrl,
          "dateOfBirth": state.userData.dateOfBirth.toIso8601String(),
          "gender": state.userData.gender,
          "age": DateTime.now().year - (state.userData.dateOfBirth.year),
          "nationalID": "30307010103319", //temp value
          "email": state.userData.email,
          "phone": state.userData.phoneNumber,
          "insuranceProvider": state.userData.insuranceProvider,
        };
        context.read<UserProfileCubit>().updateUserData(updateData, patientID);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: AppBar(
          leading: IconButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.transparent),
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
            decoration: BoxDecoration(gradient: AppColors.containerBackground),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const SizedBox(height: 8.0),
                  Text(
                    "Medical History",
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                ],
              ),
            ),
          ),
          centerTitle: true,
        ),
      ),
      body: BlocConsumer<UserProfileCubit, UserProfileState>(
        listener: (context, state) {
          if (state is ProfileLoaded) {
            // Initialize medical info controllers with values from state
            setState(() {
              _bloodTypeController.text = state.userData.bloodType ?? "";
              _chronicDiseasesController.text =
                  state.userData.chronicDiseases ?? "";
              _allergiesController.text = state.userData.allergies ?? "";
              _currentMedicationsController.text =
                  state.userData.currentMedications ?? "";

              // Store initial values for change detection
              _initialBloodType = _bloodTypeController.text;
              _initialChronicDiseases = _chronicDiseasesController.text;
              _initialAllergies = _allergiesController.text;
              _initialCurrentMedications = _currentMedicationsController.text;
            });

            // Show success message if this is after an update
            if (_isUpdating) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Medical information updated successfully'),
                  backgroundColor: Colors.green,
                ),
              );
              _isUpdating = false;
            }
          } else if (state is ProfileError) {
            _isUpdating = false;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is ProfileLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProfileError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.message),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () {
                      context.read<UserProfileCubit>().fetchUserData(patientID);
                    },
                    child: const Text("Retry"),
                  ),
                ],
              ),
            );
          } else if (state is ProfileLoaded) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //--------------Blood Type---------------//
                      Text(
                        'Blood Type',
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
                            value: _bloodTypeController.text.isEmpty
                                ? null
                                : _bloodTypeController.text,
                            isExpanded: true,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            hint: const Text('Select Blood Type'),
                            items: [
                              'A+',
                              'A-',
                              'B+',
                              'B-',
                              'AB+',
                              'AB-',
                              'O+',
                              'O-'
                            ].map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: const TextStyle(color: Colors.black),
                                ),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              if (newValue != null) {
                                setState(() {
                                  _bloodTypeController.text = newValue;
                                });
                              }
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      //--------------Chronic Diseases---------------//
                      Text(
                        'Chronic Diseases',
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge!
                            .copyWith(color: Colors.black),
                      ),
                      TextFormField(
                        controller: _chronicDiseasesController,
                        style: Theme.of(context).textTheme.displayMedium,
                        decoration: const InputDecoration(
                          hintText:
                              'Enter any chronic diseases (if none, leave empty)',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 2,
                        onChanged: (_) => setState(() {}),
                      ),
                      const SizedBox(height: 16),
                      //--------------Allergies---------------//
                      Text(
                        'Allergies',
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge!
                            .copyWith(color: Colors.black),
                      ),
                      TextFormField(
                        controller: _allergiesController,
                        style: Theme.of(context).textTheme.displayMedium,
                        decoration: const InputDecoration(
                          hintText:
                              'Enter any allergies (if none, leave empty)',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 2,
                        onChanged: (_) => setState(() {}),
                      ),
                      const SizedBox(height: 16),
                      //--------------Current Medications---------------//
                      Text(
                        'Current Medications',
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge!
                            .copyWith(color: Colors.black),
                      ),
                      TextFormField(
                        controller: _currentMedicationsController,
                        style: Theme.of(context).textTheme.displayMedium,
                        decoration: const InputDecoration(
                          hintText:
                              'Enter current medications (if none, leave empty)',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 2,
                        onChanged: (_) => setState(() {}),
                      ),
                      const SizedBox(height: 24),
                      //=============update button=============//
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
                            onTap: _hasChanges ? _updateMedicalInfo : null,
                            borderRadius: BorderRadius.circular(30),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 15),
                              child: Center(
                                child: Text(
                                  'Update Medical Info',
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
            );
          }
          return const Center(child: Text("No data available"));
        },
      ),
    );
  }
}
