import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_care_app/core/utils/app_colors.dart';
import 'package:health_care_app/patient_features/personal%20profile/presentation/cubit/user_profile_cubit.dart';
import 'package:health_care_app/patient_features/personal%20profile/presentation/cubit/user_profile_state.dart';
import 'package:health_care_app/patient_features/personal%20profile/presentation/widgets/icon_container.dart';

class MedicalHistoryScreen extends StatelessWidget {
  const MedicalHistoryScreen({super.key});

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
      body: BlocBuilder<UserProfileCubit, UserProfileState>(
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
                      context.read<UserProfileCubit>().fetchUserData("12");
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildMedicalInfoSection(
                      context,
                      "Blood Type",
                      state.userData.bloodType ?? "Not specified",
                      Icons.bloodtype,
                    ),
                    const SizedBox(height: 16),
                    _buildMedicalInfoSection(
                      context,
                      "Chronic Diseases",
                      state.userData.chronicDiseases ?? "None",
                      Icons.medical_information,
                    ),
                    const SizedBox(height: 16),
                    _buildMedicalInfoSection(
                      context,
                      "Allergies",
                      state.userData.allergies ?? "None",
                      Icons.warning_amber_rounded,
                    ),
                    const SizedBox(height: 16),
                    _buildMedicalInfoSection(
                      context,
                      "Current Medications",
                      state.userData.currentMedications ?? "None",
                      Icons.medication,
                    ),
                  ],
                ),
              ),
            );
          }
          return const Center(child: Text("No data available"));
        },
      ),
    );
  }

  Widget _buildMedicalInfoSection(
    BuildContext context,
    String title,
    String content,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              iconContainer(icon),
              const SizedBox(width: 12),
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(color: Colors.black, fontSize: 20),
          ),
        ],
      ),
    );
  }
}
