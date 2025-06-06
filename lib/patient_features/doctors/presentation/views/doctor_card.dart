// lib/widgets/doctor_card.dart

import 'package:flutter/material.dart';
import '../../../appointment/presentation/widgets/doctors_appointment_widget.dart';
import '../../../info/preentation/views/doctors_profile.dart';
import '../../domain/entity.dart';

class DoctorCard extends StatefulWidget {
  final Entity doctor;
  final bool isFavorite;
  final VoidCallback onFavorite;

  const DoctorCard({
    required this.doctor,
    required this.isFavorite,
    required this.onFavorite,
  });

  @override
  _DoctorCardState createState() => _DoctorCardState();
}

class _DoctorCardState extends State<DoctorCard> {
  late bool _isFavorite;

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.isFavorite;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.only(left: 16.0, top: 16.0, bottom: 50.0, right: 30.0),
        child: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(widget.doctor.photo),
              radius: 50,
            ),
            const SizedBox(width: 16.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    widget.doctor.fullName,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0BDCDC),
                        fontSize: 18),
                  ),
                  Text(
                    widget.doctor.specialization,
                    style: const TextStyle(color: Colors.grey),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DoctorProfileScreen(
                                fullName: widget.doctor.fullName,
                                specialization: widget.doctor.specialization,
                                photoUrl: widget.doctor.photo,
                              ),
                            ),
                          );
                        },
                        child: const Text(
                          'Info',
                          style: TextStyle(
                            color: Color(0xFF0BDCDC),
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      IconButton(
                        icon: Icon(
                          _isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: _isFavorite ? const Color(0xFF0BDCDC) : Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            _isFavorite = !_isFavorite;
                          });
                          widget.onFavorite();
                        },
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DoctorsAppointmentWidget(
                            fullName: widget.doctor.fullName,
                            specialization: widget.doctor.specialization,
                            photoUrl: widget.doctor.photo,
                          ),
                        ),
                      );
                    },
                    child: const Text(
                      'Make Appointment',
                      style: TextStyle(
                        color: Color(0xFF0BDCDC),
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}