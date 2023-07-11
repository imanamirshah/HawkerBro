class FetchStallModel {
  final String name;
  final String address;
  final String unitNumber;
  final String postalCode;
  final String openingHours;
  final String phoneNumber;
  final String bio;
  final List<int> ratings;
  final List<String> reviews;
  final List<String> reviewers;
  final List<String> stallImages;

  FetchStallModel({
    required this.name,
    required this.address,
    required this.unitNumber,
    required this.postalCode,
    required this.openingHours,
    required this.phoneNumber,
    required this.bio,
    required this.ratings,
    required this.reviews,
    required this.reviewers,
    required this.stallImages,
  });

  // from map
  factory FetchStallModel.fromJSON(Map<String, dynamic> map) {
    return FetchStallModel(
      name: map['name'] ?? '',
      address: map['address'] ?? '',
      unitNumber: map['unitNumber'] ?? '',
      postalCode: map['postalCode'] ?? '',
      openingHours: map['openingHours'] ?? '',
      bio: map['bio'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      ratings: List<int>.from(map['ratings'] ?? []),
      reviews: List<String>.from(map['reviews'] ?? []),
      reviewers: List<String>.from(map['reviewers'] ?? []),
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
      "ratings": ratings,
      "reviews": reviews,
      "reviewers": reviewers,
      "stall images": stallImages,
    };
  }
}
