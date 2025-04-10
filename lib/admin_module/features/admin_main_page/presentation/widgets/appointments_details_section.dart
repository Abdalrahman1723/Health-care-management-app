import 'package:calendar_day_slot_navigator/calendar_day_slot_navigator.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../core/utils/get_weekday_name.dart';
import '../../../../core/utils/admin_app_colors.dart';

Widget appointmentDetailsSection({required BuildContext context}) {
  DateTime _selectedDate = DateTime.now();

  return Container(
    decoration: BoxDecoration(
      gradient: AdminAppColors.containerBackground,
    ),
    width: double.infinity,
    child: Column(
      //---------Header section
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("All Appointments",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(
                width: 20,
              ),
              //months button
              Text(
                "Months&Year",
                style: TextStyle(
                    // decoration: TextDecoration.underline,
                    color: Colors.white,
                    fontSize: 12),
              ),
            ],
          ),
        ),
        //------------ divider
        const Divider(
          color: Colors.white,
          thickness: 2,
          indent: 15,
          endIndent: 15,
        ),
        //------------ date picker section
        CalendarDaySlotNavigator(
          activeColor: Colors.orange,
          isGoogleFont: false,
          slotLength: 6,
          dayBoxHeightAspectRatio: 5,
          dayDisplayMode: DayDisplayMode.outsideDateBox,
          headerText: "Select Date",
          onDateSelect: (selectedDate) {
            _selectedDate = selectedDate;
            //?here should send the selected date to the backend
          },
        ),
        const SizedBox(
          height: 15,
        ),
        Container(
          width: 350,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white,
              width: 2,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  //---see all appointments button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange),
                    onPressed: () {
                      //todo navigate to all appointments screen
                      // Navigator.pushNamed(
                      //     context, Routes.allAppointments);
                      // Handle see all appointments button press
                    },
                    child: const Text(
                      "See all",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          decoration: TextDecoration.underline),
                    ),
                  ),
                ],
              ),
              const Divider(
                indent: 15,
                endIndent: 15,
                color: Colors.white,
                thickness: 1,
              ),
              //------------ appointment information

              //appointment 1 example

              InkWell(
                onTap: () {
                  // Navigator.pushNamed(
                  //     context, Routes.appointmentDetailsScreen);
                },
                child: appointmentDetails(
                    doctorName: 'Ahmed Essam',
                    patientName: "Hossam Ali",
                    selectedDate: _selectedDate,
                    context: context),
              ),

              //appointment 2
              const Divider(
                indent: 15,
                endIndent: 15,
                color: Colors.white,
                thickness: 1,
              ),
              InkWell(
                onTap: () {
                  // Navigator.pushNamed(context, Routes.appointmentDetailsScreen),
                },
                child: appointmentDetails(
                    doctorName: 'Helana Emad',
                    patientName: "Mohamed Yasser",
                    selectedDate: _selectedDate,
                    context: context),
              ),
            ],
          ),
        ),
        //the end of the information section
        const SizedBox(
          height: 15,
        ),
      ],
    ),
  );
}

//-----------------------------------
Widget appointmentDetails(
    {required String doctorName,
    required String patientName,
    required DateTime selectedDate,
    required BuildContext context}) {
  return Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          //------weekday
          Text(
            getWeekdayName(selectedDate.weekday),
            style: Theme.of(context).textTheme.titleMedium,
          ),
          //------date
          Text(
            DateFormat('dd/MMM/yyyy').format(selectedDate),
          ),
          //------time
          const Text('8:00 AM'), //later we will change this to a dynamic value
        ],
      ),
      const SizedBox(height: 8),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          //---Doctor's name
          Text(
            "Dr. $doctorName",
          ),
          //---patient's name
          Text(patientName)
        ],
      ),
    ],
  );
}
