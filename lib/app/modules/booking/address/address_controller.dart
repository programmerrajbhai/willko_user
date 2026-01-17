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

  // --- Form ---
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  late final TextEditingController nameController;
  late final TextEditingController phoneController;
  late final TextEditingController addressLineController;
  late final TextEditingController cityController;
  late final TextEditingController zipController;

  final selectedType = "Home".obs;

  @override
  void onInit() {
    super.onInit();
    nameController = TextEditingController();
    phoneController = TextEditingController();
    addressLineController = TextEditingController();
    cityController = TextEditingController();
    zipController = TextEditingController();

    loadAddresses();
  }

  Future<void> loadAddresses() async {
    isLoading.value = true;

    await Future.delayed(const Duration(milliseconds: 500));
    addressList.assignAll([
      AddressModel(
        id: "1",
        type: "Home",
        fullName: "John Doe",
        phone: "01710000000",
        addressLine: "Flat 4B, House 12, Dhanmondi 32",
        city: "Dhaka",
        zip: "1209",
        isSelected: true, address: '',
      ),
      AddressModel(
        id: "2",
        type: "Office",
        fullName: "John Doe",
        phone: "01910000000",
        addressLine: "Level 10, UTC Building, Karwan Bazar",
        city: "Dhaka",
        zip: "1215",
        isSelected: false, address: '',
      ),
    ]);

    isLoading.value = false;
  }

  // --- Selection ---
  void selectAddress(int index) {
    if (index < 0 || index >= addressList.length) return;

    HapticFeedback.selectionClick();

    for (final item in addressList) {
      item.isSelected = false;
    }
    addressList[index].isSelected = true;
    addressList.refresh();

    Future.delayed(const Duration(milliseconds: 200), () {
      Get.back(result: addressList[index]);
    });
  }

  void goToCheckout() {
    final selected =
        addressList.firstWhereOrNull((element) => element.isSelected == true);

    if (selected == null) {
      Get.snackbar(
        "Select Address",
        "Please select a delivery address.",
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
      return;
    }

    Get.back(result: selected);
  }

  // --- GPS demo autofill ---
  Future<void> useCurrentLocation() async {
    HapticFeedback.mediumImpact();
    isMapLoading.value = true;

    Get.snackbar(
      "Locating...",
      "Fetching precise location via GPS...",
      showProgressIndicator: true,
      backgroundColor: Colors.black87,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(20),
      borderRadius: 12,
    );

    await Future.delayed(const Duration(seconds: 2));

    addressLineController.text = "House 56, Road 11, Banani";
    cityController.text = "Dhaka";
    zipController.text = "1213";

    isMapLoading.value = false;
    HapticFeedback.heavyImpact();

    Get.snackbar(
      "Location Found",
      "Address details auto-filled!",
      backgroundColor: const Color(0xFF10B981),
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(20),
      icon: const Icon(Icons.check_circle, color: Colors.white),
    );
  }

  void changeType(String type) {
    HapticFeedback.selectionClick();
    selectedType.value = type;
  }

  Future<void> saveAddress() async {
    HapticFeedback.lightImpact();

    final valid = formKey.currentState?.validate() ?? false;
    if (!valid) {
      Get.snackbar(
        "Error",
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

    final newAddress = AddressModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: selectedType.value,
      fullName: nameController.text.trim(),
      phone: phoneController.text.trim(),
      addressLine: addressLineController.text.trim(),
      city: cityController.text.trim(),
      zip: zipController.text.trim(),
      isSelected: true, address: '',
    );

    for (final item in addressList) {
      item.isSelected = false;
    }
    addressList.insert(0, newAddress);

    isSaving.value = false;

    Get.back();

    Get.snackbar(
      "Saved",
      "Address added successfully!",
      backgroundColor: Colors.black,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(20),
      borderRadius: 12,
    );

    _clearForm();
  }

  void goToAddAddress() {
    _clearForm();
    if (!Get.isRegistered<AddressController>()) {
      Get.put(AddressController());
    }
    Get.to(() => const AddAddressView());
  }

  void deleteAddress(int index) {
    if (index < 0 || index >= addressList.length) return;
    addressList.removeAt(index);
    HapticFeedback.mediumImpact();
  }

  void _clearForm() {
    nameController.clear();
    phoneController.clear();
    addressLineController.clear();
    cityController.clear();
    zipController.clear();
    selectedType.value = "Home";
  }

  @override
  void onClose() {
    nameController.dispose();
    phoneController.dispose();
    addressLineController.dispose();
    cityController.dispose();
    zipController.dispose();
    super.onClose();
  }
}
