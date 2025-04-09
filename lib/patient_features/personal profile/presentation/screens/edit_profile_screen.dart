import 'package:flutter/material.dart';
import 'package:health_care_app/core/utils/app_colors.dart';
import 'package:health_care_app/patient_features/main%20page/presentation/widgets/avatar.dart';
import 'package:health_care_app/patient_features/personal%20profile/presentation/widgets/gradient_button.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  DateTime? _selectedDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(250),
        child: AppBar(
          // the back button
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
            // for gradient color background
            decoration: BoxDecoration(gradient: AppColors.containerBackground),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  //the title
                  Text(
                    "Profile",
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  const SizedBox(height: 8.0),
                  Center(
                    child:
                        //the user avatar
                        InkWell(
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
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // the name
                Text(
                  'Full Name',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                TextFormField(
                  style: Theme.of(context).textTheme.displayMedium,
                  decoration: const InputDecoration(
                    hintText: 'Enter your full name',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16.0),
                // phone number
                Text(
                  'Phone Number',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                TextFormField(
                  style: Theme.of(context).textTheme.displayMedium,
                  decoration: const InputDecoration(
                    hintText: 'Enter your phone number',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 16.0),
                // email
                Text(
                  'Email',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                TextFormField(
                  style: Theme.of(context).textTheme.displayMedium,
                  decoration: const InputDecoration(
                    hintText: 'Enter your email',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16.0),
                // DOB
                Text(
                  'Date of Birth',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                GestureDetector(
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    );
                    if (pickedDate != null && pickedDate != _selectedDate) {
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
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Center(child: gradientButton),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
