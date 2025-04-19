class PatientEntity {
  final String id;
  final String name;
  final int age;
  final String gender;
  final String phoneNumber;
  final String address;
  final String? medicalHistory;
  final String? bloodType;
  final List<String>? allergies;
  final List<String>? chronicDiseases;
  //add medications
  PatientEntity({
    required this.id,
    required this.name,
    required this.age,
    required this.gender,
    required this.phoneNumber,
    required this.address,
    this.medicalHistory,
    this.bloodType,
    this.allergies,
    this.chronicDiseases,
  });

  // Factory method to create a Patient from a JSON object
  factory PatientEntity.fromJson(Map<String, dynamic> json) {
    return PatientEntity(
      id: json['id'],
      name: json['name'],
      age: json['age'],
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
    );
  }

  // Method to convert a Patient object to a JSON object
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'age': age,
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
