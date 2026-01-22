import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:willko_user/app/data/services/api_service.dart';
import 'package:willko_user/app/modules/auth/login/login_view.dart';
import '../../data/model/user_model.dart';

class ProfileController extends GetxController {
  var user = Rxn<UserModel>(); 
  var isLoading = true.obs;

  // ✅ অর্ডার স্ট্যাটাস কাউন্ট (Dynamic Stats)
  var activeOrderCount = 0.obs;
  var completedOrderCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUserProfile();
    fetchOrderStats(); // ✅ প্রোফাইল লোড হওয়ার সাথে সাথে অর্ডার কাউন্টও আনবে
  }

  // --- 1. Fetch User Profile ---
  void fetchUserProfile() async {
    isLoading.value = true;
    
    var response = await ApiService.fetchUserProfile();

    if (response['status'] == 'success') {
      var data = response['data'];

      user.value = UserModel(
        name: data['name'] ?? "User",
        email: data['email'] ?? "",
        phone: data['phone'] ?? "",
        image: data['image_url'] ?? "", 
      );

      // Local Storage Update
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_name', data['name'] ?? "");
      await prefs.setString('user_phone', data['phone'] ?? "");
      await prefs.setString('user_email', data['email'] ?? "");
      
      if(data['image_url'] != null) {
        await prefs.setString('user_image', data['image_url']);
      }

    } else if (response['status'] == 'unauthorized') {
      Get.snackbar("Session Expired", "Please login again");
      Get.offAll(() => const LoginView());
    } else {
      // Fallback to Local Data
      final prefs = await SharedPreferences.getInstance();
      
      user.value = UserModel(
        name: prefs.getString('user_name') ?? "Guest User",
        email: prefs.getString('user_email') ?? "",
        phone: prefs.getString('user_phone') ?? "",
        image: prefs.getString('user_image') ?? "", 
      );
    }

    isLoading.value = false;
  }

  // --- 2. Fetch Order Stats (Active vs Completed) ---
  void fetchOrderStats() async {
    // আমরা My Bookings API ব্যবহার করে কাউন্ট নিচ্ছি
    var response = await ApiService.fetchMyBookings();

    if (response['status'] == 'success') {
      var data = response['data'];
      
      List active = data['active'] ?? [];
      List history = data['history'] ?? [];

      // লিস্টের সাইজ গুনে ভেরিয়েবলে সেট করা
      activeOrderCount.value = active.length;
      completedOrderCount.value = history.length;
    }
  }

  // --- 3. Logout Logic ---
  void logout() {
    Get.defaultDialog(
        title: "Log Out",
        titleStyle: const TextStyle(fontWeight: FontWeight.bold),
        middleText: "Are you sure you want to log out?",
        textConfirm: "Log Out",
        textCancel: "Cancel",
        confirmTextColor: Colors.white,
        buttonColor: Colors.redAccent,
        radius: 12,
        onConfirm: () async {
          final prefs = await SharedPreferences.getInstance();
          await prefs.clear(); 
          Get.offAll(() => const LoginView()); 
        }
    );
  }
}