import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../../booking/cart/cart_view.dart';


class ServiceDetailsController extends GetxController {
  var service = {}.obs;
  var isLoading = true.obs;
  var quantity = 1.obs;

  // ডামি ডিটেইলড ডাটা (সাধারণত API থেকে আসবে)
  final Map<String, dynamic> dummyDetails = {
    "id": 101,
    "name": "AC Service (Split)",
    "price": "৳800",
    "rating": "4.8",
    "reviews_count": "12k",
    "description": "Advanced foam-jet technology for 2X deeper cleaning. Improves cooling efficiency and reduces power consumption.",
    "time": "45 mins",
    "image": Icons.ac_unit_rounded,
    "includes": [
      "Filter and coil cleaning",
      "Gas pressure check",
      "Drain pipe cleaning",
      "Outdoor unit check"
    ],
    "excludes": [
      "Spare parts replacement",
      "Gas refill (charged separately)"
    ],
    "gallery": [
      Colors.blue.shade100,
      Colors.blue.shade200,
      Colors.blue.shade300
    ]
  };

  @override
  void onInit() {
    super.onInit();
    // আর্গুমেন্ট থেকে আইডি নেওয়া (যদি পাঠানো হয়)
    if (Get.arguments != null) {
      // রিয়েল অ্যাপে এখানে API কল হবে ID দিয়ে
      loadServiceDetails(Get.arguments);
    } else {
      loadServiceDetails(101); // ডিফল্ট টেস্ট ডাটা
    }
  }

  void loadServiceDetails(dynamic id) async {
    isLoading.value = true;
    await Future.delayed(const Duration(milliseconds: 800)); // ফেক লোডিং

    // ডামি ডাটার সাথে আর্গুমেন্টের নাম মার্জ করা (যদি সিম্পল অবজেক্ট পাস করা হয়)
    // এখানে আমরা সরাসরি ডামি ডিটেইলস অ্যাসাইন করছি
    service.value = dummyDetails;
    isLoading.value = false;
  }

  void incrementQty() => quantity.value++;

  void decrementQty() {
    if (quantity.value > 1) quantity.value--;
  }

  void addToCart() {
    Get.snackbar(
      "Cart",
      "${service['name']} added to cart!",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      margin: const EdgeInsets.all(20),
    );
    Get.to(() => const CartView());// কার্ট ভিউ ইমপোর্ট করো
    // TODO: কার্ট লজিক বা কার্ট পেজে নেভিগেশন
  }
}