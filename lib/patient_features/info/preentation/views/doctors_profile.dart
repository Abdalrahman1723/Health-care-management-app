import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DoctorProfileScreen extends StatefulWidget {
  final int doctorId;
  const DoctorProfileScreen({Key? key, required this.doctorId}) : super(key: key);

  @override
  State<DoctorProfileScreen> createState() => _DoctorProfileScreenState();
}

class _DoctorProfileScreenState extends State<DoctorProfileScreen> {
  Map<String, dynamic>? doctorData;
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    fetchDoctorData();
  }

  Future<void> fetchDoctorData() async {
    setState(() {
      isLoading = true;
      error = null;
    });
    try {
      print('doctorId: [32m${widget.doctorId}[0m');
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      if (token == null) {
        setState(() {
          error = 'Authentication token not found. Please login again.';
          isLoading = false;
        });
        return;
      }
      final response = await Dio().get(
        'https://healthcaresystem.runasp.net/api/Patient/${widget.doctorId}',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      print('API response: [34m${response.data}[0m');
      setState(() {
        doctorData = response.data;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching doctor info: $e');
      setState(() {
        error = 'Failed to load doctor data. Please check your internet connection or try again later.';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : error != null
            ? Center(child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, color: Colors.red, size: 40),
                  const SizedBox(height: 12),
                  Text(error!, style: const TextStyle(color: Colors.red, fontSize: 18)),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: fetchDoctorData,
                    child: const Text('Retry'),
                  ),
                ],
              ))
            : doctorData == null
            ? const Center(child: Text('No data found for this doctor.', style: TextStyle(fontSize: 18)))
            : SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF0BDCDC), Color(0xFF00B4D8)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                        ),
                        const Spacer(),
                      ],
                    ),
                    CircleAvatar(
                      radius: 45,
                      backgroundImage: NetworkImage(doctorData!['photo'] ?? ''),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      doctorData!['fullName'] ?? '',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      doctorData!['specialization'] ?? '',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.star, color: Colors.yellow, size: 20),
                        const SizedBox(width: 4),
                        Text(
                          '${doctorData!['rating'] ?? ''}',
                          style: const TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        const SizedBox(width: 16),
                        const Icon(Icons.people, color: Colors.white, size: 20),
                        const SizedBox(width: 4),
                        Text(
                          '${doctorData!['reviewsCount'] ?? ''}',
                          style: const TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _infoChip(
                          icon: Icons.work,
                          label: '${doctorData!['experienceYears'] ?? ''} years experience',
                        ),
                        const SizedBox(width: 8),
                        _infoChip(
                          icon: Icons.access_time,
                          label: doctorData!['workingHours'] ?? '',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Focus
              if ((doctorData!['focus'] ?? '').isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: RichText(
                      text: TextSpan(
                        children: [
                          const TextSpan(
                            text: 'Focus: ',
                            style: TextStyle(
                              color: Color(0xFF0BDCDC),
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          TextSpan(
                            text: doctorData!['focus'] ?? '',
                            style: const TextStyle(
                              color: Colors.black87,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              // Profile, Career Path, Highlights
              _section('Profile', doctorData!['profile']),
              _section('Career Path', doctorData!['careerPath']),
              _section('Highlights', doctorData!['highlights']),
              // Clinic Name
              if ((doctorData!['clinicName'] ?? '').isNotEmpty)
                _section('Clinic Name', doctorData!['clinicName']),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoChip({required IconData icon, required String label}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF0BDCDC)),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF0BDCDC), size: 18),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF0BDCDC),
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _section(String title, String? value) {
    if (value == null || value.isEmpty) return const SizedBox();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Align(
        alignment: Alignment.centerLeft, // هذا السطر هو المهم
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0BDCDC),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              value,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
