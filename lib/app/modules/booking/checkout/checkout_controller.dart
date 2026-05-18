// ফাইল: lib/app/modules/booking/checkout/checkout_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:willko_user/app/data/model/address_model.dart';
import 'package:willko_user/app/data/services/api_service.dart';
import 'package:willko_user/app/modules/booking/address/address_view.dart';
import 'package:willko_user/app/modules/booking/success/order_success_view.dart';
import 'package:intl/intl.dart';
import '../../../../utils/pixel_tracker.dart'; // 🔥 পিক্সেল ট্র্যাকার ইমপোর্ট

class CheckoutController extends GetxController {
  var isLoading = false.obs;
  var isLoggedIn = false.obs;

  var userId = "".obs;
  var userName = "".obs;
  var userPhone = "".obs;
  var userImage = "".obs;

  var cartItems = <Map<String, dynamic>>[].obs;

  var selectedAddress = Rxn<AddressModel>();
  var selectedDate = Rxn<DateTime>();
  var selectedTime = Rxn<TimeOfDay>();

  var selectedPayment = "Cash on Delivery".obs;

  double get itemTotal => cartItems.fold(0, (sum, item) => sum + ((item['priceInt'] ?? 0) * (item['quantity'] ?? 1)));
  double get grandTotal => itemTotal;

  String get formattedDate => selectedDate.value != null ? DateFormat('yyyy-MM-dd').format(selectedDate.value!) : "";
  String get displayDate => selectedDate.value != null ? DateFormat('EEE, dd MMM').format(selectedDate.value!) : "Select Date";
  String get formattedTime => selectedTime.value != null ? selectedTime.value!.format(Get.context!) : "Select Time";

  @override
  void onInit() {
    super.onInit();
    _loadUserData();
    _loadCartArgs();
  }

  void _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    if (token != null) {
      isLoggedIn.value = true;
      userId.value = prefs.getString('user_id') ?? "";
      userName.value = prefs.getString('user_name') ?? "User";
      userPhone.value = prefs.getString('user_phone') ?? "";
      userImage.value = prefs.getString('user_image') ?? "";
    }
  }

  void _loadCartArgs() {
    if (Get.arguments != null && Get.arguments['cart'] != null) {
      cartItems.assignAll(Get.arguments['cart']);
    }
  }

  void incrementQty(int index) {
    var item = cartItems[index];
    item['quantity'] = (item['quantity'] ?? 1) + 1;
    cartItems[index] = item;
    cartItems.refresh();
  }

  void decrementQty(int index) {
    var item = cartItems[index];
    if ((item['quantity'] ?? 1) > 1) {
      item['quantity'] = (item['quantity'] ?? 1) - 1;
      cartItems[index] = item;
      cartItems.refresh();
    } else {
      cartItems.removeAt(index);
    }
  }

  void pickAddress() async {
    var result = await Get.to(() => const AddressView());
    if (result != null && result is AddressModel) {
      selectedAddress.value = result;
    }
  }

  Future<void> chooseDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
    if (picked != null) selectedDate.value = picked;
  }

  Future<void> chooseTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (picked != null) selectedTime.value = picked;
  }

  void selectPaymentMethod(String method) => selectedPayment.value = method;


  void handlePlaceOrder() async {
    if (!isLoggedIn.value) { Get.snackbar("Login Required", "Please login to place order", backgroundColor: Colors.orange, colorText: Colors.white); return; }
    if (selectedAddress.value == null) { Get.snackbar("Address Missing", "Please select a delivery address", backgroundColor: Colors.redAccent, colorText: Colors.white); return; }
    if (selectedDate.value == null || selectedTime.value == null) { Get.snackbar("Schedule Missing", "Please select date and time", backgroundColor: Colors.redAccent, colorText: Colors.white); return; }

    isLoading.value = true;

    try {
      List<Map<String, dynamic>> itemsList = cartItems.map((item) {
        return { "service_id": item['id'] ?? item['raw']['id'], "quantity": item['quantity'], "price": item['priceInt'] };
      }).toList();

      Map<String, dynamic> orderData = {
        "user_id": userId.value, "contact_name": userName.value, "contact_phone": userPhone.value,
        "address_id": selectedAddress.value!.id, "full_address": selectedAddress.value!.addressLine,
        "schedule_date": formattedDate, "schedule_time": formattedTime,
        "total_amount": grandTotal, "payment_method": selectedPayment.value == "Digital Payment" ? "digital" : "cod",
        "payment_status": selectedPayment.value == "Digital Payment" ? "paid" : "unpaid",
        "items": itemsList, "platform": GetPlatform.isAndroid ? "android" : "ios", "order_note": ""
      };

      var response = await ApiService.placeOrder(orderData);

      if (response['status'] == 'success') {

        String orderId = response['booking_id']?.toString() ?? DateTime.now().millisecondsSinceEpoch.toString();
        // 🔥 পিক্সেল ইভেন্ট: অর্ডার সাকসেস (Purchase)
        PixelTracker.trackPurchase(orderId: orderId, amount: grandTotal);

        final prefs = await SharedPreferences.getInstance();
        await prefs.remove('user_cart_data');

        // টোটাল এমাউন্ট একটি ভেরিয়েবলে সেভ করে রাখা
        double finalPaidAmount = grandTotal;

        cartItems.clear();

        // 🔥 FIX: Success Page এ ডাটা আর্গুমেন্ট হিসেবে পাস করা হলো
        Get.offAll(() => const OrderSuccessView(), arguments: {
          'orderId': orderId,
          'totalAmount': finalPaidAmount
        });

      } else if (response['status'] == 'unauthorized') {
        Get.snackbar("Session Expired", "Please login again");
      } else {
        Get.snackbar("Failed", response['message'] ?? "Order failed");
      }
    } catch (e) {
      print("Order Error: $e");
      Get.snackbar("Error", "Something went wrong! Check connection.");
    } finally {
      isLoading.value = false;
    }
  }
}

