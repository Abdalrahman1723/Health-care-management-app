import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class PatientProfileView extends StatefulWidget {
  final int patientId;
  const PatientProfileView({Key? key, required this.patientId}) : super(key: key);

  @override
  State<PatientProfileView> createState() => _PatientProfileViewState();
}

class _PatientProfileViewState extends State<PatientProfileView> {
  Map<String, dynamic>? patientData;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchPatientProfile();
  }

  Future<void> fetchPatientProfile() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });
    try {
      final response = await Dio().get(
        'https://healthcaresystem.runasp.net/api/PatientProfile/${widget.patientId}',
      );
      if (response.statusCode == 200) {
        setState(() {
          patientData = response.data;
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Failed to load profile';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error: $e';
        isLoading = false;
      });
    }
  }

  Widget _buildInfoRow(String label, String value, {IconData? icon, Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          if (icon != null)
            Icon(icon, color: color ?? Colors.teal, size: 22),
          if (icon != null) const SizedBox(width: 8),
          Text(
            "$label: ",
            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Colors.black87),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: theme.primaryColor,
        elevation: 0,
        title: const Text('Patient Profile', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
          ? Center(child: Text(errorMessage!, style: const TextStyle(color: Colors.red)))
          : patientData == null
          ? const Center(child: Text('No data found'))
          : SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // صورة البروفايل واسم المريض
            CircleAvatar(
              radius: 55,
              backgroundImage: patientData!['profilePicture'] != null &&
                  patientData!['profilePicture'].toString().isNotEmpty
                  ? NetworkImage(patientData!['profilePicture'])
                  : const AssetImage('assets/images/default_profile.png') as ImageProvider,
              backgroundColor: Colors.white,
            ),
            const SizedBox(height: 16),
            Text(
              patientData!['personName'] ?? '',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
                color: Color(0xFF0BDCDC),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              patientData!['email'] ?? '',
              style: const TextStyle(color: Colors.grey, fontSize: 16),
            ),
            const SizedBox(height: 20),

            // بيانات أساسية
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildInfoRow('Phone', patientData!['phone'] ?? '', icon: Icons.phone),
                    _buildInfoRow('Date of Birth', patientData!['dateOfBirth'] ?? '', icon: Icons.cake),
                    _buildInfoRow('Gender', patientData!['gender'] ?? '', icon: Icons.person),
                    _buildInfoRow('Age', patientData!['age']?.toString() ?? '', icon: Icons.calendar_today),
                    _buildInfoRow('National ID', patientData!['nationalID'] ?? '', icon: Icons.badge),
                    _buildInfoRow('Blood Type', patientData!['bloodType'] ?? '', icon: Icons.bloodtype),
                    _buildInfoRow('Insurance', patientData!['insuranceProvider'] ?? '', icon: Icons.verified_user),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // بيانات طبية
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Medical Info',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Color(0xFF0BDCDC))),
                    const Divider(),
                    _buildInfoRow('Chronic Diseases', patientData!['chronicDiseases'] ?? ''),
                    _buildInfoRow('Allergies', patientData!['allergies'] ?? ''),
                    _buildInfoRow('Current Medications', patientData!['currentMedications'] ?? ''),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}