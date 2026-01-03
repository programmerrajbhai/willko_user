import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../otp/otp_view.dart';
import '../login/login_view.dart';

class ForgotPasswordController extends GetxController {
  var isLoading = false.obs;
  var isPasswordHidden = true.obs;

  // Inputs
  final phoneController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // 1. Send OTP (Forgot Password Screen)
  void sendOtp() async {
    String phone = phoneController.text.trim();

    if (phone.isEmpty) {
      Get.snackbar("Error", "Please enter your phone number",
          backgroundColor: Colors.redAccent, colorText: Colors.white);
      return;
    }

    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 2)); // API Call Simulation
    isLoading.value = false;

    // OTP পেজে পাঠানো (যেখানে ভেরিফাই হলে Reset Password পেজে যাবে)
    // আমরা আর্গুমেন্ট দিয়ে পাঠাতে পারি যে এটি 'reset' ফ্লো
    Get.to(() => const OtpView(), arguments: {'isReset': true});
  }

  // 2. Reset Password (Reset Screen)
  void resetPassword() async {
    String pass = newPasswordController.text.trim();
    String confirmPass = confirmPasswordController.text.trim();

    if (pass.isEmpty || confirmPass.isEmpty) {
      Get.snackbar("Error", "All fields are required",
          backgroundColor: Colors.redAccent, colorText: Colors.white);
      return;
    }

    if (pass != confirmPass) {
      Get.snackbar("Error", "Passwords do not match",
          backgroundColor: Colors.redAccent, colorText: Colors.white);
      return;
    }

    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 2)); // API Call Simulation
    isLoading.value = false;

    Get.snackbar("Success", "Password Reset Successfully!",
        backgroundColor: Colors.green, colorText: Colors.white);

    // সব কিছু মুছে লগিন পেজে ফিরে যাওয়া
    Get.offAll(() => const LoginView());
  }

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }
}