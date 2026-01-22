import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Import your views and models
import 'package:willko_user/app/modules/auth/login/login_view.dart'; 
import '../../../data/model/address_model.dart';
import '../../../data/services/api_service.dart';
import '../address/address_view.dart';
import '../success/order_success_view.dart';

class CheckoutController extends GetxController {
  // ================= DATA VARIABLES =================
  
  // --- Cart Data ---
  var cartItems = <Map<String, dynamic>>[].obs;
  
  // Calculations
  double get itemTotal => cartItems.fold(0, (sum, item) => sum + (double.parse(item['priceInt'].toString()) * int.parse(item['quantity'].toString())));
  double get taxAndFees => itemTotal * 0.05; // 5% Tax
  double get grandTotal => itemTotal + taxAndFees;

  // --- User State ---
  var isLoggedIn = false.obs;
  var userName = "Guest".obs;
  var userPhone = "".obs;
  var userImage = "".obs; 

  // --- Order Inputs ---
  var selectedAddress = Rxn<AddressModel>();
  var selectedDate = Rxn<DateTime>();
  var selectedTime = Rxn<TimeOfDay>();
  var selectedPayment = "Cash on Delivery".obs;
  var isLoading = false.obs;

  // --- Formatters for UI ---
  String get formattedDate => selectedDate.value == null 
      ? "Select Date" 
      : DateFormat("EEE, dd MMM yyyy").format(selectedDate.value!);

  String get formattedTime => selectedTime.value == null 
      ? "Select Time" 
      : selectedTime.value!.format(Get.context!);

  // ================= INITIALIZATION =================
  @override
  void onInit() {
    super.onInit();
    _checkLoginStatus(); // Check if user is already logged in
    
    // Receive Cart Data from previous screen
    if (Get.arguments != null && Get.arguments is Map) {
      final args = Get.arguments as Map;
      if (args.containsKey('cart')) {
        cartItems.value = List<Map<String, dynamic>>.from(args['cart']);
      }
    }
  }

  // ================= LOGIN LOGIC =================

