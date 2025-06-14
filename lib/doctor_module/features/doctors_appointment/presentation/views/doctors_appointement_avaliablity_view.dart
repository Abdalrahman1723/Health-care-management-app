import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class DoctorsAppointmentAvaliable extends StatefulWidget {
  const DoctorsAppointmentAvaliable({Key? key}) : super(key: key);

  @override
  State<DoctorsAppointmentAvaliable> createState() => _DoctorsAppointmentAvaliableState();
}

class _DoctorsAppointmentAvaliableState extends State<DoctorsAppointmentAvaliable> {
  List<Map<String, dynamic>> availabilities = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadAvailabilities();
  }

  Future<void> _loadAvailabilities() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      final doctorId = prefs.getString('actorId') ?? prefs.getString('doctorId');

      if (token == null || doctorId == null) {
        throw Exception('Doctor information not found');
      }

      final dio = Dio();
      final response = await dio.get(
        'https://healthcaresystem.runasp.net/api/Doctor/DoctorAvailabilitybyId',
        queryParameters: {'doctorId': doctorId},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        setState(() {
          if (response.data is List) {
            availabilities = List<Map<String, dynamic>>.from(response.data);
          } else if (response.data is Map) {
            availabilities = [Map<String, dynamic>.from(response.data)];
          } else {
            availabilities = [];
          }
          isLoading = false;
          errorMessage = null;
        });
      } else {
        throw Exception('Failed to load availabilities');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = e.toString();
      });
    }
  }

  String _formatTime(dynamic hour) {
    if (hour is int) hour = hour.toDouble();
    int h = hour.floor();
    int m = ((hour - h) * 60).round();
    String period = h >= 12 ? 'PM' : 'AM';
    int displayHour = h > 12 ? h - 12 : (h == 0 ? 12 : h);
    return '${displayHour.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')} $period';
  }

  String _formatDate(String dateStr) {
    try {
      final date = DateFormat('d-M-yyyy').parse(dateStr);
      return DateFormat('EEEE, MMM d, y').format(date);
    } catch (_) {
      return dateStr;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Color(0xFF0BDCDC),
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Available Appointments',
          style: TextStyle(
            color: theme.colorScheme.onPrimary,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme.colorScheme.onPrimary),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
          ? Center(
        child: Text(
          'Error: $errorMessage',
          style: const TextStyle(color: Colors.red),
        ),
      )
          : availabilities.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.event_busy,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No Available Appointments',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Add new appointments to see them here',
              style: TextStyle(
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      )
          : RefreshIndicator(
        onRefresh: _loadAvailabilities,
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: availabilities.length,
          itemBuilder: (context, index) {
            final avail = availabilities[index];
            return Card(
              elevation: 3,
              margin: const EdgeInsets.only(bottom: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              color: theme.cardColor,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.calendar_today, color: theme.primaryColor, size: 22),
                        const SizedBox(width: 8),
                        Text(
                          avail['day'] != null
                              ? toBeginningOfSentenceCase(avail['day']) ?? ''
                              : '',
                          style: TextStyle(
                            color: theme.primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Start Time',
                              style: TextStyle(
                                color: theme.hintColor,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              _formatTime(avail['startTimeInHours']),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: theme.primaryColorDark,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'End Time',
                              style: TextStyle(
                                color: theme.hintColor,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              _formatTime(avail['endTimeInHours']),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: theme.primaryColorDark,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Icon(Icons.date_range, color: Colors.blue, size: 20),
                        const SizedBox(width: 6),
                        Text(
                          _formatDate(avail['availableDate']),
                          style: const TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}