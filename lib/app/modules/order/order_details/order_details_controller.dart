import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class OrderDetailsController extends GetxController {
  // ... আগের ভেরিয়েবলগুলো (orderDetails, isLoading) ...
  var orderDetails = {}.obs;
  var isLoading = true.obs;

  // ক্যানসেল রিজন লেখার জন্য কন্ট্রোলার
  final cancelReasonController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    // ডামি ডাটা লোড (আগের কোডই থাকবে)
    if (Get.arguments != null) {
      loadOrderDetails(Get.arguments);
    } else {
      loadOrderDetails("#ORD-2026");
    }
  }

  void loadOrderDetails(String orderId) async {
    // ... আগের লোডিং লজিক ...
    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 1));

    // ডামি ডাটা (শুধু স্ট্যাটাস আপডেটের জন্য রিঅ্যাক্টিভ ম্যাপ দরকার)
    orderDetails.value = {
      "id": orderId,
      "service_name": "AC Service (Split)",
      "price": "৳850",
      "status": "In Progress", // প্রাথমিক স্ট্যাটাস
      "date": "05 Jan, 2026",
      "time": "10:00 AM",
      "address": "House 12, Road 5, Block C, Mirpur 10, Dhaka",
      "payment_method": "Cash on Delivery",
      "provider": {
        "name": "Karim Uddin",
        "phone": "+8801712345678",
        "rating": "4.8",
        "image": "assets/images/provider.png",
        "jobs_done": "120+"
      },
      "timeline": [
        {"title": "Booking Placed", "time": "9:00 AM", "isCompleted": true},
        {"title": "Provider Assigned", "time": "9:30 AM", "isCompleted": true},
        {"title": "Service Started", "time": "10:05 AM", "isCompleted": true},
        {"title": "Service Completed", "time": "-", "isCompleted": false},
      ]
    };
    isLoading.value = false;
  }

  void callProvider() {
    // ... কল লজিক ...
  }

  // --- নতুন: অর্ডার ক্যানসেল লজিক উইথ পপআপ ---
  void cancelOrder() {
    cancelReasonController.clear(); // আগের লেখা মুছে ফেলা

    Get.defaultDialog(
      title: "Cancel Booking?",
      titleStyle: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 18),
      contentPadding: const EdgeInsets.all(20),
      content: Column(
        children: [
          Text(
            "Are you sure you want to cancel this service? Please tell us the reason.",
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(color: Colors.grey, fontSize: 13),
          ),
          const SizedBox(height: 15),

          // Reason Input Field
          TextField(
            controller: cancelReasonController,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: "Reason (e.g. Changed my mind)",
              hintStyle: GoogleFonts.poppins(fontSize: 12, color: Colors.grey.shade400),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              contentPadding: const EdgeInsets.all(12),
            ),
          ),
        ],
      ),
      // Buttons
      textConfirm: "Cancel Booking",
      textCancel: "Don't Cancel",
      confirmTextColor: Colors.white,
      buttonColor: Colors.redAccent,
      cancelTextColor: Colors.black87,
      onConfirm: () {
        if (cancelReasonController.text.isEmpty) {
          Get.snackbar("Required", "Please provide a reason", snackPosition: SnackPosition.BOTTOM);
          return;
        }
        _processCancellation();
      },
    );
  }

  void _processCancellation() async {
    Get.back(); // ডায়ালগ বন্ধ করা

    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 2)); // ফেক API কল

    // লোকাল ডাটা আপডেট (স্ট্যাটাস চেঞ্জ)
    var updatedData = Map<String, dynamic>.from(orderDetails);
    updatedData['status'] = "Cancelled";
    orderDetails.value = updatedData;

    isLoading.value = false;

    Get.snackbar(
        "Cancelled",
        "Order cancelled successfully.",
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM
    );
  }
}