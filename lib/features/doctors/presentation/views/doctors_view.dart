import 'package:flutter/material.dart';
import '../../../appointment/presentation/widgets/doctors_appointment_widget.dart';
import '../../../fav_doctors/presentation/views/fav_doctors_view.dart';
import '../../../info/preentation/widget/doctors_profile_widget.dart';

class DoctorsView extends StatefulWidget {
  const DoctorsView({super.key});

  @override
  _DoctorsViewState createState() => _DoctorsViewState();
}

class _DoctorsViewState extends State<DoctorsView> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  final List<Doctor> _doctors = const [
    Doctor(
        name: 'Dr. Daniel Rodriguez',
        specialty: 'Interventional Cardiologist',
        imageUrl: 'lib/core/assets/images/download.jpg'),
    Doctor(
        name: 'Dr. Jessica Ramirez',
        specialty: 'Electrophysiologist',
        imageUrl: 'lib/core/assets/images/download.jpg'),
    Doctor(
        name: 'Dr. Michael Chang',
        specialty: 'Cardiac Imaging Specialist',
        imageUrl: 'lib/core/assets/images/download.jpg'),
    Doctor(
        name: 'Dr. Michael Davidson, M.D.',
        specialty: 'Cardiologist',
        imageUrl: 'lib/core/assets/images/download.jpg'),
  ];

  List<Doctor> favoriteDoctors = []; // List of favorite doctors

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Doctor> filteredDoctors = _doctors.where((doctor) {
      return doctor.name.toLowerCase().contains(_searchQuery) ||
          doctor.specialty.toLowerCase().contains(_searchQuery);
    }).toList();

    return Theme(
      data: ThemeData(),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search...',
                hintStyle:
                    const TextStyle(color: Color(0xFF0BDCDC), fontSize: 17),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0)),
                filled: true,
                fillColor: Colors.white,
                prefixIcon: const Icon(Icons.search, color: Color(0xFF0BDCDC)),
              ),
              style: const TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: ListView.builder(
                itemCount: filteredDoctors.length,
                itemBuilder: (context, index) {
                  final doctor = filteredDoctors[index];
                  return DoctorCard(
                    doctor: doctor,
                    isFavorite: favoriteDoctors.contains(doctor),
                    onFavorite: () {
                      setState(() {
                        if (favoriteDoctors.contains(doctor)) {
                          favoriteDoctors
                              .remove(doctor); // Remove from favorites
                        } else {
                          favoriteDoctors.add(doctor); // Add to favorites
                        }
                      });
                    },
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Navigate to the Favorite Doctors screen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        FavDoctors(favoriteDoctors: favoriteDoctors),
                  ),
                );
              },
              child: const Text('Go to Favorite Doctors'),
            ),
          ],
        ),
      ),
    );
  }
}

class Doctor {
  final String name;
  final String specialty;
  final String imageUrl;

  const Doctor(
      {required this.name, required this.specialty, required this.imageUrl});
}

class DoctorCard extends StatefulWidget {
  final Doctor doctor;
  final bool isFavorite;
  final VoidCallback onFavorite;

  // ignore: use_key_in_widget_constructors
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
    _isFavorite = widget.isFavorite; // Initialize the favorite status
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.only(
            left: 16.0, top: 16.0, bottom: 50.0, right: 30.0),
        child: Row(
          children: [
            CircleAvatar(
              backgroundImage: AssetImage(widget.doctor.imageUrl),
              radius: 50,
            ),
            const SizedBox(width: 16.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    widget.doctor.name,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0BDCDC),
                        fontSize: 18),
                  ),
                  Text(
                    widget.doctor.specialty,
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
                              builder: (context) =>
                              DoctorsProfileWidget(),
                            ),
                          );
                        },
                        child: const Text(
                          'Info',
                          style: TextStyle(
                              color: Color(0xFF0BDCDC),
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          _isFavorite
                              ? Icons.favorite
                              : Icons.favorite_border, // Toggle heart icon
                          color: _isFavorite
                              ? const Color(0xFF0BDCDC)
                              : Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            _isFavorite =
                                !_isFavorite; // Toggle the favorite status
                          });
                          widget
                              .onFavorite(); // Call the parent callback to update the favorites list
                        },
                      ),
                    ],
                  ),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                              const DoctorsAppointmentWidget()));},
                      child: const Text(
                        'Make Appointment',
                        style: TextStyle(
                            color: Color(0xFF0BDCDC),
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      ))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
