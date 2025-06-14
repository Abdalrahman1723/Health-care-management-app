import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:health_care_app/admin_module/core/utils/admin_app_bar.dart';
import 'package:health_care_app/admin_module/features/admin_main_page/presentation/screens/admin_stats_screen.dart';
import 'package:health_care_app/admin_module/features/admin_main_page/presentation/screens/admin_doctors_screen.dart';
import 'package:health_care_app/core/utils/app_icons.dart';
import 'package:health_care_app/config/routes/routes.dart';

import '../cubit/admin_main_page_cubit.dart';

class AdminMainScreen extends StatefulWidget {
  const AdminMainScreen({super.key});

  @override
  State<AdminMainScreen> createState() => _AdminMainScreenState();
}

class _AdminMainScreenState extends State<AdminMainScreen> {
  int _selectedIndex = 0;

  // List of pages corresponding to each tab
  static final List<Widget> _pages = <Widget>[
    const AdminStatsScreen(),
    const AdminDoctorsScreen(),
  ];

  // Function to handle tab change
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _onRefresh() async {
    // Trigger a rebuild of the current page
    context.read<AdminMainPageCubit>().fetchAllFeedback();
    context.read<AdminMainPageCubit>().fetchDoctors();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: adminAppBar(context: context, title: "Admin Dashboard"),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: _pages[_selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: <BottomNavigationBarItem>[
          //----------appointments tab
          const BottomNavigationBarItem(
            icon: Icon(Icons.date_range_outlined),
            label: 'appointments',
          ),
          //----------doctors tab
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              color: Colors.black87,
              AppIcons.generalMedicine,
              height: 40,
              width: 40,
            ),
            label: 'doctors',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, Routes.adminAddDoctorScreen);
        },
        tooltip: "add new doctor",
        child: const Icon(Icons.add),
      ),
    );
  }
}