  // ✅ 1. Check Login Status from Shared Preferences
  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    
    if (token != null && token.isNotEmpty) {
      isLoggedIn.value = true;
      userName.value = prefs.getString('user_name') ?? "User";
      userPhone.value = prefs.getString('user_phone') ?? "";
      userImage.value = prefs.getString('user_image') ?? ""; 
    } else {
      isLoggedIn.value = false;
      userName.value = "Guest";
      userPhone.value = "";
      userImage.value = "";
    }
  }

  // ✅ 2. Handle Place Order (Smart Login Check)
  void handlePlaceOrder() {
    if (!isLoggedIn.value) {
      // If not logged in, show dialog
      Get.defaultDialog(
        title: "Login Required",
        middleText: "You need to login to confirm your order.",
        textConfirm: "Login Now",
        textCancel: "Cancel",
        confirmTextColor: Colors.white,
        buttonColor: Colors.black,
        onConfirm: () async {
          Get.back(); // Close Dialog
          
          // Navigate to Login Page and wait for result
          // Passing 'fromCheckout': true so LoginController knows to return here
          var success = await Get.to(() => const LoginView(), arguments: {'fromCheckout': true});
          
          // If login was successful, refresh user data immediately
          if (success == true) {
            await _checkLoginStatus();
          }
        }
      );
    } else {
      // If already logged in, proceed to place order
      _placeOrderApiCall();
    }
  }

  // ================= API CALL =================

  // ✅ 3. Place Order API Call
  Future<void> _placeOrderApiCall() async {
    HapticFeedback.heavyImpact();

    // Validations
    if (cartItems.isEmpty) return;
    if (selectedAddress.value == null) { 
      _snack("Location Missing", "Please select a delivery address."); 
      return; 
    }
    if (selectedDate.value == null || selectedTime.value == null) { 
      _snack("Schedule Missing", "Please select date & time."); 
      return; 
    }

    isLoading.value = true;

    // Prepare Data for API
    String apiDate = DateFormat('yyyy-MM-dd').format(selectedDate.value!);
    
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, selectedTime.value!.hour, selectedTime.value!.minute);
    String apiTime = DateFormat('HH:mm').format(dt);

    List<Map<String, dynamic>> itemsPayload = cartItems.map((item) => {
      "service_id": item['raw']['id'], 
      "quantity": item['quantity']
    }).toList();

    // Payload
    Map<String, dynamic> payload = {
      "address_id": selectedAddress.value!.id,
      "schedule_date": apiDate,
      "schedule_time": apiTime,
      "items": itemsPayload,
      "payment_method": selectedPayment.value == "Cash on Delivery" ? "cod" : "digital",
      "contact_name": userName.value,
      "contact_phone": userPhone.value
    };

    // Call Service
    var response = await ApiService.placeOrder(payload);

    isLoading.value = false;

    if (response['status'] == 'success') {
      // Success
      Get.offAll(() => const OrderSuccessView());
    } else if (response['status'] == 'unauthorized') {
       // Token Expired
       _snack("Session Expired", "Please login again.");
       isLoggedIn.value = false;
    } else {
      // Error
      _snack("Order Failed", response['message'] ?? "Something went wrong");
    }
  }

  void _snack(String title, String msg) {
    Get.snackbar(
      title, msg, 
      backgroundColor: Colors.redAccent, 
      colorText: Colors.white, 
      snackPosition: SnackPosition.BOTTOM, 
      margin: const EdgeInsets.all(20),
      borderRadius: 10
    );
  }

  // ================= UI ACTIONS =================

  void incrementQty(int index) { 
    HapticFeedback.selectionClick();
    var item = cartItems[index]; 
    item['quantity'] = (item['quantity'] as int) + 1; 
    cartItems[index] = item; 
    cartItems.refresh(); 
  }
  
  void decrementQty(int index) { 
    HapticFeedback.selectionClick();
    var item = cartItems[index]; 
    int qty = item['quantity'] as int; 
    
    if (qty > 1) { 
      item['quantity'] = qty - 1; 
      cartItems[index] = item; 
    } else { 
      cartItems.removeAt(index); 
    } 
    cartItems.refresh(); 
    
    if(cartItems.isEmpty) {
      Get.back(); // Go back if cart is empty
    }
  }
  
  void pickAddress() async {
    HapticFeedback.lightImpact(); 
    var result = await Get.to(() => const AddressView());
    if (result != null && result is AddressModel) {
      selectedAddress.value = result;
    }
  }

  Future<void> chooseDate(BuildContext context) async {
    HapticFeedback.selectionClick();
    final DateTime? picked = await showDatePicker(
      context: context, 
      initialDate: DateTime.now(), 
      firstDate: DateTime.now(), 
      lastDate: DateTime.now().add(const Duration(days: 30)), 
      builder: (context, child) => Theme(
        data: ThemeData.light().copyWith(
          primaryColor: const Color(0xFF6C45E5), 
          colorScheme: const ColorScheme.light(primary: Color(0xFF6C45E5))
        ), 
        child: child!
      )
    );
    if (picked != null) selectedDate.value = picked;
  }

  Future<void> chooseTime(BuildContext context) async {
    HapticFeedback.selectionClick();
    final TimeOfDay? picked = await showTimePicker(
      context: context, 
      initialTime: TimeOfDay.now(), 
      builder: (context, child) => Theme(
        data: ThemeData.light().copyWith(
          colorScheme: const ColorScheme.light(primary: Color(0xFF6C45E5))
        ), 
        child: child!
      )
    );
    if (picked != null) selectedTime.value = picked;
  }

  void selectPaymentMethod(String method) {
    HapticFeedback.selectionClick();
    selectedPayment.value = method;
  }
}