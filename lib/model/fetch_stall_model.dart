class FetchStallModel {
  final String name;
  final String unitNumber;
  final String postalCode;
  final String openingHours;
  final String phoneNumber;
  final String bio;
  final List<int> ratings;
  final List<String> reviews;
  final List<String> stallImages;

  FetchStallModel({
    required this.name,
    required this.unitNumber,
    required this.postalCode,
    required this.openingHours,
    required this.phoneNumber,
    required this.bio,
    required this.ratings,
    required this.reviews,
    required this.stallImages,
  });

  // from map
  factory FetchStallModel.fromJSON(Map<String, dynamic> map) {
    return FetchStallModel(
      name: map['name'] ?? '',
      unitNumber: map['unitNumber'] ?? '',
      postalCode: map['postalCode'] ?? '',
      openingHours: map['openingHours'] ?? '',
      bio: map['bio'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      ratings: List<int>.from(map['ratings'] ?? []),
      reviews: List<String>.from(map['reviews'] ?? []),
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
      "ratings": ratings,
      "reviews": reviews,
      "stall images": stallImages,
    };
  }
}
