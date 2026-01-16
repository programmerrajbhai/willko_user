import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Haptic Feedback
import 'package:get/get.dart';
import '../../../data/model/address_model.dart';
import '../../../../utils/app_colors.dart';
import '../address/address_view.dart';
import '../success/order_success_view.dart';

class CheckoutController extends GetxController {
  // --- Address ---
  var selectedAddress = Rxn<AddressModel>();

  // --- Date & Time ---
  var selectedDateIndex = 0.obs;
  var selectedTimeSlot = "".obs;

  List<DateTime> get next7Days => List.generate(14, (index) => DateTime.now().add(Duration(days: index)));

  final List<String> timeSlots = [
    "10:00 AM", "11:00 AM", "12:00 PM",
    "02:00 PM", "03:00 PM", "04:00 PM",
    "06:00 PM", "07:00 PM", "08:00 PM"
  ];

  // --- Payment ---
  var selectedPayment = "Cash on Delivery".obs;
  final List<Map<String, dynamic>> paymentMethods = [
    {"name": "Cash on Delivery", "icon": Icons.money_rounded, "desc": "Pay after service"},
    {"name": "Digital Payment", "icon": Icons.account_balance_wallet_rounded, "desc": "bKash / Card"},
  ];

  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments is AddressModel) {
      selectedAddress.value = Get.arguments as AddressModel;
    }
  }

  // --- Actions with Vibrations ---

  void pickAddress() async {
    HapticFeedback.lightImpact(); // Vibration
    var result = await Get.to(() => const AddressView());
    if (result != null && result is AddressModel) {
      selectedAddress.value = result;
    }
  }

  void selectDate(int index) {
    HapticFeedback.selectionClick();
    selectedDateIndex.value = index;
  }

  void selectTime(String time) {
    HapticFeedback.mediumImpact();
    selectedTimeSlot.value = time;
  }

  void selectPaymentMethod(String method) {
    HapticFeedback.selectionClick();
    selectedPayment.value = method;
  }

  void placeOrder() async {
    HapticFeedback.heavyImpact(); // Strong Vibration

    if (selectedAddress.value == null) {
      Get.snackbar("Address Missing", "Please select a location.", backgroundColor: Colors.redAccent, colorText: Colors.white, snackPosition: SnackPosition.BOTTOM, margin: const EdgeInsets.all(20));
      return;
    }
    if (selectedTimeSlot.value.isEmpty) {
      Get.snackbar("Time Missing", "Select a preferred time.", backgroundColor: Colors.redAccent, colorText: Colors.white, snackPosition: SnackPosition.BOTTOM, margin: const EdgeInsets.all(20));
      return;
    }

    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 2));
    isLoading.value = false;
    Get.offAll(() => const OrderSuccessView());
  }
}