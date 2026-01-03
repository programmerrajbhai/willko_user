import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'profile_controller.dart'; // মেইন প্রোফাইল কন্ট্রোলার

class EditProfileController extends GetxController {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController(); // ইমেইল সাধারণত এডিট করা যায় না

  var selectedImagePath = ''.obs; // নতুন ছবি রাখার জন্য
  var isLoading = false.obs;

  final ImagePicker _picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    // ProfileController থেকে বর্তমান ডাটা লোড করা
    var profileController = Get.find<ProfileController>();
    var user = profileController.user.value;

    if (user != null) {
      nameController.text = user.name;
      phoneController.text = user.phone;
      emailController.text = user.email;
    }
  }

  // ১. ছবি সিলেক্ট করা (Bottom Sheet অপশন সহ)
  void pickImage() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        ),
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Colors.blue),
              title: const Text('Camera'),
              onTap: () {
                _getImage(ImageSource.camera);
                Get.back();
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library, color: Colors.green),
              title: const Text('Gallery'),
              onTap: () {
                _getImage(ImageSource.gallery);
                Get.back();
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _getImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source);
    if (image != null) {
      selectedImagePath.value = image.path;
    }
  }

  // ২. প্রোফাইল সেভ করা
  void saveChanges() async {
    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 2)); // ফেক API কল

    // ProfileController এর ডাটা আপডেট করা
    var profileController = Get.find<ProfileController>();

    // নতুন ডাটা দিয়ে ইউজার মডেল আপডেট (রিয়েল অ্যাপে সার্ভার রেসপন্স থেকে হবে)
    var updatedUser = profileController.user.value!;
    updatedUser.name = nameController.text;
    updatedUser.phone = phoneController.text;

    // ছবি আপডেট (যদি নতুন ছবি সিলেক্ট করা থাকে)
    // নোট: রিয়েল অ্যাপে ইমেজ আপলোড করে URL পাবেন, এখানে লোকাল পাথ রাখছি
    if (selectedImagePath.isNotEmpty) {
      // updatedUser.image = selectedImagePath.value;
      // লোকাল পাথ হ্যান্ডেল করার লজিক ভিউতে থাকবে
    }

    profileController.user.refresh(); // UI রিফ্রেশ

    isLoading.value = false;
    Get.back(); // প্রোফাইলে ফিরে যাওয়া
    Get.snackbar("Success", "Profile updated successfully!",
        backgroundColor: Colors.green, colorText: Colors.white, snackPosition: SnackPosition.BOTTOM);
  }
}