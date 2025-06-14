import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UpcomingAppointmentsScreen extends StatefulWidget {
  const UpcomingAppointmentsScreen({Key? key}) : super(key: key);

  @override
  State<UpcomingAppointmentsScreen> createState() => _UpcomingAppointmentsScreenState();
}

class _UpcomingAppointmentsScreenState extends State<UpcomingAppointmentsScreen> {
  List<dynamic> _appointments = [];
  bool _isLoading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    fetchUpcomingAppointments();
  }

  Future<void> fetchUpcomingAppointments() async {
    setState(() => _isLoading = true);
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      if (token == null) throw Exception('Missing token');

      final url = 'https://healthcaresystem.runasp.net/api/Patient/appointments?status=Upcoming';
      final response = await Dio().get(
        url,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      setState(() {
        _appointments = response.data is List ? response.data : [];
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _appointments = [];
        _isLoading = false;
      });
    }
  }

  Future<void> _cancelAppointmentApi(int appointmentId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null) return;

    try {
      final url = 'https://healthcaresystem.runasp.net/api/Patient/cancel/$appointmentId';
      await Dio().put(
        url,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Appointment cancelled successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
      setState(() {
        _appointments.removeWhere((a) => a['appointmentId'] == appointmentId);
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error cancelling appointment: \n${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showCancelConfirmationDialog(int appointmentId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Cancel Confirmation'),
          content: const Text('Are you sure you want to cancel this appointment?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _cancelAppointmentApi(appointmentId);
              },
              child: const Text('Yes', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _appointments.isEmpty
            ? Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.event_busy, color: Colors.grey, size: 64),
              SizedBox(height: 16),
              Text('No upcoming appointments', style: TextStyle(fontSize: 20, color: Colors.grey)),
            ],
          ),
        )
            : ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: _appointments.length,
          itemBuilder: (context, index) {
            final appt = _appointments[index];
            return Column(
              children: [
                _buildAppointmentCard(appt),
                const SizedBox(height: 16),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildAppointmentCard(dynamic appt) {
    final doctorName = (appt['doctor']?.toString().isNotEmpty ?? false) ? appt['doctor'].toString() : 'Unknown Doctor';
    final appointmentDate = (appt['appointmentDate']?.toString().isNotEmpty ?? false) ? appt['appointmentDate'].toString() : '';
    final availableDate = (appt['availableDate']?.toString().isNotEmpty ?? false) ? appt['availableDate'].toString() : '';
    final startTime = (appt['startTimeInHours'] != null && appt['startTimeInHours'].toString().isNotEmpty)
        ? double.tryParse(appt['startTimeInHours'].toString()) ?? 0.0
        : 0.0;
    final endTime = (appt['endTimeInHours'] != null && appt['endTimeInHours'].toString().isNotEmpty)
        ? double.tryParse(appt['endTimeInHours'].toString()) ?? 0.0
        : 0.0;
    final status = (appt['status']?.toString().isNotEmpty ?? false) ? appt['status'].toString() : '--';

    String formatTime(double hour) {
      int h = hour.floor();
      int m = ((hour - h) * 60).round();
      String period = h >= 12 ? 'PM' : 'AM';
      int displayHour = h > 12 ? h - 12 : (h == 0 ? 12 : h);
      return '${displayHour.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')} $period';
    }

    String day = '';
    String date = '';
    if (appt['day'] != null && appt['day'].toString().isNotEmpty) {
      day = appt['day'].toString();
    }
    if (appointmentDate.isNotEmpty) {
      final dt = DateTime.tryParse(appointmentDate);
      if (dt != null) {
        date = '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';
        if (day.isEmpty) {
          day = [
            'Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'
          ][dt.weekday % 7];
        }
      }
    }

    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(18),
          margin: const EdgeInsets.only(top: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.10),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
            border: Border.all(color: const Color(0xFF0BDCDC), width: 1.2),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          doctorName,
                          style: const TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0BDCDC),
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
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
                          maxLines: 1,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // صندوق التاريخ
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFF0BDCDC)),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.calendar_today, size: 16, color: Color(0xFF0BDCDC)),
                        const SizedBox(width: 4),
                        Text(
                          day.isNotEmpty && date.isNotEmpty ? '$day, $date' : date,
                          style: const TextStyle(
                            color: Color(0xFF0BDCDC),
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                          softWrap: false,
                          maxLines: 1,
                        ),
                        if (availableDate.isNotEmpty) ...[
                          const SizedBox(width: 6),
                          Text(
                            availableDate,
                            style: const TextStyle(
                              color: Color(0xFF0BDCDC),
                              fontSize: 13,
                              fontStyle: FontStyle.italic,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  // صندوق الوقت
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFF0BDCDC)),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.access_time, size: 16, color: Color(0xFF0BDCDC)),
                        const SizedBox(width: 4),
                        Text(
                          '${formatTime(startTime)} - ${formatTime(endTime)}',
                          style: const TextStyle(
                            color: Color(0xFF0BDCDC),
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                          softWrap: false,
                          maxLines: 1,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
            ],
          ),
        ),
        // أيقونة الإلغاء في الأعلى يمين
        Positioned(
          top: 0,
          right: 0,
          child: IconButton(
            icon: const Icon(Icons.cancel, color: Colors.red, size: 32),
            onPressed: () {
              _showCancelConfirmationDialog(appt['appointmentId'] ?? 0);
            },
            tooltip: 'Cancel',
          ),
        ),
      ],
    );
  }}