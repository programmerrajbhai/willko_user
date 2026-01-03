import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/model/address_model.dart';
import '../checkout/checkout_view.dart';
import 'add_address_view.dart';


class AddressController extends GetxController {
  var addressList = <AddressModel>[].obs;
  var isLoading = true.obs;



  @override
  void onInit() {
    super.onInit();
    loadAddresses();
  }



  void loadAddresses() async {
    isLoading.value = true;
    await Future.delayed(const Duration(milliseconds: 800));
    addressList.addAll([
      AddressModel(id: "1", type: "Home", address: "House 12, Road 5, Block C, Mirpur 10, Dhaka", phone: "+8801712345678", isSelected: true),
      AddressModel(id: "2", type: "Office", address: "Level 4, Software Park, Karwan Bazar, Dhaka", phone: "+8801812345678"),
    ]);
    isLoading.value = false;
  }

  void selectAddress(int index) {
    for (var item in addressList) item.isSelected = false;
    addressList[index].isSelected = true;
    addressList.refresh();
  }

  void deleteAddress(int index) {
    addressList.removeAt(index);
    Get.snackbar("Deleted", "Address removed successfully");
  }

  // Add Address Page এ যাওয়ার ফাংশন (আগের ফাইলে আপডেট করতে হবে)
  void goToAddAddress() {
    _clearForm(); // যাওয়ার আগে ফর্ম ক্লিয়ার
   Get.to(() => const AddAddressView()); // নিচে ভিউ বানাচ্ছি
  }

  void goToCheckout() {
    // চেক করা কোনো এড্রেস সিলেক্টেড কিনা
    var selected = addressList.firstWhereOrNull((element) => element.isSelected);
    if (selected == null) {
      Get.snackbar("Select Address", "Please select a delivery address.");
      return;
    }
    Get.to(() => const CheckoutView());
  }

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final cityController = TextEditingController();
  final zipController = TextEditingController();

  // অ্যাড্রেস টাইপ সিলেকশন
  var selectedType = "Home".obs; // Home, Office, Other
  var isSaving = false.obs;

  void changeType(String type) {
    selectedType.value = type;
  }

  // ঠিকানা সেভ করার ফাংশন
  void saveAddress() async {
    if (!formKey.currentState!.validate()) {
      return; // ভ্যালিডেশন ফেইল করলে থামবে
    }

    isSaving.value = true;
    await Future.delayed(const Duration(seconds: 2)); // ফেক API কল

    // নতুন অ্যাড্রেস অবজেক্ট তৈরি
    var newAddress = AddressModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(), // ইউনিক আইডি
      type: selectedType.value,
      address: "${addressController.text}, ${cityController.text} - ${zipController.text}",
      phone: phoneController.text,
      isSelected: true, // নতুনটাই সিলেক্ট হবে
    );

    // আগের সিলেকশন বন্ধ করা
    for (var item in addressList) item.isSelected = false;

    // লিস্টে অ্যাড করা
    addressList.add(newAddress);

    isSaving.value = false;

    Get.back(); // আগের পেজে ফিরে যাওয়া
    Get.snackbar("Success", "New address added successfully!",
        backgroundColor: Colors.green, colorText: Colors.white, snackPosition: SnackPosition.BOTTOM);

    // ফর্ম ক্লিয়ার করা
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