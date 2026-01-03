import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../login/login_view.dart';
// import '../login/login_view.dart'; // যখন Login বানাবে তখন কমেন্ট খুলবে

class OnboardingController extends GetxController {
  var selectedPageIndex = 0.obs;
  var pageController = PageController();

  // Dummy Data
  final List<Map<String, String>> onBoardingPages = [
    {
      "title": "Easy Booking",
      "desc": "Book professional services easily from your home.",
      "icon": "calendar_month" // আইকন নাম স্ট্রিং হিসেবে রাখলাম
    },
    {
      "title": "Expert Professionals",
      "desc": "Verified and trained experts for your needs.",
      "icon": "engineering"
    },
    {
      "title": "Fast Service",
      "desc": "Get service at your doorstep in record time.",
      "icon": "rocket_launch"
    },
  ];

  void nextPage() {
    if (selectedPageIndex.value == onBoardingPages.length - 1) {
      // শেষ স্লাইড হলে লগিনে যাবে
      print("Go to Login Screen");
      Get.offAll(() => const LoginView()); // Login View বানালে এটা অন করবে
    } else {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    }
  }
}