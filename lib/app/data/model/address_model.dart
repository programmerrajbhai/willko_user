class AddressModel {
  String id;
  String type; // Home, Office, Other
  String fullName;
  String phone;
  String addressLine;
  bool isSelected;

  AddressModel({
    required this.id,
    required this.type,
    required this.fullName,
    required this.phone,
    required this.addressLine,
    this.isSelected = false,
  });

  // JSON থেকে ডাটা রিড করার জন্য (ক্যাশ মেমোরি থেকে)
  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      id: json['id'] ?? '',
      type: json['type'] ?? 'Home',
      fullName: json['fullName'] ?? '',
      phone: json['phone'] ?? '',
      addressLine: json['addressLine'] ?? '',
      isSelected: json['isSelected'] ?? false,
    );
  }

  // JSON এ ডাটা রাইট করার জন্য (ক্যাশ মেমোরিতে সেভ করার জন্য)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'fullName': fullName,
      'phone': phone,
      'addressLine': addressLine,
      'isSelected': isSelected,
    };
  }
}