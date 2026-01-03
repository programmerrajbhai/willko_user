import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../home/home_view.dart';
import '../forgot_password/forgot_password_view.dart';
import '../signup/signup_view.dart';
// import '../signup/signup_view.dart'; // সাইন আপ পেজ বানানোর পর খুলবে
// import '../home/home_view.dart';     // হোম পেজ বানানোর পর খুলবে

class LoginController extends GetxController {
  // UI State Variables
  var isLoading = false.obs;
  var isPasswordHidden = true.obs;

  // Input Controllers
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();

  // Password Visibility Toggle
  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  // Login Function (Dummy Logic)
  void login() async {
    String phone = phoneController.text.trim();
    String password = passwordController.text.trim();

    if (phone.isEmpty || password.isEmpty) {
      Get.snackbar(
        "Error",
        "Please enter phone and password",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    // লোডিং শুরু
    isLoading.value = true;

    // ২ সেকেন্ড ফেক লোডিং (API কল সিমুলেশন)
    await Future.delayed(const Duration(seconds: 2));

    isLoading.value = false;

    // সফল হলে যা হবে (কনসোলে প্রিন্ট)
    print("Login Success! Phone: $phone");
    Get.snackbar(
      "Success",
      "Login Successful",
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );

    // TODO: হোম স্ক্রিনে নেভিগেট করতে হবে
  Get.offAll(() => const HomeView());
  }

  // Go to Sign Up Page
  void goToSignUp() {
   Get.to(() => const SignUpView());
    print("Go to Sign Up");
  }

  // Go to Forgot Password
  void goToForgotPassword() {
    print("Go to Forgot Password");
    Get.to(() => const ForgotPasswordView());
  }
}