import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

import '../../../update_appointement/presentation/update_appointement.dart';


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
        throw Exception('معلومات الطبيب غير موجودة');
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
        throw Exception('فشل تحميل المواعيد');
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
        backgroundColor: const Color(0xFF0BDCDC),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Availability Appointments',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
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
          'خطأ: $errorMessage',
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
              'لا توجد مواعيد متاحة',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'أضف مواعيد جديدة لرؤيتها هنا',
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
                        Icon(Icons.calendar_today,
                            color: theme.primaryColor, size: 25),
                        const SizedBox(width: 8),
                        Text(
                          avail['day'] != null
                              ? toBeginningOfSentenceCase(
                              avail['day']) ??
                              ''
                              : '',
                          style: TextStyle(
                            color: theme.primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.edit,
                              color: Color(0xFF0BDCDC)),
                          onPressed: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    UpdateAppointment(
                                      appointment: avail,
                                    ),
                              ),
                            );
                            if (result == true) {
                              _loadAvailabilities();
                            }
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            Text(
                              'start Time',
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
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            Text(
                              'end Time',
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
                        const Icon(Icons.date_range,
                            color: Colors.blue, size: 20),
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