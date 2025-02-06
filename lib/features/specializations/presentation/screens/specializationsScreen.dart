import 'package:flutter/material.dart';
import 'package:health_care_app/core/utils/app_colors.dart';
import 'package:health_care_app/core/utils/app_icons.dart';
import 'package:health_care_app/features/main%20page/presentation/widgets/specialty.dart';

class SpecializationsScreen extends StatefulWidget {
  const SpecializationsScreen({super.key});

  @override
  State<SpecializationsScreen> createState() => _SpecializationsScreenState();
}

class _SpecializationsScreenState extends State<SpecializationsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(150),
        child: AppBar(
          leading: IconButton(
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(Colors.transparent),
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
            // for gradiant color background
            decoration: BoxDecoration(gradient: AppColors.containerBackground),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Specializations",
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    "Find the right doctor for you",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 8.0),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search...',
                        border: InputBorder.none,
                        icon: Icon(Icons.search, color: AppColors.primary),
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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              GridView.count(
                physics: const NeverScrollableScrollPhysics(), //for scroll
                crossAxisCount: 2,
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 35),
                shrinkWrap: true,
                crossAxisSpacing: 8,
                mainAxisSpacing: 16,
                children: [
                  //specilaty 1
                  specilaty(AppIcons.cardiology, "Cardiology"),
                  //specilaty 2
                  specilaty(AppIcons.dermatology, "Dermatology"),
                  //specilaty 3
                  specilaty(AppIcons.generalMedicine, "General Medicine"),
                  //specilaty 4
                  specilaty(AppIcons.gynecology, "Gynecology"),
                  //specilaty 5
                  specilaty(AppIcons.odontology, "Odontology"),
                  //specilaty 6
                  specilaty(AppIcons.oncology, "Oncology"),
                  //specilaty 7
                  specilaty(AppIcons.orthopedics, "Orthopedics"),
                  //specilaty 8
                  specilaty(AppIcons.otolaryngology, "Pediatrics"),
                  //specilaty 9
                  specilaty(AppIcons.ophtamology, "ophtamology"),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
