import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CouponController extends GetxController {
  final couponInputController = TextEditingController();
  var isLoading = false.obs;

  // ডামি কুপন ডাটাবেস
  final List<Map<String, dynamic>> availableCoupons = [
    {
      "code": "EID2026",
      "title": "Eid Special Offer",
      "description": "Get 10% discount on all services",
      "discount_type": "percent", // percent or flat
      "amount": 10, // 10%
      "min_order": 500
    },
    {
      "code": "WELCOME50",
      "title": "New User Bonus",
      "description": "Flat ৳50 off on your first booking",
      "discount_type": "flat",
      "amount": 50,
      "min_order": 200
    },
    {
      "code": "SUMMER25",
      "title": "Summer Cool",
      "description": "Get 25% off on AC Services",
      "discount_type": "percent",
      "amount": 25,
      "min_order": 1000
    }
  ];

  // কুপন অ্যাপ্লাই করার লজিক
  void applyCoupon(String code, double cartTotal) async {
    if (code.isEmpty) {
      Get.snackbar("Error", "Please enter a coupon code", backgroundColor: Colors.redAccent, colorText: Colors.white);
      return;
    }

    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 1)); // ফেক চেকিং

    // কুপন খোঁজা (Case Insensitive)
    var coupon = availableCoupons.firstWhereOrNull(
            (c) => c['code'].toString().toUpperCase() == code.toUpperCase()
    );

    isLoading.value = false;

    if (coupon == null) {
      Get.snackbar("Invalid", "This coupon code is not valid.", backgroundColor: Colors.redAccent, colorText: Colors.white);
      return;
    }

    // মিনিমাম অর্ডার চেক
    if (cartTotal < coupon['min_order']) {
      Get.snackbar("Oops!", "Minimum order amount must be ৳${coupon['min_order']}", backgroundColor: Colors.orange, colorText: Colors.white);
      return;
    }

    // সব ঠিক থাকলে ডিসকাউন্ট ক্যালকুলেট করে ব্যাক করা
    double discountAmount = 0.0;
    if (coupon['discount_type'] == 'percent') {
      discountAmount = (cartTotal * coupon['amount']) / 100;
    } else {
      discountAmount = double.parse(coupon['amount'].toString());
    }

    // ম্যাক্সিমাম ডিসকাউন্ট লিমিট (অপশনাল)
    if (discountAmount > 500) discountAmount = 500;

    Get.back(result: {
      "code": coupon['code'],
      "amount": discountAmount
    });

    Get.snackbar("Success", "Coupon Applied! You saved ৳$discountAmount", backgroundColor: Colors.green, colorText: Colors.white);
  }
}