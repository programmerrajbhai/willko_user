import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:willko_user/app/data/services/api_service.dart';
import 'package:willko_user/app/modules/home/home_view.dart';
import 'package:willko_user/app/modules/home/home_controller.dart';

class SignUpController extends GetxController {
  // UI State
  var isLoading = false.obs;
  var isPasswordHidden = true.obs;

  // Input Controllers
  final nameController = TextEditingController();
  final emailController = TextEditingController(); // ✅ Added Email Controller
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // Toggle Password View
  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  // Register & Auto Login Function
  void register() async {
    String name = nameController.text.trim();
    String email = emailController.text.trim(); // ✅ Get Email
    String phone = phoneController.text.trim();
    String pass = passwordController.text.trim();
    String confirmPass = confirmPasswordController.text.trim();

    // 1. Basic Validation
    if (name.isEmpty || email.isEmpty || phone.isEmpty || pass.isEmpty || confirmPass.isEmpty) {
      Get.snackbar("Error", "All fields are required!",
          backgroundColor: Colors.redAccent, colorText: Colors.white, snackPosition: SnackPosition.BOTTOM);
      return;
    }

    // 2. Email Validation
    if (!GetUtils.isEmail(email)) {
      Get.snackbar("Error", "Enter a valid email address!",
          backgroundColor: Colors.redAccent, colorText: Colors.white, snackPosition: SnackPosition.BOTTOM);
      return;
    }

    if (pass != confirmPass) {
      Get.snackbar("Error", "Passwords do not match!",
          backgroundColor: Colors.redAccent, colorText: Colors.white, snackPosition: SnackPosition.BOTTOM);
      return;
    }

    if (pass.length < 6) {
      Get.snackbar("Error", "Password must be at least 6 characters long!",
          backgroundColor: Colors.redAccent, colorText: Colors.white, snackPosition: SnackPosition.BOTTOM);
      return;
    }

    isLoading.value = true;

    try {
      // ---------------------------------------------------------
      // Step 1: Register API কল (Email সহ)
      // ---------------------------------------------------------
      // ⚠️ খেয়াল রাখবেন: ApiService.registerUser মেথডে যেন email প্যারামিটারটি রিসিভ করার অপশন থাকে
      var registerResponse = await ApiService.registerUser(name, email, phone, pass);

      if (registerResponse['status'] == 'success') {

        // ---------------------------------------------------------
        // Step 2: রেজিস্ট্রেশন সফল হলে অটোমেটিক Login API কল
        // ---------------------------------------------------------
        var loginResponse = await ApiService.login(phone, pass); // phone অথবা email যেকোনোটি দিয়েই হবে

        if (loginResponse['status'] == 'success') {
          // ৩. লগিন সফল হলে ডাটা SharedPreferences এ সেভ করা
          final data = loginResponse['data'];
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('auth_token', data['token']);
          await prefs.setString('user_id', data['user_id'].toString());
          await prefs.setString('user_name', data['name']);
          await prefs.setString('user_phone', data['phone']);
          if(data['email'] != null) await prefs.setString('user_email', data['email']);

          Get.snackbar("Welcome!", "Account Created & Logged In Successfully.",
              backgroundColor: Colors.green, colorText: Colors.white);

          // ৪. HomeController রিফ্রেশ করা (যাতে প্রোফাইল আইকন সাথে সাথে আসে)
          if (Get.isRegistered<HomeController>()) {
            await Get.find<HomeController>().checkLoginStatus();
          }

          // ৫. সবকিছু সফল হলে সরাসরি Home পেজে নেভিগেশন
          Get.offAll(() => const HomeView());

        } else {
          Get.snackbar("Success", "Account created! Please login manually.",
              backgroundColor: Colors.green, colorText: Colors.white);
          Get.back(); // Back to Login Page
        }
      } else {
        Get.snackbar("Registration Failed", registerResponse['message'] ?? "Try again later.",
            backgroundColor: Colors.redAccent, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong! Check connection.",
          backgroundColor: Colors.redAccent, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  void goToLogin() {
    Get.back();
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose(); // ✅ Clean memory
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}