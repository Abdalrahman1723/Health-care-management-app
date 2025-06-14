import 'package:flutter/material.dart';

import '../../../doctors/domain/entities/doctor_entity.dart';
import '../../../doctors/presentation/views/doctor_card.dart';



class FavDoctors extends StatefulWidget {
  final List<DoctorEntity> favoriteDoctors;
  final void Function(List<DoctorEntity>)? onFavChanged;

  const FavDoctors({Key? key, required this.favoriteDoctors, this.onFavChanged}) : super(key: key);

  @override
  State<FavDoctors> createState() => _FavDoctorsState();
}

class _FavDoctorsState extends State<FavDoctors> {
  late List<DoctorEntity> favDoctors;

  @override
  void initState() {
    super.initState();
    favDoctors = List.from(widget.favoriteDoctors); // clone list so we can modify locally
  }

  void _toggleFavorite(DoctorEntity doctor) {
    setState(() {
      favDoctors.removeWhere((d) => d.fullName == doctor.fullName);
      widget.onFavChanged?.call(favDoctors);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Favorite Doctors", style: TextStyle(color: Colors.white,fontSize: 25)), backgroundColor: const Color(0xFF0BDCDC)),
      body: ListView.builder(
        itemCount: favDoctors.length,
        itemBuilder: (context, index) {
          final doctor = favDoctors[index];
          return DoctorCard(
            doctor: doctor,
            isFavorite: true,  // هنا القلب ظاهر ومفعل (لكن يمكن تختاري تبطلي الزر مثلا)
            onFavorite: () => _toggleFavorite(doctor), // ازالة من المفضلة
            onInfo: () {
              // تصفح معلومات الدكتور
            },
          );
        },
      ),
    );
  }

}
