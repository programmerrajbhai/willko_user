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

  // ✅ Login Function (Simplified)
  void login() async {
    String phone = phoneController.text.trim();
    String password = passwordController.text.trim();

    // Validation
    if (phone.isEmpty || password.isEmpty) {
      Get.snackbar(
        "Required", 
        "Please enter both phone and password", 
        backgroundColor: Colors.redAccent, 
        colorText: Colors.white, 
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
      return;
    }

    isLoading.value = true;

    // 1. Call API
    var response = await ApiService.login(phone, password);

    isLoading.value = false;

    if (response['status'] == 'success') {
      // 2. Save Session Data securely
      final data = response['data'];
      final prefs = await SharedPreferences.getInstance();
      
      await prefs.setString('auth_token', data['token']);
      await prefs.setString('user_id', data['user_id'].toString());
      await prefs.setString('user_name', data['name']);
      await prefs.setString('user_phone', data['phone']);
      if(data['email'] != null) await prefs.setString('user_email', data['email']);
      
      Get.snackbar(
        "Welcome Back!", 
        "Login Successful", 
        backgroundColor: Colors.green, 
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );

      // ✅ 3. Navigate to Home Screen directly (Clear previous stack)
      Get.offAll(() => const HomeView());

    } else {
      Get.snackbar(
        "Login Failed", 
        response['message'] ?? "Invalid credentials", 
        backgroundColor: Colors.redAccent, 
        colorText: Colors.white, 
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
    }
  }

  void goToSignUp() {
    Get.to(() => const SignUpView());
  }

  void goToForgotPassword() {
    Get.to(() => const ForgotPasswordView());
  }
}