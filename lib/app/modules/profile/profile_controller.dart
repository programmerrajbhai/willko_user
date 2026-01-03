import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/model/user_model.dart';


class ProfileController extends GetxController {
  var user = Rxn<UserModel>(); // Nullable Observable
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUserProfile();
  }

  void fetchUserProfile() async {
    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 1)); // ফেক লোডিং

    // ডামি ইউজার ডাটা
    user.value = UserModel(
      name: "Abdur Rahim",
      email: "rahim.dev@gmail.com",
      phone: "+880 1712 345 678",
      image: "assets/images/user_avatar.png", // অথবা নেটওয়ার্ক ইমেজ URL
    );

    isLoading.value = false;
  }

  // লগআউট লজিক
  void logout() {
    Get.defaultDialog(
        title: "Logout",
        middleText: "Are you sure you want to logout?",
        textConfirm: "Yes, Logout",
        textCancel: "Cancel",
        confirmTextColor: Colors.white,
        buttonColor: Colors.redAccent,
        onConfirm: () {
          // টোকেন ক্লিয়ার করা (Real App)
          // Get.offAll(() => const LoginView()); // লগইন পেজে পাঠানো
          Get.back();
          Get.snackbar("Logged Out", "See you soon!", snackPosition: SnackPosition.BOTTOM);
        }
    );
  }
}