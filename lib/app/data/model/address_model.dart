class AddressModel {
  String id;
  String type; // "Home", "Office", "Other"
  String address;
  String phone;
  bool isSelected;

  AddressModel({
    required this.id,
    required this.type,
    required this.address,
    required this.phone,
    this.isSelected = false,
  });
}