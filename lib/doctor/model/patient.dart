class Patient {
  final String city;
  final String email;
  final String firstName;
  final String lastName;
  final double latitude;
  final double longitude;
  final String phoneNumber;
  final String profileImageUrl;
  final String uid;

  Patient({
    required this.city,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.latitude,
    required this.longitude,
    required this.phoneNumber,
    required this.profileImageUrl,
    required this.uid,
  });

  factory Patient.fromMap(Map<String, dynamic> data) {
    return Patient(
      city: data['city'] ?? '',
      email: data['email'] ?? '',
      firstName: data['firstName'] ?? '',
      lastName: data['lastName'] ?? '',
      latitude: data['latitude']?.toDouble() ?? 0.0,
      longitude: data['longitude']?.toDouble() ?? 0.0,
      phoneNumber: data['phoneNumber'] ?? '',
      profileImageUrl: data['profileImageUrl'] ?? '',
      uid: data['uid'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'city': city,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'latitude': latitude,
      'longitude': longitude,
      'phoneNumber': phoneNumber,
      'profileImageUrl': profileImageUrl,
      'uid': uid,
    };
  }
}
