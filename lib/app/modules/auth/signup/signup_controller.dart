import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../otp/otp_view.dart';
// import '../otp/otp_view.dart'; // OTP পেজ বানানোর পর এটা খুলবে

class SignUpController extends GetxController {
  // UI State
  var isLoading = false.obs;
  var isPasswordHidden = true.obs;

  // Input Controllers
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // Toggle Password View
  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  // Register Function
  void register() async {
    String name = nameController.text.trim();
    String phone = phoneController.text.trim();
    String pass = passwordController.text.trim();
    String confirmPass = confirmPasswordController.text.trim();

    // 1. Basic Validation
    if (name.isEmpty || phone.isEmpty || pass.isEmpty) {
      Get.snackbar("Error", "All fields are required",
          backgroundColor: Colors.redAccent, colorText: Colors.white, snackPosition: SnackPosition.BOTTOM);
      return;
    }

    // 2. Password Match Check
    if (pass != confirmPass) {
      Get.snackbar("Error", "Passwords do not match",
          backgroundColor: Colors.redAccent, colorText: Colors.white, snackPosition: SnackPosition.BOTTOM);
      return;
    }

    isLoading.value = true;

    // Simulate API Call
    await Future.delayed(const Duration(seconds: 2));

    isLoading.value = false;

    print("Register Data: Name: $name, Phone: $phone");

    // Success Message
    Get.snackbar("Success", "Account Created! Verify OTP.",
        backgroundColor: Colors.green, colorText: Colors.white);

    // TODO: OTP স্ক্রিনে পাঠাতে হবে
   // Get.to(() => const OtpView());
  }

  // Go back to Login
  void goToLogin() {
    Get.back(); // আগের পেজে (লগিন) ফিরে যাবে
  }
}