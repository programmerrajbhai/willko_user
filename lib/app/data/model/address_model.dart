class AddressModel {
  String id;
  String type; // Home, Office, Other
  String fullName;
  String phone;
  String addressLine;
  String city;
  String zip;
  bool isSelected;

  AddressModel({
    required this.id,
    required this.type,
    required this.fullName,
    required this.phone,
    required this.addressLine,
    this.city = "Dhaka",
    this.zip = "0000",
    this.isSelected = false,
  });

  // JSON থেকে অবজেক্ট তৈরি (Load করার সময় লাগবে)
  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      id: json['id'],
      type: json['type'],
      fullName: json['fullName'],
      phone: json['phone'],
      addressLine: json['addressLine'],
      city: json['city'] ?? "Dhaka",
      zip: json['zip'] ?? "0000",
      isSelected: json['isSelected'] ?? false,
    );
  }

  // অবজেক্ট থেকে JSON তৈরি (Save করার সময় লাগবে)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'fullName': fullName,
      'phone': phone,
      'addressLine': addressLine,
      'city': city,
      'zip': zip,
      'isSelected': isSelected,
    };
  }
}