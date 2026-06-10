import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'reset_password_view.dart'; // আপনার ResetPasswordView-এর সঠিক ইমপোর্ট পাথ দিবেন

class ForgotPasswordController extends GetxController {
  // 🔥 Controllers
  final phoneController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // 🔥 Observables
  final isLoading = false.obs;
  final isPasswordHidden = true.obs;
  String _verificationId = "";

  // Firebase Auth Instance
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Password Visibility Toggle
  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  // ========================================================
  // STEP 1: Check Phone in Database and Send Firebase OTP
  // ========================================================
  Future<void> sendOtp() async {
    String phone = phoneController.text.trim();

    if (phone.isEmpty) {
      Get.snackbar("Error", "Please enter your phone number.", backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    isLoading.value = true;

    try {
      // PHP Backend API কল করে চেক করা
      var response = await http.post(
        Uri.parse("https://willkoservices.com/WillkoServiceApi/check_phone_exist.php"),
        body: {"phone": phone},
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        if (data['status'] == 'success') {
          // নাম্বারটি ডাটাবেসে আছে, তাই Firebase OTP ট্রিগার করা
          await _triggerFirebaseOTP(phone);
        } else {
          isLoading.value = false;
          Get.snackbar("Not Found", data['message'], backgroundColor: Colors.orange, colorText: Colors.white);
        }
      } else {
        isLoading.value = false;
        Get.snackbar("Error", "Server Error: ${response.statusCode}", backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      isLoading.value = false;
      Get.snackbar("Error", "Network error occurred.", backgroundColor: Colors.red, colorText: Colors.white);
      debugPrint("API Error: $e");
    }
  }

  Future<void> _triggerFirebaseOTP(String phone) async {
    // 💡 আপনার দেশের কোড অ্যাড করুন (উদাহরণস্বরূপ +880 বা +974)
    String fullPhone = phone.startsWith('+') ? phone : '+880$phone';

    await _auth.verifyPhoneNumber(
      phoneNumber: fullPhone,
      verificationCompleted: (PhoneAuthCredential credential) async {
        // Auto resolution on Android
        isLoading.value = false;
      },
      verificationFailed: (FirebaseAuthException e) {
        isLoading.value = false;
        Get.snackbar("OTP Failed", e.message ?? "Verification failed", backgroundColor: Colors.red, colorText: Colors.white);
      },
      codeSent: (String verificationId, int? resendToken) {
        isLoading.value = false;
        this._verificationId = verificationId;

        Get.snackbar("Success", "OTP has been sent to your phone", backgroundColor: Colors.green, colorText: Colors.white);

        // 🔥 OTP Screen-এ নেভিগেট করুন (আপনার OTP স্ক্রিনের নাম অনুযায়ী রাউট পরিবর্তন করবেন)
        Get.toNamed('/otp_view');
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        this._verificationId = verificationId;
      },
    );
  }

  // ========================================================
  // STEP 2: Verify OTP (এই মেথডটি আপনার OTP স্ক্রিন থেকে কল করবেন)
  // ========================================================
  Future<void> verifyOtp(String smsCode) async {
    if (smsCode.isEmpty || smsCode.length < 6) return;

    isLoading.value = true;
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: _verificationId, smsCode: smsCode);

      await _auth.signInWithCredential(credential);

      isLoading.value = false;
      // ভেরিফিকেশন সাকসেস হলে Reset Password স্ক্রিনে যাবে
      Get.to(() => const ResetPasswordView());
    } catch (e) {
      isLoading.value = false;
      Get.snackbar("Error", "Invalid OTP. Please try again.", backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  // ========================================================
  // STEP 3: Update Password in Backend Database
  // ========================================================
  Future<void> resetPassword() async {
    String newPass = newPasswordController.text;
    String confirmPass = confirmPasswordController.text;
    String phone = phoneController.text.trim();

    if (newPass.isEmpty || confirmPass.isEmpty) {
      Get.snackbar("Error", "Passwords cannot be empty", backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }
    if (newPass != confirmPass) {
      Get.snackbar("Error", "Passwords do not match", backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    isLoading.value = true;

    try {
      var response = await http.post(
        Uri.parse("https://willkoservices.com/WillkoServiceApi/update_password.php"),
        body: {
          "phone": phone,
          "password": newPass
        },
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['status'] == 'success') {
          Get.snackbar("Success", "Password updated successfully!", backgroundColor: Colors.green, colorText: Colors.white);

          // ফর্ম ক্লিয়ার করে লগইন স্ক্রিনে পাঠিয়ে দেয়া
          phoneController.clear();
          newPasswordController.clear();
          confirmPasswordController.clear();

          Get.offAllNamed('/login'); // আপনার লগইন রাউট দিবেন
        } else {
          Get.snackbar("Error", data['message'], backgroundColor: Colors.red, colorText: Colors.white);
        }
      }
    } catch (e) {
      Get.snackbar("Error", "Network error occurred.", backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }
}