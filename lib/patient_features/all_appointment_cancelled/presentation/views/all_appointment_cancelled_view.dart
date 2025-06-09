import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CancelledAppointmentsScreen extends StatefulWidget {
  const CancelledAppointmentsScreen({Key? key}) : super(key: key);

  @override
  State<CancelledAppointmentsScreen> createState() => _CancelledAppointmentsScreenState();
}

class _CancelledAppointmentsScreenState extends State<CancelledAppointmentsScreen> {
  List<dynamic> _cancelledAppointments = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCancelledAppointments();
  }

  Future<void> fetchCancelledAppointments() async {
    setState(() => _isLoading = true);
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      if (token == null) throw Exception('Missing token');
      final url = 'https://healthcaresystem.runasp.net/api/Patient/appointments?status=Canceled';
      final response = await Dio().get(
        url,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      setState(() {
        _cancelledAppointments = response.data is List ? response.data : [];
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _cancelledAppointments = [];
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _cancelledAppointments.isEmpty
            ? const Center(child: Text('لا يوجد مواعيد ملغاة'))
            : RefreshIndicator(
          onRefresh: fetchCancelledAppointments,
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _cancelledAppointments.length,
            itemBuilder: (context, index) {
              final appt = _cancelledAppointments[index];
              return Column(
                children: [
                  _buildCancelledAppointmentCard(appt),
                  const SizedBox(height: 16),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildCancelledAppointmentCard(dynamic appt) {
    final doctorName = (appt['doctor']?.toString().isNotEmpty ?? false) ? appt['doctor'].toString() : 'اسم غير محدد';
    final appointmentDate = (appt['appointmentDate']?.toString().isNotEmpty ?? false) ? appt['appointmentDate'].toString() : '';
    final startTime = (appt['startTimeInHours'] != null && appt['startTimeInHours'].toString().isNotEmpty)
        ? double.tryParse(appt['startTimeInHours'].toString()) ?? 0.0
        : 0.0;
    final endTime = (appt['endTimeInHours'] != null && appt['endTimeInHours'].toString().isNotEmpty)
        ? double.tryParse(appt['endTimeInHours'].toString()) ?? 0.0
        : 0.0;
    final status = (appt['status']?.toString().isNotEmpty ?? false) ? appt['status'].toString() : '--';
    final doctorImage = (appt['doctorImage'] != null && appt['doctorImage'].toString().isNotEmpty)
        ? appt['doctorImage'].toString()
        : 'lib/core/assets/images/download.jpg';

    String formatTime(double hour) {
      int h = hour.floor();
      int m = ((hour - h) * 60).round();
      String period = h >= 12 ? 'PM' : 'AM';
      int displayHour = h > 12 ? h - 12 : (h == 0 ? 12 : h);
      return '${displayHour.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')} $period';
    }

    String day = '--';
    String date = '--';
    if (appointmentDate.isNotEmpty) {
      final dt = DateTime.tryParse(appointmentDate);
      if (dt != null) {
        day = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'][dt.weekday % 7];
        date = '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';
      }
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.red, width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(width: 4),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      doctorName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      status,
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.red),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.calendar_today, size: 16, color: Colors.red),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          '$day, $date',
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 13,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.red),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.access_time, size: 16, color: Colors.red),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          '${formatTime(startTime)} - ${formatTime(endTime)}',
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 13,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
