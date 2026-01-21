import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:willko_user/app/data/services/api_service.dart';
import 'service_details/service_details_view.dart'; // ইমপোর্ট নিশ্চিত করুন

class HomeController extends GetxController {
  // --- Loading State ---
  var isLoading = true.obs;

  // --- Dynamic Data Lists ---
  var banners = <Map<String, dynamic>>[].obs;
  var categories = <Map<String, dynamic>>[].obs;
  var popularServices = <Map<String, dynamic>>[].obs;

  // --- City selector ---
  final cities = <String>["Dhaka", "Chattogram", "Sylhet", "Khulna"].obs;
  final selectedCity = "Select your city".obs;
  
  // --- Selection ---
  final selectedCategoryIndex = (-1).obs;

  // --- Static Data ---
  final whyItems = [
    {
      "icon": Icons.star_rounded,
      "title": "Transparent pricing",
      "subtitle": "See fixed prices before you book. No hidden charges."
    },
    {
      "icon": Icons.person_rounded,
      "title": "Experts only",
      "subtitle": "Our professionals are well trained and have on-job expertise."
    },
    {
      "icon": Icons.headset_mic_rounded,
      "title": "Fully equipped",
      "subtitle": "We bring everything needed to get the job done well."
    },
  ];

  @override
  void onInit() {
    super.onInit();
    fetchDashboardData();
  }

  // ✅ হোম পেজের ডাটা আনার API কল
  void fetchDashboardData() async {
    try {
      isLoading.value = true;
      var response = await ApiService.fetchHomeData();

      if (response['status'] == 'success') {
        var data = response['data'];

        // Banners
        if (data['banners'] != null) {
          banners.assignAll(List<Map<String, dynamic>>.from(data['banners']));
        }

        // Categories
        if (data['categories'] != null) {
          categories.assignAll(List<Map<String, dynamic>>.from(data['categories']));
        }

        // Popular Services
        if (data['popular_services'] != null) {
          popularServices.assignAll(List<Map<String, dynamic>>.from(data['popular_services']));
        }
      }
    } catch (e) {
      print("Error fetching data: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void pickCity(String city) => selectedCity.value = city;

  // ✅ ক্যাটাগরি ক্লিক -> ডিটেইলস পেজ নেভিগেশন
  void onCategoryTap(int index) {
    selectedCategoryIndex.value = index;
    
    // যে ক্যাটাগরিতে ক্লিক করা হয়েছে তার ডাটা
    var selectedCategory = categories[index];

    // ServiceDetailsView তে যাওয়া হচ্ছে এবং ডাটা পাস করা হচ্ছে
    Get.to(
      () => const ServiceDetailsView(), 
      arguments: selectedCategory, // আর্গুমেন্ট হিসেবে ম্যাপ পাস হচ্ছে
      transition: Transition.cupertino
    );
  }

  // পপুলার সার্ভিস ক্লিক হ্যান্ডলার
  void openServiceDetails(Map<String, dynamic> service) {
    // এখানেও একই ভিউ রিইউজ করা হচ্ছে
    Get.to(
      () => const ServiceDetailsView(), 
      arguments: service,
      transition: Transition.cupertino
    );
  }
}