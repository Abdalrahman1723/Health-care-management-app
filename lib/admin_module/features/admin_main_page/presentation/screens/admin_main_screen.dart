import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:health_care_app/admin_module/core/utils/admin_app_bar.dart';
import 'package:health_care_app/admin_module/features/admin_main_page/presentation/screens/admin_appointments_screen.dart';
import 'package:health_care_app/core/utils/app_icons.dart';

class AdminMainScreen extends StatefulWidget {
  const AdminMainScreen({super.key});

  @override
  State<AdminMainScreen> createState() => _AdminMainScreenState();
}

class _AdminMainScreenState extends State<AdminMainScreen> {
  int _selectedIndex = 0;

  // List of pages corresponding to each tab
  static final List<Widget> _pages = <Widget>[
    const AdminAppointmentsScreen(),
  ];

  // Function to handle tab change
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: adminAppBar(context: context, title: "Admin Dashboard"),
      //---------
      body: _pages[_selectedIndex],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped, // Callback when tab is tapped
        items: <BottomNavigationBarItem>[
          //----------appointments tab
          const BottomNavigationBarItem(
            icon: Icon(Icons.date_range_outlined),
            label: 'appointments',
          ),
          //----------doctors tab
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              AppIcons.generalMedicine,
              color: Colors.black,
              height: 40,
              width: 40,
            ),
            label: 'doctors',
          ),
        ],
      ),
      // SafeArea(
      //   child: SingleChildScrollView(
      //     child: Column(
      //       mainAxisAlignment: MainAxisAlignment.start,
      //       crossAxisAlignment: CrossAxisAlignment.center,
      //       children: [
      //         //----------appointment details section
      //         appointmentDetailsSection(context: context),
      //         const SizedBox(
      //           height: 4,
      //         ),
      //         doctorDetailsSection(context: context),
      //       ],
      //     ),
      //   ),
      // ),
    );
  }
}
