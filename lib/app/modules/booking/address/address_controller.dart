import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../data/model/address_model.dart';
import 'add_address_view.dart';

class AddressController extends GetxController {
  // --- UI State ---
  final addressList = <AddressModel>[].obs;
  final isLoading = true.obs;
  final isMapLoading = false.obs;
  final isSaving = false.obs;

  // --- Form Controllers ---
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // ✅ নতুন ৫টি ফিল্ডের কন্ট্রোলার
  late final TextEditingController nameController;       // Customer Name
  late final TextEditingController phoneController;      // Contact Number
  late final TextEditingController locationNameController; // Location Name
  late final TextEditingController buildingController;   // Building Number
  late final TextEditingController flatController;       // Flat Number

  final selectedType = "Home".obs; // Address Type

  @override
  void onInit() {
    super.onInit();
    // কন্ট্রোলার ইনিশিয়ালাইজেশন
    nameController = TextEditingController();
    phoneController = TextEditingController();
    locationNameController = TextEditingController();
    buildingController = TextEditingController();
    flatController = TextEditingController();

    loadAddresses();
  }

  // --- Dummy Data ---
  Future<void> loadAddresses() async {
    isLoading.value = true;
    await Future.delayed(const Duration(milliseconds: 500));
    
    // কিছু ডামি ডাটা লোড করা হচ্ছে
    addressList.assignAll([
      AddressModel(
        id: "1",
        type: "Home",
        fullName: "Raj Ahmad",
        phone: "01710000000",
        addressLine: "Flat: 4B, Bldg: 12, Road 5, Dhanmondi", 
        city: "Dhaka",
        zip: "1209",
        isSelected: true, address: '',
      ),
    ]);

    isLoading.value = false;
  }

  // --- GPS Autofill (Simulated) ---
  Future<void> useCurrentLocation() async {
    HapticFeedback.mediumImpact();
    isMapLoading.value = true;

    Get.snackbar(
      "Locating...",
      "Fetching location details...",
      showProgressIndicator: true,
      backgroundColor: Colors.black87,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(20),
      borderRadius: 12,
    );

    await Future.delayed(const Duration(seconds: 2));

    // ডেমো লোকেশন সেট করা
    locationNameController.text = "Road 11, Banani, Dhaka";
    buildingController.text = "56"; // GPS সাধারণত ফ্ল্যাট নম্বর পায় না
    
    isMapLoading.value = false;
    HapticFeedback.heavyImpact();
  }

  // --- Save Logic ---
  Future<void> saveAddress() async {
    HapticFeedback.lightImpact();

    final valid = formKey.currentState?.validate() ?? false;
    if (!valid) {
      Get.snackbar(
        "Missing Info",
        "Please fill all required fields",
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
      return;
    }

    isSaving.value = true;
    await Future.delayed(const Duration(milliseconds: 700));

    // ✅ সব তথ্য মিলিয়ে একটি স্ট্রিং বানানো হচ্ছে
    // Format: Flat: [Flat], Bldg: [Building], [Location]
    String fullAddress = "";
    if (flatController.text.isNotEmpty) fullAddress += "Flat: ${flatController.text.trim()}, ";
    if (buildingController.text.isNotEmpty) fullAddress += "Bldg: ${buildingController.text.trim()}, ";
    fullAddress += locationNameController.text.trim();

    final newAddress = AddressModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: selectedType.value,
      fullName: nameController.text.trim(), // Customer Name
      phone: phoneController.text.trim(),    // Contact Number
      addressLine: fullAddress,              // Combined Address
      city: "Dhaka", 
      zip: "0000",
      isSelected: true, address: '',
    );

    // অন্যগুলো ডিসিলেক্ট করা
    for (final item in addressList) {
      item.isSelected = false;
    }
    addressList.insert(0, newAddress);

    isSaving.value = false;
    Get.back(); // আগের পেজে ফিরে যাওয়া

    Get.snackbar(
      "Success",
      "Address saved successfully!",
      backgroundColor: Colors.green.shade700,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(20),
      borderRadius: 12,
    );

    _clearForm();
  }

  void changeType(String type) {
    HapticFeedback.selectionClick();
    selectedType.value = type;
  }

  void selectAddress(int index) {
    if (index < 0 || index >= addressList.length) return;
    HapticFeedback.selectionClick();
    for (final item in addressList) {
      item.isSelected = false;
    }
    addressList[index].isSelected = true;
    addressList.refresh();
  }

  void goToCheckout() {
    final selected = addressList.firstWhereOrNull((element) => element.isSelected == true);
    if (selected == null) {
      Get.snackbar("Select Address", "Please select a delivery address.");
      return;
    }
    Get.back(result: selected);
  }

  void goToAddAddress() {
    _clearForm();
    if (!Get.isRegistered<AddressController>()) {
      Get.put(AddressController());
    }
    Get.to(() => const AddAddressView());
  }

  void deleteAddress(int index) {
    addressList.removeAt(index);
    HapticFeedback.mediumImpact();
  }

  void _clearForm() {
    nameController.clear();
    phoneController.clear();
    locationNameController.clear();
    buildingController.clear();
    flatController.clear();
    selectedType.value = "Home";
  }

  @override
  void onClose() {
    nameController.dispose();
    phoneController.dispose();
    locationNameController.dispose();
    buildingController.dispose();
    flatController.dispose();
    super.onClose();
  }
}