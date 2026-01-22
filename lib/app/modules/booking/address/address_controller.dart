import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

  late final TextEditingController nameController;
  late final TextEditingController phoneController;
  late final TextEditingController locationNameController;
  late final TextEditingController buildingController;
  late final TextEditingController flatController;

  final selectedType = "Home".obs;

  @override
  void onInit() {
    super.onInit();
    // ইনিশিয়ালাইজেশন
    nameController = TextEditingController();
    phoneController = TextEditingController();
    locationNameController = TextEditingController();
    buildingController = TextEditingController();
    flatController = TextEditingController();

    // অ্যাপ চালুর সাথে সাথে সেভ করা অ্যাড্রেস লোড হবে
    loadAddresses();
  }

  // ✅ Shared Preferences থেকে ডাটা লোড করা
  Future<void> loadAddresses() async {
    isLoading.value = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? addressesString = prefs.getString('saved_addresses');

      if (addressesString != null && addressesString.isNotEmpty) {
        // JSON স্ট্রিং থেকে লিস্টে কনভার্ট
        List<dynamic> jsonList = jsonDecode(addressesString);
        addressList.assignAll(jsonList.map((e) => AddressModel.fromJson(e)).toList());
      } else {
        // কোনো ডাটা না থাকলে খালি লিস্ট (No Dummy Data)
        addressList.clear();
      }
    } catch (e) {
      print("Error loading addresses: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // ✅ Shared Preferences এ ডাটা সেভ করা (Helper Function)
  Future<void> _saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    // লিস্টকে JSON স্ট্রিং এ কনভার্ট করে সেভ করা
    String jsonString = jsonEncode(addressList.map((e) => e.toJson()).toList());
    await prefs.setString('saved_addresses', jsonString);
  }

  // --- Save New Address ---
  Future<void> saveAddress() async {
    HapticFeedback.lightImpact();

    final valid = formKey.currentState?.validate() ?? false;
    if (!valid) {
      Get.snackbar("Missing Info", "Please fill all required fields", backgroundColor: Colors.redAccent, colorText: Colors.white, snackPosition: SnackPosition.BOTTOM, margin: const EdgeInsets.all(16));
      return;
    }

    isSaving.value = true;
    await Future.delayed(const Duration(milliseconds: 600)); // UI Feel

    // অ্যাড্রেস ফরম্যাট তৈরি
    String fullAddress = "";
    if (flatController.text.isNotEmpty) fullAddress += "Flat: ${flatController.text.trim()}, ";
    if (buildingController.text.isNotEmpty) fullAddress += "Bldg: ${buildingController.text.trim()}, ";
    fullAddress += locationNameController.text.trim();

    final newAddress = AddressModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: selectedType.value,
      fullName: nameController.text.trim(),
      phone: phoneController.text.trim(),
      addressLine: fullAddress,
      isSelected: addressList.isEmpty, // প্রথম অ্যাড্রেস হলে অটো সিলেক্ট
    );

    // আগের সিলেকশন বাদ দেওয়া (যদি নতুনটা সিলেক্টেড রাখতে চান)
    if (newAddress.isSelected) {
      for (var item in addressList) {
        item.isSelected = false;
      }
    }

    // লিস্টের শুরুতে যোগ করা
    addressList.insert(0, newAddress);
    
    // ✅ পার্মানেন্ট সেভ
    await _saveToPrefs();

    isSaving.value = false;
    Get.back(); // আগের পেজে ফেরত

    Get.snackbar("Success", "Address saved successfully!", backgroundColor: Colors.green.shade700, colorText: Colors.white, snackPosition: SnackPosition.BOTTOM, margin: const EdgeInsets.all(20));

    _clearForm();
  }

  // --- Actions ---
  
  void selectAddress(int index) async {
    HapticFeedback.selectionClick();
    for (var item in addressList) {
      item.isSelected = false;
    }
    addressList[index].isSelected = true;
    addressList.refresh();
    
    // সিলেকশন চেঞ্জ হলে সেটাও সেভ করতে হবে
    await _saveToPrefs();
  }

  void deleteAddress(int index) async {
    HapticFeedback.mediumImpact();
    
    // ডিলিট করার আগে কনফার্মেশন ডায়ালগ (Optional Pro UI Feature)
    Get.defaultDialog(
      title: "Delete Address",
      middleText: "Are you sure you want to delete this address?",
      textConfirm: "Delete",
      textCancel: "Cancel",
      confirmTextColor: Colors.white,
      buttonColor: Colors.redAccent,
      onConfirm: () async {
        addressList.removeAt(index);
        await _saveToPrefs(); // আপডেট সেভ
        Get.back(); // ডায়ালগ বন্ধ
      }
    );
  }

  // --- GPS Autofill (Simulated) ---
  Future<void> useCurrentLocation() async {
    HapticFeedback.mediumImpact();
    isMapLoading.value = true;
    
    // এখানে রিয়েল Geocoding বা Geolocator প্যাকেজ ব্যবহার করতে পারেন
    // আপাতত ডেমো ফিলিংস দিচ্ছি
    await Future.delayed(const Duration(seconds: 2));

    locationNameController.text = "Gulshan 1, Road 23, Dhaka";
    buildingController.text = "12";
    
    isMapLoading.value = false;
    HapticFeedback.heavyImpact();
  }

  void changeType(String type) {
    HapticFeedback.selectionClick();
    selectedType.value = type;
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
    Get.to(() => const AddAddressView());
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