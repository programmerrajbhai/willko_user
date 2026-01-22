import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:willko_user/app/data/services/api_service.dart';
import 'package:willko_user/app/modules/home/home_controller.dart'; // HomeController Import
import '../../home/home_view.dart';
import '../forgot_password/forgot_password_view.dart';
import '../signup/signup_view.dart';

class LoginController extends GetxController {
  var isLoading = false.obs;
  var isPasswordHidden = true.obs;

  final phoneController = TextEditingController();
  final passwordController = TextEditingController();

  void togglePasswordVisibility() => isPasswordHidden.value = !isPasswordHidden.value;

  // ✅ লগইন ফাংশন
  void login() async {
    String phone = phoneController.text.trim();
    String password = passwordController.text.trim();

    if (phone.isEmpty || password.isEmpty) {
      Get.snackbar("Error", "Enter phone & password", backgroundColor: Colors.redAccent, colorText: Colors.white);
      return;
    }

    isLoading.value = true;
    var response = await ApiService.login(phone, password);
    isLoading.value = false;

    if (response['status'] == 'success') {
      // ১. ডাটা সেভ করা
      final data = response['data'];
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', data['token']);
      await prefs.setString('user_id', data['user_id'].toString());
      await prefs.setString('user_name', data['name']);
      await prefs.setString('user_phone', data['phone']);
      if(data['email'] != null) await prefs.setString('user_email', data['email']);

      Get.snackbar("Success", "Welcome Back!", backgroundColor: Colors.green, colorText: Colors.white);

      // ✅ ২. HomeController রিফ্রেশ করা (যাতে প্রোফাইল আইকন সাথে সাথে আসে)
      if (Get.isRegistered<HomeController>()) {
        await Get.find<HomeController>().checkLoginStatus();
      }

      // ✅ ৩. নেভিগেশন লজিক
      if (Get.arguments != null && Get.arguments['fromCheckout'] == true) {
        // যদি চেকআউট থেকে আসে, তাহলে ব্যাক করবে (Result: true)
        Get.back(result: true); 
      } else {
        // নরমাল লগইন হলে হোম পেজে যাবে
        Get.offAll(() => const HomeView());
      }

    } else {
      Get.snackbar("Login Failed", response['message'] ?? "Error", backgroundColor: Colors.redAccent, colorText: Colors.white);
    }
  }

  void goToSignUp() => Get.to(() => const SignUpView());
  void goToForgotPassword() => Get.to(() => const ForgotPasswordView());
}