import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../success/order_success_view.dart';

class CheckoutController extends GetxController {
  // 1. Date & Time Selection
  var selectedDateIndex = 0.obs;
  var selectedTimeSlot = "".obs;

  // আগামী ৭ দিনের লিস্ট তৈরি করা
  List<DateTime> get next7Days {
    return List.generate(7, (index) => DateTime.now().add(Duration(days: index)));
  }

  // ফিক্সড টাইম স্লট (রিয়েল অ্যাপে এটি ডায়নামিক হতে পারে)
  final List<String> timeSlots = [
    "10:00 AM", "11:00 AM", "12:00 PM",
    "02:00 PM", "03:00 PM", "04:00 PM",
    "06:00 PM", "07:00 PM", "08:00 PM"
  ];

  // 2. Payment Method
  var selectedPayment = "Cash on Delivery".obs; // Default
  final List<Map<String, dynamic>> paymentMethods = [
    {"name": "Cash on Delivery", "icon": Icons.money, "id": "cod"},
    {"name": "bKash / Nagad", "icon": Icons.account_balance_wallet, "id": "mobile_banking"},
    {"name": "Credit / Debit Card", "icon": Icons.credit_card, "id": "card"},
  ];

  var isLoading = false.obs;

  // 3. Actions
  void selectDate(int index) {
    selectedDateIndex.value = index;
    // ডেট পাল্টালে টাইম স্লট রিসেট করতে পারো বা রাখতে পারো
  }

  void selectTime(String time) {
    selectedTimeSlot.value = time;
  }

  void selectPaymentMethod(String method) {
    selectedPayment.value = method;
  }

  // 4. Final Order Place
  void placeOrder() async {
    if (selectedTimeSlot.value.isEmpty) {
      Get.snackbar("Required", "Please select a time slot",
          backgroundColor: Colors.redAccent, colorText: Colors.white, snackPosition: SnackPosition.BOTTOM);
      return;
    }

    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 2)); // ফেক অর্ডার প্রসেসিং
    isLoading.value = false;
    Get.offAll(() => const OrderSuccessView());
    // সাকসেস ডায়ালগ বা পেজে পাঠানো
    // Get.defaultDialog(
    //   title: "Booking Confirmed!",
    //   middleText: "Your service has been scheduled successfully.",
    //   textConfirm: "Go to Home",
    //   confirmTextColor: Colors.white,
    //   buttonColor: const Color(0xFF6C63FF),
    //   onConfirm: () {
    //     // সব বন্ধ করে হোমে যাওয়া
    //     Get.offAllNamed('/'); // অথবা HomeView()
    //     // রিয়েল অ্যাপে: Get.offAll(() => const HomeView());
    //   },
    //   barrierDismissible: false,
    // );


  }
}