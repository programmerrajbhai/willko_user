import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../data/model/address_model.dart';
import '../../../../utils/app_colors.dart';
import '../address/address_view.dart';
import '../success/order_success_view.dart';

class CheckoutController extends GetxController {
  // --- Address State ---
  var selectedAddress = Rxn<AddressModel>();

  // --- Date & Time ---
  var selectedDateIndex = 0.obs;
  var selectedTimeSlot = "".obs;

  List<DateTime> get next7Days => List.generate(7, (index) => DateTime.now().add(Duration(days: index)));

  final List<String> timeSlots = [
    "10:00 AM", "11:00 AM", "12:00 PM",
    "02:00 PM", "03:00 PM", "04:00 PM",
    "06:00 PM", "07:00 PM", "08:00 PM"
  ];

  // --- Payment ---
  var selectedPayment = "Cash on Delivery".obs;
  final List<Map<String, dynamic>> paymentMethods = [
    {"name": "Cash on Delivery", "icon": Icons.money},
    {"name": "Digital Payment", "icon": Icons.payment},
  ];

  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    // যদি আগের পেজ থেকে অ্যাড্রেস আসে
    if (Get.arguments is AddressModel) {
      selectedAddress.value = Get.arguments as AddressModel;
    }
  }

  // ✅ ADDRESS PICKER FUNCTION
  void pickAddress() async {
    // AddressView এ যাওয়া এবং রেজাল্ট এর জন্য অপেক্ষা করা
    var result = await Get.to(() => const AddressView());
    
    // যদি ইউজার কোনো অ্যাড্রেস সিলেক্ট করে ব্যাক করে
    if (result != null && result is AddressModel) {
      selectedAddress.value = result;
    }
  }

  void selectDate(int index) => selectedDateIndex.value = index;
  void selectTime(String time) => selectedTimeSlot.value = time;
  void selectPaymentMethod(String method) => selectedPayment.value = method;

  void placeOrder() async {
    // Validation
    if (selectedAddress.value == null) {
      Get.snackbar("Address Required", "Please select a service address.", 
        backgroundColor: Colors.redAccent, colorText: Colors.white, snackPosition: SnackPosition.BOTTOM, margin: const EdgeInsets.all(20));
      return;
    }
    if (selectedTimeSlot.value.isEmpty) {
      Get.snackbar("Time Required", "Please select a preferred time slot.", 
        backgroundColor: Colors.redAccent, colorText: Colors.white, snackPosition: SnackPosition.BOTTOM, margin: const EdgeInsets.all(20));
      return;
    }

    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 2));
    isLoading.value = false;
    Get.offAll(() => const OrderSuccessView());
  }
}