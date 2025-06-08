// core/network/api_constants.dart
class ApiConstants {
  static const String baseUrl = 'https://healthcaresystem.runasp.net';

  // Auth endpoints
  static const String login = '/api/auth/login';
  static const String register = '/api/auth/register';

  //get doctor by ID
  static const String getDoctorById = "api/Patient/";

  //patient profile endpoints
  static const String getPatientById =
      "api/PatientProfile/"; // api/PatientProfile/{id}
}
