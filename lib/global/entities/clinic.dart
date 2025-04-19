class ClinicEntity {
  final String id;
  final String name;
  final String address;
  final String phoneNumber;
  final String doctorId;

  ClinicEntity({
    required this.id,
    required this.name,
    required this.address,
    required this.phoneNumber,
    required this.doctorId,
  });

  // Factory method to create a Clinic from a JSON object
  factory ClinicEntity.fromJson(Map<String, dynamic> json) {
    return ClinicEntity(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      phoneNumber: json['phoneNumber'],
      doctorId: json['doctorId'],
    );
  }

  // Method to convert a Clinic object to a JSON object
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'phoneNumber': phoneNumber,
      'doctorId': doctorId,
    };
  }
}
