import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:willko_user/app/data/services/api_service.dart';
import '../login/login_view.dart';
import 'reset_password_view.dart';

class ForgotPasswordController extends GetxController {
  // 🔥 Controllers
  final emailController = TextEditingController();
  final otpController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final isLoading = false.obs;
  final isPasswordHidden = true.obs;

  void togglePasswordVisibility() => isPasswordHidden.value = !isPasswordHidden.value;

  // 1. Send OTP to Email
  Future<void> sendOtp() async {
    String email = emailController.text.trim();

    if (!GetUtils.isEmail(email)) {
      Get.snackbar("Error", "Please enter a valid email.", backgroundColor: Colors.redAccent, colorText: Colors.white);
      return;
    }

    isLoading.value = true;
    var response = await ApiService.sendEmailOtp(email);
    isLoading.value = false;

    if (response['status'] == 'success') {
      Get.snackbar("Success", response['message'], backgroundColor: Colors.green, colorText: Colors.white);
      _showOtpDialog(); // 🔥 OTP ডায়লগ ওপেন হবে
    } else {
      Get.snackbar("Error", response['message'] ?? "Failed to send OTP", backgroundColor: Colors.redAccent, colorText: Colors.white);
    }
  }

  // 🔥 Smart OTP Popup Dialog
  void _showOtpDialog() {
    otpController.clear();
    Get.defaultDialog(
      title: "Enter OTP",
      titleStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
      contentPadding: const EdgeInsets.all(20),
      content: Column(
        children: [
          Text("We have sent a 6-digit OTP to\n${emailController.text}", textAlign: TextAlign.center, style: const TextStyle(color: Colors.grey)),
          const SizedBox(height: 20),
          TextField(
            controller: otpController,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 24, letterSpacing: 10, fontWeight: FontWeight.bold),
            decoration: InputDecoration(
              hintText: "------",
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
            ),
          ),
        ],
      ),
      confirm: Obx(() => SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          onPressed: isLoading.value ? null : () => verifyOtp(otpController.text.trim()),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
          child: isLoading.value ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white)) : const Text("VERIFY", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
        ),
      )),
    );
  }

  // 2. Verify Email OTP
  Future<void> verifyOtp(String otp) async {
    if (otp.isEmpty || otp.length < 4) {
      Get.snackbar("Error", "Enter valid OTP", backgroundColor: Colors.redAccent, colorText: Colors.white);
      return;
    }

    isLoading.value = true;
    var response = await ApiService.verifyEmailOtp(emailController.text.trim(), otp);
    isLoading.value = false;

    if (response['status'] == 'success') {
      Get.back(); // Close Dialog
      Get.snackbar("Verified", "OTP verified successfully!", backgroundColor: Colors.green, colorText: Colors.white);
      Get.to(() => const ResetPasswordView()); // Go to Password Reset Screen
    } else {
      Get.snackbar("Error", response['message'] ?? "Invalid OTP", backgroundColor: Colors.redAccent, colorText: Colors.white);
    }
  }
// ========================================================
  // STEP 3: Reset Password & Navigate to Login
  // ========================================================
  Future<void> resetPassword() async {
    String newPass = newPasswordController.text;
    String confirmPass = confirmPasswordController.text;

    if (newPass.isEmpty || newPass != confirmPass) {
      Get.snackbar("Error", "Passwords do not match", backgroundColor: Colors.redAccent, colorText: Colors.white);
      return;
    }
    if (newPass.length < 6) {
      Get.snackbar("Error", "Password must be at least 6 characters", backgroundColor: Colors.redAccent, colorText: Colors.white);
      return;
    }

    isLoading.value = true;
    try {
      var response = await ApiService.resetPasswordEmail(emailController.text.trim(), newPass);
      isLoading.value = false;

      if (response['status'] == 'success') {
        // ✅ সাকসেস মেসেজ দেখানো
        Get.snackbar(
          "Success",
          "Password updated successfully! Please login.",
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );

        // ✅ ফর্ম ক্লিয়ার করা
        emailController.clear();
        newPasswordController.clear();
        confirmPasswordController.clear();

        // ✅ একদম ক্লিয়ার করে Login স্ক্রিনে পাঠিয়ে দেওয়া (যাতে ব্যাক বাটনে চাপলে আবার রিসেট পেজে না আসে)
        Get.offAll(() => const LoginView());

      } else {
        Get.snackbar("Error", response['message'] ?? "Failed to reset password", backgroundColor: Colors.redAccent, colorText: Colors.white);
      }
    } catch (e) {
      isLoading.value = false;
      Get.snackbar("Error", "Network error occurred.", backgroundColor: Colors.redAccent, colorText: Colors.white);
    }
  }
}