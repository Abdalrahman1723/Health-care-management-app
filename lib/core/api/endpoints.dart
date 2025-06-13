// core/network/api_constants.dart
class PatientApiConstants {
  static const String baseUrl = 'https://healthcaresystem.runasp.net/api/';

  // Auth endpoints
  static const String login = 'auth/login';
  static const String register = 'auth/register';

  //get doctors
  static const String getDoctorById = "Patient/";
  static const String getAllDoctors = "Patient/GetAllDoctor";

  //patient profile endpoints
  static const String getPatientById = "PatientProfile/"; // PatientProfile/{id}
  static const String updatePatientProfile =
      "PatientProfile/"; // PatientProfile/{id}

  //appointments endpoint
  static const String getAllAppointments = "Patient/appointments";

  static String getDoctorAppointmentsWithId(String doctorId) {
    return "Patient/doctor/$doctorId/appointments";
  }

  //notifications
  static const String getNotifications =
      "Notification/patient"; //Notification/patient/{ID}

  //add review
  static const String addReview =
      "Notification/patient"; //Notification/patient/{ID}

  static const String markAllNotificationsAsRead =
      '$baseUrl/notifications/mark-all-read';

    //favorite doctors
      static const String getFavoriteDoctors =
      "favorites/"; //Notification/patient/{ID}
}

//-----admin------//
class AdminApiConstants {
  static const String baseUrl = 'https://healthcaresystem.runasp.net/api/';

  //get all doctors api
  static const String getAllDoctors = "Admin/doctors";

  //create doctor api
  static const String createDoctor = "Admin/doctors";

  //update doctor api
  static const String updateDoctor =
      "Admin/doctors/update"; //Admin/doctors/update/{ID}

  //update doctor api
  static const String deleteDoctor =
      "Admin/doctors/delete"; //Admin/doctors/delete/{ID}

  //update doctor api
  static const String fetchAdminStats = "Admin/stats"; //Admin/stats
}
