import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:willko_user/app/data/services/api_service.dart';

class MyOrdersController extends GetxController {
  var activeOrders = <Map<String, dynamic>>[].obs;
  var pastOrders = <Map<String, dynamic>>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadOrders();
  }

  // ✅ Future<void> করা হয়েছে যাতে Pull-to-Refresh কাজ করে
  Future<void> loadOrders() async {
    // লোডিং শুধু প্রথমবার দেখাবে, রিফ্রেশ করার সময় লোডিং স্পিনার দেখাবে না (RefreshIndicator নিজেই স্পিনার দেখায়)
    if (activeOrders.isEmpty && pastOrders.isEmpty) {
      isLoading.value = true;
    }
    
    var response = await ApiService.fetchMyBookings();

    if (response['status'] == 'success') {
      var data = response['data'];
      
      // Active Orders Mapping
      if (data['active'] != null) {
        activeOrders.assignAll(List<Map<String, dynamic>>.from(data['active'].map((item) {
          return _mapOrderToUI(item);
        })));
      } else {
        activeOrders.clear();
      }

      // History Orders Mapping
      if (data['history'] != null) {
        pastOrders.assignAll(List<Map<String, dynamic>>.from(data['history'].map((item) {
          return _mapOrderToUI(item);
        })));
      } else {
        pastOrders.clear();
      }
    } else {
      print("Error loading orders: ${response['message']}");
    }

    isLoading.value = false;
  }

  Map<String, dynamic> _mapOrderToUI(Map<String, dynamic> apiItem) {
    String status = (apiItem['raw_status'] ?? "").toString().toLowerCase();
    Color color;
    IconData icon;

    switch (status) {
      case 'pending':
        color = Colors.orange;
        icon = Icons.hourglass_top_rounded;
        break;
      case 'confirmed':
        color = Colors.blue;
        icon = Icons.thumb_up_alt_rounded;
        break;
      case 'assigned':
      case 'on_way':
      case 'started':
        color = Colors.purple; // কাজ শুরু হলে বেগুনি
        icon = Icons.motorcycle_rounded;
        break;
      case 'completed':
        color = Colors.green;
        icon = Icons.check_circle_rounded;
        break;
      case 'cancelled':
        color = Colors.red;
        icon = Icons.cancel_rounded;
        break;
      default:
        color = Colors.grey;
        icon = Icons.bookmark_border_rounded;
    }

    return {
      "id": apiItem['id'],
      "display_id": apiItem['booking_id_str'],
      "service": apiItem['service_name'],
      "date": apiItem['date'],
      "time": apiItem['time'],
      "price": apiItem['price'],
      "status": apiItem['status'],
      "image": icon,
      "color": color
    };
  }
}