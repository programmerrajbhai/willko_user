import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:willko_user/app/data/services/api_service.dart';

class OrderDetailsController extends GetxController {
  var orderDetails = {}.obs;
  var isLoading = true.obs;
  final cancelReasonController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    // আর্গুমেন্ট থেকে অর্ডার আইডি নেওয়া
    var args = Get.arguments;
    if (args != null) {
      fetchOrderDetails(args.toString());
    } else {
      Get.snackbar("Error", "Invalid Order ID");
      isLoading.value = false;
    }
  }

  void fetchOrderDetails(String orderId) async {
    isLoading.value = true;
    
    var response = await ApiService.fetchOrderDetails(orderId);

    if (response['status'] == 'success') {
      var data = response['data'];
      var info = data['order_info'];
      var price = data['price_details'];
      var address = data['address'];
      var provider = data['provider']; // এটি null হতে পারে
      var items = data['items'] as List;

      // --- ডাটা ম্যাপ করা ---
      orderDetails.value = {
        "id": "#ORD-${info['id'].toString().padLeft(4, '0')}", 
        "real_id": info['id'], 
        // একাধিক সার্ভিস থাকলে প্রথমটা + more দেখাবে
        "service_name": items.isNotEmpty 
            ? "${items[0]['service_name']}${items.length > 1 ? ' & ${items.length - 1} more' : ''}" 
            : "Service",
        "status": _capitalize(info['status']),
        "date": info['schedule_date'],
        "time": info['schedule_time'],
        "address": address['details'] ?? "Address not found",
        "payment_method": info['payment_method'].toString().toUpperCase(),
        "price": "SAR ${price['final_total']}",
        // প্রোভাইডার হ্যান্ডলিং
        "provider": provider != null ? {
          "name": provider['name'],
          "phone": provider['phone'],
          "rating": provider['rating'] ?? "New",
          "image": provider['image'] ?? "", 
          "jobs_done": "Verified" 
        } : null,
        // টাইমলাইন জেনারেশন
        "timeline": _generateTimeline(info['status'], info['schedule_time'])
      };

    } else {
      Get.snackbar("Error", response['message'] ?? "Failed to load details");
    }

    isLoading.value = false;
  }

  // --- Helper: Generate Timeline based on Status ---
  List<Map<String, dynamic>> _generateTimeline(String status, String time) {
    status = status.toLowerCase();
    
    // Status Logic
    bool isPlaced = true; // প্লেসড সবসময় সত্য
    bool isAssigned = ['assigned', 'on_way', 'started', 'completed'].contains(status);
    bool isStarted = ['started', 'completed'].contains(status);
    bool isCompleted = status == 'completed';

    return [
      {"title": "Booking Placed", "time": "Done", "isCompleted": isPlaced},
      {"title": "Provider Assigned", "time": isAssigned ? "Done" : "-", "isCompleted": isAssigned},
      {"title": "Service Started", "time": isStarted ? "Done" : "-", "isCompleted": isStarted},
      {"title": "Service Completed", "time": isCompleted ? "Done" : "-", "isCompleted": isCompleted},
    ];
  }

  // --- Helper: Capitalize String ---
  String _capitalize(String s) => s.isNotEmpty ? s[0].toUpperCase() + s.substring(1) : "";

  // --- Call Provider ---
  void callProvider(String phone) async {
    final Uri url = Uri.parse("tel:$phone");
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      Get.snackbar("Error", "Could not launch dialer");
    }
  }

  // --- Cancel Order Logic ---
  void cancelOrder() {
    cancelReasonController.clear();
    Get.defaultDialog(
      title: "Cancel Booking?",
      titleStyle: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 18),
      contentPadding: const EdgeInsets.all(20),
      radius: 16,
      content: Column(
        children: [
          Text("Are you sure? This action cannot be undone.", textAlign: TextAlign.center, style: GoogleFonts.poppins(color: Colors.grey, fontSize: 13)),
          const SizedBox(height: 15),
          TextField(
            controller: cancelReasonController,
            maxLines: 2,
            decoration: InputDecoration(
              hintText: "Reason (Optional)",
              hintStyle: GoogleFonts.poppins(fontSize: 12, color: Colors.grey.shade400),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              contentPadding: const EdgeInsets.all(12),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Get.back(), child: const Text("Keep it")),
        ElevatedButton(
          onPressed: _processCancellation,
          style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
          child: const Text("Yes, Cancel", style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }

  void _processCancellation() async {
    Get.back(); 
    isLoading.value = true;
    
    // TODO: এখানে ভবিষ্যতে রিয়েল API কল বসবে
    await Future.delayed(const Duration(seconds: 1)); 

    // লোকাল আপডেট (UI তে চেঞ্জ দেখানোর জন্য)
    var updatedData = Map<String, dynamic>.from(orderDetails);
    updatedData['status'] = "Cancelled";
    orderDetails.value = updatedData;

    isLoading.value = false;
    Get.snackbar("Cancelled", "Order cancelled successfully.", backgroundColor: Colors.redAccent, colorText: Colors.white);
  }
}