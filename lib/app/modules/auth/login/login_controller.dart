import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:willko_user/app/data/services/api_service.dart';
import '../../home/home_view.dart';
import '../forgot_password/forgot_password_view.dart';
import '../signup/signup_view.dart';

class LoginController extends GetxController {
  var isLoading = false.obs;
  var isPasswordHidden = true.obs;

  final phoneController = TextEditingController();
  final passwordController = TextEditingController();

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  // ✅ Login Function
  void login() async {
    String phone = phoneController.text.trim();
    String password = passwordController.text.trim();

    if (phone.isEmpty || password.isEmpty) {
      Get.snackbar("Error", "Please enter phone and password", backgroundColor: Colors.redAccent, colorText: Colors.white, snackPosition: SnackPosition.BOTTOM);
      return;
    }

    isLoading.value = true;

    // 1. Call API
    var response = await ApiService.login(phone, password);

    isLoading.value = false;

    if (response['status'] == 'success') {
      // 2. Save Data to Shared Preferences
      final data = response['data'];
      final prefs = await SharedPreferences.getInstance();
      
      await prefs.setString('auth_token', data['token']);
      await prefs.setString('user_id', data['user_id'].toString());
      await prefs.setString('user_name', data['name']);
      await prefs.setString('user_phone', data['phone']);
      await prefs.setString('user_email', data['email']);
      
      Get.snackbar("Success", "Login Successful!", backgroundColor: Colors.green, colorText: Colors.white);

      // 3. Smart Navigation Logic (UPDATED)
      if (Get.arguments != null && Get.arguments['fromCheckout'] == true) {
        // ✅ চেকআউট পেজে জানিয়ে দিচ্ছি যে লগইন সফল হয়েছে
        Get.back(result: true); 
      } else {
        Get.offAll(() => const HomeView());
      }

    } else {
      Get.snackbar("Login Failed", response['message'] ?? "Unknown Error", backgroundColor: Colors.redAccent, colorText: Colors.white, snackPosition: SnackPosition.BOTTOM);
    }
  }

  void goToSignUp() {
    Get.to(() => const SignUpView());
  }

  void goToForgotPassword() {
    Get.to(() => const ForgotPasswordView());
  }
}