class AddStallModel {
  final String name;
  final String address;
  final String unitNumber;
  final String postalCode;
  final String openingHours;
  final String phoneNumber;
  final String bio;
  final List<String> stallImages;

  AddStallModel({
    required this.name,
    required this.address,
    required this.unitNumber,
    required this.postalCode,
    required this.openingHours,
    required this.phoneNumber,
    required this.bio,
    required this.stallImages,
  });

  // from map
  factory AddStallModel.fromJSON(Map<String, dynamic> map) {
    return AddStallModel(
      name: map['name'] ?? '',
      address: map['address'] ?? '',
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
      "address": address,
      "unitNumber": unitNumber,
      "postalCode": postalCode,
      "openingHours": openingHours,
      "bio": bio,
      "phoneNumber": phoneNumber,
      "stall images": stallImages,
    };
  }
}
