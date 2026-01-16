import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Haptic Feedback
import 'package:get/get.dart';
import '../../../data/model/address_model.dart';
import 'add_address_view.dart';

class AddressController extends GetxController {
  // --- UI State ---
  var addressList = <AddressModel>[].obs;
  var isLoading = true.obs;
  var isMapLoading = false.obs; // ম্যাপ লোডিং স্ট্যাটাস
  var isSaving = false.obs;

  // --- Form Controllers (TextEditingController) ---
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late TextEditingController nameController;
  late TextEditingController phoneController;
  late TextEditingController addressController;
  late TextEditingController cityController;
  late TextEditingController zipController;
  
  var selectedType = "Home".obs;

  @override
  void onInit() {
    super.onInit();
    // কন্ট্রোলারগুলো ইনিশিয়ালাইজ করা
    nameController = TextEditingController();
    phoneController = TextEditingController();
    addressController = TextEditingController();
    cityController = TextEditingController();
    zipController = TextEditingController();
    
    loadAddresses();
  }

  // --- Dummy Data Load ---
  void loadAddresses() async {
    isLoading.value = true;
    await Future.delayed(const Duration(milliseconds: 800));
    addressList.addAll([
      AddressModel(id: "1", type: "Home", address: "Flat 4B, House 12, Dhanmondi 32, Dhaka", phone: "01710000000", isSelected: true),
      AddressModel(id: "2", type: "Office", address: "Level 10, UTC Building, Karwan Bazar, Dhaka", phone: "01910000000"),
    ]);
    isLoading.value = false;
  }

  // --- 1. Address Selection Logic ---
  void selectAddress(int index) {
    HapticFeedback.selectionClick(); // হালকা ভাইব্রেশন
    for (var item in addressList) item.isSelected = false;
    addressList[index].isSelected = true;
    addressList.refresh();
  }

  // --- 2. Confirm Button Logic (Fixes 'goToCheckout' error) ---
  void goToCheckout() {
    var selected = addressList.firstWhereOrNull((element) => element.isSelected);
    
    if (selected == null) {
      Get.snackbar("Select Address", "Please select a delivery address.",
          backgroundColor: Colors.redAccent, colorText: Colors.white, snackPosition: SnackPosition.BOTTOM);
      return;
    }
    
    // চেকআউট পেজে ডাটা নিয়ে ফিরে যাওয়া
    Get.back(result: selected);
  }

  // --- 3. Map Simulation Logic (Real Feel) ---
  void pickLocationFromMap() async {
    HapticFeedback.mediumImpact();
    isMapLoading.value = true;
    
    // রিয়েল ম্যাপ লোডিং ফিল দেওয়ার জন্য স্ন্যাকবার
    Get.snackbar("Locating...", "Fetching location from GPS satellite...", 
      showProgressIndicator: true, 
      backgroundColor: Colors.black, 
      colorText: Colors.white, 
      snackPosition: SnackPosition.BOTTOM, 
      margin: const EdgeInsets.all(20),
      borderRadius: 10
    );

    await Future.delayed(const Duration(seconds: 2));

    // অটোমেটিক ডাটা বসিয়ে দেওয়া
    addressController.text = "House 56, Road 11, Banani";
    cityController.text = "Dhaka";
    zipController.text = "1213";
    
    isMapLoading.value = false;
    HapticFeedback.heavyImpact(); // সাকসেস ভাইব্রেশন
    
    Get.snackbar("Location Found", "Address auto-filled successfully!", 
      backgroundColor: Colors.green, colorText: Colors.white, snackPosition: SnackPosition.BOTTOM, margin: const EdgeInsets.all(20));
  }

  // --- 4. Save Logic ---
  void changeType(String type) {
    HapticFeedback.selectionClick();
    selectedType.value = type;
  }

  void saveAddress() async {
    HapticFeedback.lightImpact();
    if (!formKey.currentState!.validate()) return;

    isSaving.value = true;
    await Future.delayed(const Duration(seconds: 1)); 

    var newAddress = AddressModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: selectedType.value,
      address: "${addressController.text}, ${cityController.text}",
      phone: phoneController.text,
      isSelected: true,
    );

    // লিস্টের শুরুতে নতুন অ্যাড্রেস যোগ করা
    for (var item in addressList) item.isSelected = false;
    addressList.insert(0, newAddress);
    
    isSaving.value = false;

    Get.back(); // পেজ বন্ধ
    Get.back(result: newAddress); // চেকআউটে ডাটা পাঠানো
    
    Get.snackbar("Saved", "Address added successfully", 
      backgroundColor: Colors.black, colorText: Colors.white, snackPosition: SnackPosition.BOTTOM, margin: const EdgeInsets.all(20));
      
    _clearForm();
  }

  // --- Navigation & Cleanup ---
  void goToAddAddress() {
    _clearForm();
    Get.to(() => const AddAddressView());
  }

  void deleteAddress(int index) {
    addressList.removeAt(index);
    HapticFeedback.mediumImpact();
  }

  void _clearForm() {
    nameController.clear();
    phoneController.clear();
    addressController.clear();
    cityController.clear();
    zipController.clear();
    selectedType.value = "Home";
  }
  
  @override
  void onClose() {
    nameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    cityController.dispose();
    zipController.dispose();
    super.onClose();
  }
}