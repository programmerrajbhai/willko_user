class AddressModel {
  String id;
  String type;        // "Home", "Office", "Other"
  String fullName;    // Customer Name
  String phone;       // Contact Number
  String addressLine; // Combined Address (Flat, Bldg, Location)
  String city;
  String zip;
  String address;     // Full address string (backup field)
  bool isSelected;

  AddressModel({
    required this.id,
    required this.type,
    required this.fullName,
    required this.phone,
    required this.addressLine,
    required this.city,
    required this.zip,
    required this.address,
    this.isSelected = false,
  });
}