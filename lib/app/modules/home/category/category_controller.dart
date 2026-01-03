import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../service_details/service_details_view.dart';
// import '../service_details/service_details_view.dart'; // সার্ভিস ডিটেইলস পেজ পরে আসবে

class CategoryController extends GetxController {
  var categoryName = "".obs;
  var categoryServices = <Map<String, dynamic>>[].obs;
  var isLoading = true.obs;

  // মাস্টার ডামি ডাটা (সব সার্ভিস এখানে আছে)
  final List<Map<String, dynamic>> allServices = [
    {
      "id": 101,
      "category": "AC Repair",
      "name": "AC Service (Split)",
      "price": "৳800",
      "rating": "4.8 (12k)",
      "time": "45 mins",
      "features": ["Foam Jet Technology", "2X Deeper Cleaning"],
      "image": Icons.ac_unit_rounded
    },
    {
      "id": 102,
      "category": "AC Repair",
      "name": "AC Check-up",
      "price": "৳500",
      "rating": "4.7 (5k)",
      "time": "30 mins",
      "features": ["Diagnosis", "Performance Check"],
      "image": Icons.build_rounded
    },
    {
      "id": 103,
      "category": "Cleaning",
      "name": "Sofa Deep Cleaning",
      "price": "৳1200",
      "rating": "4.9 (8k)",
      "time": "60 mins",
      "features": ["Vacuuming", "Shampooing"],
      "image": Icons.chair_rounded
    },
    {
      "id": 104,
      "category": "Cleaning",
      "name": "Full Home Deep Clean",
      "price": "৳3000",
      "rating": "4.8 (2k)",
      "time": "4-5 hrs",
      "features": ["Floor", "Kitchen", "Washroom"],
      "image": Icons.home_work_rounded
    },
    {
      "id": 105,
      "category": "Salon",
      "name": "Haircut for Men",
      "price": "৳300",
      "rating": "4.6 (15k)",
      "time": "30 mins",
      "features": ["Haircut", "Wash"],
      "image": Icons.content_cut_rounded
    }
  ];

  @override
  void onInit() {
    super.onInit();
    // 1. আর্গুমেন্ট থেকে ক্যাটাগরির নাম নেওয়া
    if (Get.arguments != null) {
      categoryName.value = Get.arguments;
      loadServices();
    }
  }

  void loadServices() async {
    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 1)); // ফেক লোডিং

    // 2. ক্যাটাগরি অনুযায়ী ফিল্টার করা
    // যদি ডাটাবেসে সেই ক্যাটাগরির সার্ভিস না থাকে, তবে ডেমো দেখানোর জন্য সব লোড করব (টেস্টিং পারপাস)
    var filtered = allServices.where((s) => s['category'] == categoryName.value).toList();

    if (filtered.isNotEmpty) {
      categoryServices.value = filtered;
    } else {
      // ডেমো হিসেবে কিছু ডাটা দেখানো (যাতে লিস্ট খালি না লাগে)
      categoryServices.value = allServices.take(3).toList();
    }

    isLoading.value = false;
  }

  void onServiceClick(int id) {
    print("Clicked Service ID: $id");
 Get.to(() => ServiceDetailsView(), arguments: id);
  }
}