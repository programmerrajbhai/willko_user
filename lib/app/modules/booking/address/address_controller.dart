import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/model/address_model.dart';
import '../checkout/checkout_view.dart';
import 'add_address_view.dart';

class AddressController extends GetxController {
  var addressList = <AddressModel>[].obs;
  var isLoading = true.obs;

  // ফর্ম ভেরিয়েবলস
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final cityController = TextEditingController();
  final zipController = TextEditingController();
  
  var selectedType = "Home".obs;
  var isSaving = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadAddresses();
  }

  void loadAddresses() async {
    isLoading.value = true;
    await Future.delayed(const Duration(milliseconds: 600));
    addressList.addAll([
      AddressModel(id: "1", type: "Home", address: "Flat 4B, House 12, Road 5, Dhanmondi, Dhaka", phone: "+8801710000000", isSelected: true),
      AddressModel(id: "2", type: "Office", address: "Level 10, UTC Building, Karwan Bazar, Dhaka", phone: "+8801910000000"),
    ]);
    isLoading.value = false;
  }

  // ✅ ১. সিলেক্ট করার লজিক (Urban Company Style)
  // লিস্টে ট্যাপ করলেই সিলেক্ট হবে এবং ব্যাকে চলে যাবে
  void selectAddress(int index) {
    // UI আপডেট
    for (var item in addressList) item.isSelected = false;
    addressList[index].isSelected = true;
    addressList.refresh();

    // সিলেক্টেড অ্যাড্রেস নিয়ে চেকআউটে ফিরে যাওয়া
    Future.delayed(const Duration(milliseconds: 200), () {
      Get.back(result: addressList[index]);
    });
  }

  // ✅ ২. বাটন ক্লিক হ্যান্ডলার (এরর ফিক্স)
  void goToCheckout() {
    var selected = addressList.firstWhereOrNull((element) => element.isSelected);
    
    if (selected == null) {
      Get.snackbar("Select Address", "Please select a delivery address.");
      return;
    }
    
    // রেজাল্ট নিয়ে ব্যাক করা (কারণ আমরা চেকআউট থেকেই এসেছি)
    Get.back(result: selected);
    
    // নোট: যদি আপনি কার্ট থেকে সরাসরি আসেন, তাহলে নিচের লাইনটি ব্যবহার করতে পারেন:
    // Get.to(() => const CheckoutView(), arguments: selected);
  }

  void deleteAddress(int index) {
    addressList.removeAt(index);
    Get.snackbar("Deleted", "Address removed successfully", 
      snackPosition: SnackPosition.BOTTOM, margin: const EdgeInsets.all(20));
  }

  void goToAddAddress() {
    _clearForm();
    Get.to(() => const AddressView());
  }

  // --- Add Address Logic ---
  void changeType(String type) => selectedType.value = type;

  void saveAddress() async {
    if (!formKey.currentState!.validate()) return;

    isSaving.value = true;
    await Future.delayed(const Duration(seconds: 1)); // Fake API

    var newAddress = AddressModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: selectedType.value,
      address: "${addressController.text}, ${cityController.text}",
      phone: phoneController.text,
      isSelected: true, // নতুনটাই সিলেক্ট হবে
    );

    // আগেরগুলো আন-সিলেক্ট করা
    for (var item in addressList) item.isSelected = false;
    
    addressList.insert(0, newAddress); // নতুনটা সবার উপরে
    isSaving.value = false;

    Get.back(); // ফর্ম বন্ধ
    
    // সাথে সাথে চেকআউটে রিটার্ন করা (অটোমেটিক)
    Get.back(result: newAddress); 
    
    Get.snackbar("Success", "Address added & selected!", 
      backgroundColor: Colors.green, colorText: Colors.white, snackPosition: SnackPosition.BOTTOM, margin: const EdgeInsets.all(20));
      
    _clearForm();
  }

  void _clearForm() {
    nameController.clear();
    phoneController.clear();
    addressController.clear();
    cityController.clear();
    zipController.clear();
    selectedType.value = "Home";
  }
}