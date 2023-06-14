class StallModel {
  String name;
  String address;
  String openingHours;
  String profilePic;
  String phoneNumber;
  String stallId;

  StallModel({
    required this.name,
    required this.address,
    required this.openingHours,
    required this.profilePic,
    required this.phoneNumber,
    required this.stallId,
  });

  // from map
  factory StallModel.fromJSON(Map<String, dynamic> map) {
    return StallModel(
      name: map['name'] ?? '',
      address: map['address'] ?? '',
      openingHours: map['openingHours'] ?? '',
      stallId: map['stallId'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      profilePic: map['profilePic'] ?? '',
    );
  }

  // to map
  Map<String, dynamic> toJSON() {
    return {
      "name": name,
      "address": address,
      "stallId": stallId,
      "openingHours": openingHours,
      "profilePic": profilePic,
      "phoneNumber": phoneNumber,
    };
  }
}
