class StallModel {
  final String name;
  final String unitNumber;
  final String postalCode;
  final String openingHours;
  final String phoneNumber;
  final String bio;
  final List<String> stallImages;

  StallModel({
    required this.name,
    required this.unitNumber,
    required this.postalCode,
    required this.openingHours,
    required this.phoneNumber,
    required this.bio,
    required this.stallImages,
  });

  // from map
  factory StallModel.fromJSON(Map<String, dynamic> map) {
    return StallModel(
      name: map['name'] ?? '',
      unitNumber: map['unitNumber'] ?? '',
      postalCode: map['postalCode'] ?? '',
      openingHours: map['openingHours'] ?? '',
      bio: map['bio'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      stallImages: List<String>.from(map['stall images'] ?? []),
    );
  }

  // to map
  Map<String, dynamic> toJSON() {
    return {
      "name": name,
      "unitNumber": unitNumber,
      "postalCode": postalCode,
      "openingHours": openingHours,
      "bio": bio,
      "phoneNumber": phoneNumber,
      "stall images": stallImages,
    };
  }
}
