class PatientEntity {
  final String id;
  final String name;
  final String? imageUrl;
  final DateTime dateOfBirth;
  final int age;
  final String gender;
  final String phoneNumber;
  final String address;
  //the patient's own medical history
  final String? medicalHistory;
  final String? bloodType;
  final List<String>? allergies;
  final List<String>? chronicDiseases;
  final List<String>? medications;

  PatientEntity({
    required this.id,
    required this.name,
    this.imageUrl,
    required this.dateOfBirth,
    required this.gender,
    required this.phoneNumber,
    required this.address,
    this.medicalHistory,
    this.bloodType,
    this.allergies,
    this.chronicDiseases,
    this.medications,
  }) : age = DateTime.now().year - dateOfBirth.year;

  // Factory method to create a Patient from a JSON object
  factory PatientEntity.fromJson(Map<String, dynamic> json) {
    return PatientEntity(
      id: json['id'],
      name: json['name'],
      dateOfBirth: DateTime.parse(json['dateOfBirth']),
      gender: json['gender'],
      phoneNumber: json['phoneNumber'],
      address: json['address'],
      medicalHistory: json['medicalHistory'],
      bloodType: json['bloodType'],
      allergies: (json['allergies'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      chronicDiseases: (json['chronicDiseases'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      medications: (json['medications'] as List<String>?),
    );
  }

  // Method to convert a Patient object to a JSON object
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
      'dateOfBirth': dateOfBirth.toIso8601String(),
      'gender': gender,
      'phoneNumber': phoneNumber,
      'address': address,
      'medicalHistory': medicalHistory,
      'bloodType': bloodType,
      'allergies': allergies,
      'chronicDiseases': chronicDiseases,
    };
  }
}
