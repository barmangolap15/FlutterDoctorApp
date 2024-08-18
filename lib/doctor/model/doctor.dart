class Doctor {
  final String uid;
  final String category;
  final String city;
  final String email;
  final String firstName;
  final String lastName;
  final String profileImageUrl;
  final String qualification;
  final String phoneNumber;
  final String yearsOfExperience;
  final double latitude;
  final double longitude;
  final int numberOfReviews;
  final int totalReviews;

  Doctor({
    required this.uid,
    required this.category,
    required this.city,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.profileImageUrl,
    required this.qualification,
    required this.phoneNumber,
    required this.yearsOfExperience,
    required this.latitude,
    required this.longitude,
    required this.numberOfReviews,
    required this.totalReviews,
  });

  factory Doctor.fromMap(Map<dynamic, dynamic> map, String uid) {
    return Doctor(
      uid: uid,
      category: map['category'],
      city: map['city'],
      email: map['email'],
      firstName: map['firstName'],
      lastName: map['lastName'],
      profileImageUrl: map['profileImageUrl'],
      qualification: map['qualification'],
      phoneNumber: map['phoneNumber'],
      yearsOfExperience: map['yearsOfExperience'],
      latitude: map['latitude'],
      longitude: map['longitude'],
      numberOfReviews: map['numberOfReviews'],
      totalReviews: map['totalReviews'],
    );
  }
}
