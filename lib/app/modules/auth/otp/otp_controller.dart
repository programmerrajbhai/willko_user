import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';

import '../forgot_password/reset_password_view.dart';
// import '../home/home_view.dart'; // হোম বা রিসেট পাসওয়ার্ড পেজ

class OtpController extends GetxController {
  // UI State
  var isLoading = false.obs;
  var timerValue = 30.obs; // ৩০ সেকেন্ড টাইমার
  var isResendEnabled = false.obs;

  // OTP Input
  // আমরা ৬টি আলাদা কন্ট্রোলার ব্যবহার না করে একটি টেক্সট স্ট্রিং বা পিন ফিল্ড ব্যবহার করতে পারি।
  // সহজ করার জন্য এখানে একটি স্ট্রিং ভেরিয়েবল রাখছি যা ইনপুট ফিল্ড থেকে আপডেট হবে।
  var otpCode = "".obs;
  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    startTimer();
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  // টাইমার লজিক
  void startTimer() {
    timerValue.value = 30;
    isResendEnabled.value = false;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timerValue.value > 0) {
        timerValue.value--;
      } else {
        isResendEnabled.value = true;
        _timer?.cancel();
      }
    });
  }

  // OTP ভেরিফিকেশন
  void verifyOtp() async {
    if (otpCode.value.length < 4) { // বা 6
      Get.snackbar("Error", "Please enter a valid OTP",
          backgroundColor: Colors.redAccent, colorText: Colors.white, snackPosition: SnackPosition.BOTTOM);
      return;
    }

    isLoading.value = true;

    // ফেইক API কল
    await Future.delayed(const Duration(seconds: 2));

    isLoading.value = false;

    // সফল হলে
    print("OTP Verified: ${otpCode.value}");
    Get.snackbar("Success", "Phone Number Verified!",
        backgroundColor: Colors.green, colorText: Colors.white);


    // চেক করা আর্গুমেন্ট পাঠানো হয়েছে কিনা
    if (Get.arguments != null && Get.arguments['isReset'] == true) {
      // রিসেট ফ্লো হলে পাসওয়ার্ড রিসেট পেজে যাবে
      Get.off(() => const ResetPasswordView());
    } else {
      // সাইন আপ ফ্লো হলে হোমে যাবে
      // Get.offAll(() => const HomeView());
      // TODO: হোম পেজ বা রিসেট পাসওয়ার্ড পেজে নেভিগেট করতে হবে
      // Get.offAll(() => const HomeView());
    }

  }

  // আবার কোড পাঠানো
  void resendCode() async {
    Get.snackbar("Sent", "OTP code sent again", backgroundColor: Colors.black54, colorText: Colors.white);
    startTimer();
  }
}