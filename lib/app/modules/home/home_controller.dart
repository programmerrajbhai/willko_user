import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:willko_user/app/data/services/api_service.dart';
import 'service_details/service_details_view.dart';

class HomeController extends GetxController {
  // --- Loading State ---
  var isLoading = true.obs;

  // --- Dynamic Data Lists (API from Admin Panel) ---
  var banners = <Map<String, dynamic>>[].obs;
  var categories = <Map<String, dynamic>>[].obs;
  var popularServices = <Map<String, dynamic>>[].obs;

  // --- City selector ---
  final cities = <String>["Dhaka", "Chattogram", "Sylhet", "Khulna"].obs;
  final selectedCity = "Select your city".obs;
  
  // --- Selection ---
  final selectedCategoryIndex = (-1).obs;

  // --- Static Data (Why Section) ---
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

  // ✅ API কল ফাংশন
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

  // ক্যাটাগরি সিলেক্ট করা
  void onCategoryTap(int index) {
    selectedCategoryIndex.value = index;
    // এখানে আপনি চাইলে ফিল্টার লজিক বসাতে পারেন
    print("Selected Category: ${categories[index]['name']}");
  }

  // সার্ভিস ডিটেইলস পেজে যাওয়া
  void openServiceDetails(Map<String, dynamic> service) {
    Get.to(() => const ServiceDetailsView(), arguments: service);
  }
}