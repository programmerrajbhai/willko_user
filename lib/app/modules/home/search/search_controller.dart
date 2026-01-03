import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchServicesController extends GetxController {
  // ১. ভেরিয়েবল
  var searchText = "".obs;
  var searchResults = <Map<String, dynamic>>[].obs;
  final searchController = TextEditingController();

  // ২. পপুলার ট্যাগস (যখন সার্চ বক্স খালি থাকবে তখন দেখাবে)
  final List<String> popularTags = [
    "AC Service",
    "Sofa Cleaning",
    "Haircut",
    "Plumber",
    "Electrician",
    "Massage"
  ];

  // ৩. সব সার্ভিসের মাস্টার ডাটা (Category Controller এর মতই)
  final List<Map<String, dynamic>> allServices = [
    {
      "id": 101,
      "name": "AC Service (Split)",
      "price": "৳800",
      "rating": "4.8",
      "category": "AC Repair",
      "image": Icons.ac_unit_rounded
    },
    {
      "id": 102,
      "name": "AC Check-up",
      "price": "৳500",
      "rating": "4.7",
      "category": "AC Repair",
      "image": Icons.build_rounded
    },
    {
      "id": 103,
      "name": "Sofa Deep Cleaning",
      "price": "৳1200",
      "rating": "4.9",
      "category": "Cleaning",
      "image": Icons.chair_rounded
    },
    {
      "id": 104,
      "name": "Full Home Deep Clean",
      "price": "৳3000",
      "rating": "4.8",
      "category": "Cleaning",
      "image": Icons.home_work_rounded
    },
    {
      "id": 105,
      "name": "Haircut for Men",
      "price": "৳300",
      "rating": "4.6",
      "category": "Salon",
      "image": Icons.content_cut_rounded
    },
    {
      "id": 106,
      "name": "Bathroom Cleaning",
      "price": "৳800",
      "rating": "4.5",
      "category": "Cleaning",
      "image": Icons.water_drop_rounded
    }
  ];

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  // ৪. সার্চ লজিক ফাংশন
  void filterServices(String query) {
    searchText.value = query;

    if (query.isEmpty) {
      searchResults.clear();
    } else {
      // নাম অথবা ক্যাটাগরি দিয়ে সার্চ হবে (Case Insensitive)
      var result = allServices.where((service) {
        var name = service['name'].toString().toLowerCase();
        var category = service['category'].toString().toLowerCase();
        var input = query.toLowerCase();
        return name.contains(input) || category.contains(input);
      }).toList();

      searchResults.value = result;
    }
  }

  // ৫. ট্যাগ এ ক্লিক করলে সার্চ হবে
  void onTagClick(String tag) {
    searchController.text = tag;
    filterServices(tag);
  }

  // ৬. ক্লিয়ার বাটন
  void clearSearch() {
    searchController.clear();
    searchText.value = "";
    searchResults.clear();
  }
}