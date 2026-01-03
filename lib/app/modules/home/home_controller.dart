import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'category/category_view.dart';

class HomeController extends GetxController {
  // ১. অফার ব্যানার
  final List<Map<String, dynamic>> banners = [
    {
      "title": "Home Deep Cleaning",
      "subtitle": "Get 20% Off | Use Code: CLEAN20",
      "color": const Color(0xFFE3F2FD), // Light Blue
      "image": "assets/images/clean_banner.png" // ডামি পাথ
    },
    {
      "title": "AC Service & Repair",
      "subtitle": "Starts at ৳599 only",
      "color": const Color(0xFFFFF3E0), // Light Orange
      "image": "assets/images/ac_banner.png"
    },
    {
      "title": "Salon at Home",
      "subtitle": "Professional beauty services",
      "color": const Color(0xFFFCE4EC), // Light Pink
      "image": "assets/images/salon_banner.png"
    },
  ];

  // ২. আরবান কোম্পানি স্টাইল ক্যাটাগরি
  final List<Map<String, dynamic>> categories = [
    {"name": "AC Repair", "icon": Icons.ac_unit_rounded, "color": Color(0xFFE0F7FA)},
    {"name": "Cleaning", "icon": Icons.cleaning_services_rounded, "color": Color(0xFFF1F8E9)},
    {"name": "Salon", "icon": Icons.face_rounded, "color": Color(0xFFFCE4EC)},
    {"name": "Painting", "icon": Icons.format_paint_rounded, "color": Color(0xFFFFF3E0)},
    {"name": "Electrician", "icon": Icons.electrical_services_rounded, "color": Color(0xFFFFF8E1)},
    {"name": "Plumber", "icon": Icons.plumbing_rounded, "color": Color(0xFFE1F5FE)},
    {"name": "Carpenter", "icon": Icons.carpenter_rounded, "color": Color(0xFFEFEBE9)},
    {"name": "Men's Cut", "icon": Icons.content_cut_rounded, "color": Color(0xFFECEFF1)},
  ];

  // ৩. রিকমেন্ডেড সার্ভিস
  final List<Map<String, dynamic>> popularServices = [
    {
      "id": 1,
      "name": "Intense Sofa Cleaning",
      "rating": "4.8 (12k)",
      "price": "৳1200",
      "image": Icons.chair_rounded
    },
    {
      "id": 2,
      "name": "Split AC Service",
      "rating": "4.9 (25k)",
      "price": "৳800",
      "image": Icons.ac_unit_rounded
    },
    {
      "id": 3,
      "name": "Full Home Cleaning",
      "rating": "4.7 (8k)",
      "price": "৳2500",
      "image": Icons.home_work_rounded
    },
  ];

  // onCategoryClick ফাংশনটি আপডেট করো:
  void onCategoryClick(String name) {
    Get.to(() => const CategoryServicesView(), arguments: name);
  }
}