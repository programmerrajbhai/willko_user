import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../utils/app_colors.dart'; // কালার ইমপোর্ট
import '../success/order_success_view.dart';

class CheckoutController extends GetxController {
  // 1. Date & Time Selection
  var selectedDateIndex = 0.obs;
  var selectedTimeSlot = "".obs;

  // আগামী ৭ দিনের লিস্ট
  List<DateTime> get next7Days {
    return List.generate(7, (index) => DateTime.now().add(Duration(days: index)));
  }

  // হেল্পার: বর্তমানে সিলেক্ট করা আসল তারিখটি পাওয়ার জন্য
  DateTime get selectedDate => next7Days[selectedDateIndex.value];

  // ফিক্সড টাইম স্লট
  final List<String> timeSlots = [
    "10:00 AM", "11:00 AM", "12:00 PM",
    "02:00 PM", "03:00 PM", "04:00 PM",
    "06:00 PM", "07:00 PM", "08:00 PM"
  ];

  // 2. Payment Method
  var selectedPayment = "Cash on Delivery".obs; 
  final List<Map<String, dynamic>> paymentMethods = [
    {"name": "Cash on Delivery", "icon": Icons.money, "id": "cod"},
    {"name": "bKash / Nagad", "icon": Icons.account_balance_wallet, "id": "mobile_banking"},
    {"name": "Credit / Debit Card", "icon": Icons.credit_card, "id": "card"},
  ];

  var isLoading = false.obs;

  // 3. Actions
  void selectDate(int index) {
    selectedDateIndex.value = index;
    // তারিখ পরিবর্তন করলে টাইম স্লট রিসেট করতে চাইলে নিচের লাইনটি আনকমেন্ট করুন
    // selectedTimeSlot.value = ""; 
  }

  void selectTime(String time) {
    selectedTimeSlot.value = time;
  }

  void selectPaymentMethod(String method) {
    selectedPayment.value = method;
  }

  // 4. Final Order Place
  void placeOrder() async {
    // ভ্যালিডেশন: সময় সিলেক্ট করা না থাকলে
    if (selectedTimeSlot.value.isEmpty) {
      Get.snackbar(
        "Time Slot Required", 
        "Please select a preferred time for service.",
        backgroundColor: Colors.redAccent, 
        colorText: Colors.white, 
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(20),
        borderRadius: 10,
      );
      return;
    }

    isLoading.value = true;

    // ডিবাগ: কি অর্ডার হচ্ছে তা দেখা
    String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);
    print("Booking Info: Date: $formattedDate, Time: ${selectedTimeSlot.value}, Payment: ${selectedPayment.value}");

    // ফেক এপিআই কল (২ সেকেন্ড)
    await Future.delayed(const Duration(seconds: 2)); 

    isLoading.value = false;

    // সফল হলে সাকসেস পেজে যাওয়া
    Get.offAll(() => const OrderSuccessView());
  }
}