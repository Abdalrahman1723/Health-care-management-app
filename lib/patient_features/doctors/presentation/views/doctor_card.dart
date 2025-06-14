
import 'package:flutter/material.dart';

import '../../../appointment/presentation/views/doctors_appointment_view.dart';
import '../../domain/entities/doctor_entity.dart';

class DoctorCard extends StatefulWidget {
  final DoctorEntity doctor;
  final bool isFavorite;
  final VoidCallback onFavorite;
  final VoidCallback onInfo;
  final bool hideFavoriteIcon; // جديد: لو true نخفي القلب

  const DoctorCard({
    required this.doctor,
    required this.isFavorite,
    required this.onFavorite,
    required this.onInfo,
    this.hideFavoriteIcon = false, // افتراضي false
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
  void didUpdateWidget(covariant DoctorCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isFavorite != widget.isFavorite) {
      _isFavorite = widget.isFavorite;  // مزامنة الحالة مع القيمة الجديدة
    }
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
              backgroundImage: NetworkImage(widget.doctor.photoUrl),
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
                        fontSize: 20),
                  ),
                  Text(
                    widget.doctor.specialization,
                    style: const TextStyle(color: Colors.grey,fontSize: 18),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        onPressed: widget.onInfo,
                        child: const Text(
                          'Info',
                          style: TextStyle(
                            color: Color(0xFF0BDCDC),
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      if (!widget.hideFavoriteIcon)  // لو مش مخفي، اعرض الايقونة
                        IconButton(
                          icon: Icon(
                            size: 25,
                            _isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: _isFavorite ? Colors.red : Colors.grey,
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

                  const SizedBox(height: 15,),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DoctorsAppointment(
                            doctorName: widget.doctor.fullName,
                            specialty: widget.doctor.specialization,
                            doctorImage: widget.doctor.photoUrl, doctorId: widget.doctor.id,
                          ),
                        ),
                      );

                    },
                    child: const Text(
                      'Make Appointment',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF0BDCDC),
                        fontSize: 20,
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
