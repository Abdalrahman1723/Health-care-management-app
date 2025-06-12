class PatientEntity {
  final String id;
  final String name;
  final String email;
  final String? imageUrl;
  final DateTime dateOfBirth;
  final int age;
  final String gender;
  final String nationalID;
  final String? phoneNumber;
  final String? bloodType;
  final String? insuranceProvider;
  final String? chronicDiseases;
  final String? allergies;
  final String? currentMedications;

  PatientEntity({
    required this.id,
    required this.name,
    required this.email,
    this.imageUrl,
    required this.dateOfBirth,
    required this.gender,
    required this.nationalID,
    this.phoneNumber,
    this.bloodType,
    this.insuranceProvider,
    this.chronicDiseases,
    this.allergies,
    this.currentMedications,
  }) : age = DateTime.now().year - dateOfBirth.year;

  // Factory method to create a Patient from a JSON object
  factory PatientEntity.fromJson(Map<String, dynamic> json,
      {String? patientId}) {
    return PatientEntity(
      id: json['patientId'].toString(),
      name: json['personName'],
      email: json['email'],
      imageUrl: json['profilePicture'],
      dateOfBirth: DateTime.parse(json['dateOfBirth'].toString().split('T')[0]),
      gender: json['gender'],
      nationalID: json['nationalID'],
      phoneNumber: json['phone'],
      bloodType: json['bloodType'],
      insuranceProvider: json['insuranceProvider'],
      chronicDiseases: json['chronicDiseases'],
      allergies: json['allergies'],
      currentMedications: json['currentMedications'],
    );
  }

  // Method to convert a Patient object to a JSON object
  Map<String, dynamic> toJson() {
    return {
      'patientId': id,
      'personName': name,
      'profilePicture': imageUrl,
      'dateOfBirth': dateOfBirth.toIso8601String(),
      'gender': gender,
      'nationalID': nationalID,
      'bloodType': bloodType,
      'insuranceProvider': insuranceProvider,
      'chronicDiseases': chronicDiseases,
      'allergies': allergies,
      'currentMedications': currentMedications,
    };
  }
}
