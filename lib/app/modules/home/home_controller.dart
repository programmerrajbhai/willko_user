import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:willko_user/app/data/services/api_service.dart';
import 'package:willko_user/app/modules/auth/login/login_view.dart';
import 'service_details/service_details_view.dart';

class HomeController extends GetxController {
  // --- Auth & Cart State ---
  var isLoading = true.obs;
  var isLoggedIn = false.obs;
  var userName = "User".obs;
  var cartCount = 0.obs; // ✅ কার্ট ব্যাজ কাউন্ট

  // --- Data Lists ---
  var banners = <Map<String, dynamic>>[].obs;
  var categories = <Map<String, dynamic>>[].obs;
  var popularServices = <Map<String, dynamic>>[].obs;

  // --- City & Selection ---
  final cities = <String>["Dhaka", "Chattogram", "Sylhet", "Khulna"].obs;
  final selectedCity = "Select your city".obs;
  final selectedCategoryIndex = (-1).obs;

  // --- Static Data ---
  final whyItems = [
    {"icon": Icons.star_rounded, "title": "Transparent pricing", "subtitle": "See fixed prices before you book."},
    {"icon": Icons.person_rounded, "title": "Experts only", "subtitle": "Our professionals are well trained."},
    {"icon": Icons.headset_mic_rounded, "title": "Fully equipped", "subtitle": "We bring everything needed."},
  ];

  @override
  void onInit() {
    super.onInit();
    checkLoginStatus(); // লগইন চেক
    updateCartCount();  // ✅ অ্যাপ ওপেন হলে কার্ট কাউন্ট চেক
    fetchDashboardData();
  }

  // ✅ ১. লগইন স্ট্যাটাস চেক
  Future<void> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    
    if (token != null && token.isNotEmpty) {
      isLoggedIn.value = true;
      userName.value = prefs.getString('user_name') ?? "User";
    } else {
      isLoggedIn.value = false;
      userName.value = "User";
    }
  }

  // ✅ ২. কার্ট কাউন্ট আপডেট (SharedPrefs থেকে)
  Future<void> updateCartCount() async {
    final prefs = await SharedPreferences.getInstance();
    String? savedData = prefs.getString('user_cart_data');
    if (savedData != null && savedData.isNotEmpty) {
      try {
        Map<String, dynamic> decoded = jsonDecode(savedData);
        cartCount.value = decoded.length; // কয়টা আইটেম আছে তা সেট করছি
      } catch (e) {
        cartCount.value = 0;
      }
    } else {
      cartCount.value = 0;
    }
  }

  // ✅ ৩. লগআউট
  void logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    isLoggedIn.value = false;
    userName.value = "User";
    cartCount.value = 0;
    Get.snackbar("Logged Out", "See you soon!", backgroundColor: Colors.black87, colorText: Colors.white, snackPosition: SnackPosition.BOTTOM);
  }

  // ✅ ৪. ড্যাশবোর্ড ডাটা ফেচ
  void fetchDashboardData() async {
    try {
      isLoading.value = true;
      var response = await ApiService.fetchHomeData();
      if (response['status'] == 'success') {
        var data = response['data'];
        if (data['banners'] != null) banners.assignAll(List<Map<String, dynamic>>.from(data['banners']));
        if (data['categories'] != null) categories.assignAll(List<Map<String, dynamic>>.from(data['categories']));
        if (data['popular_services'] != null) popularServices.assignAll(List<Map<String, dynamic>>.from(data['popular_services']));
      }
    } catch (e) {
      print("Error fetching home data: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void pickCity(String city) => selectedCity.value = city;

  void onCategoryTap(int index) {
    selectedCategoryIndex.value = index;
    Get.to(() => const ServiceDetailsView(), arguments: categories[index], transition: Transition.cupertino)
      ?.then((_) => updateCartCount()); // ফিরে আসলে কার্ট আপডেট হবে
  }

  void openServiceDetails(Map<String, dynamic> service) {
    Get.to(() => const ServiceDetailsView(), arguments: service, transition: Transition.cupertino)
      ?.then((_) => updateCartCount()); // ফিরে আসলে কার্ট আপডেট হবে
  }
}