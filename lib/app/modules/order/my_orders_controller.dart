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

  Future<void> loadOrders() async {
    if (activeOrders.isEmpty && pastOrders.isEmpty) {
      isLoading.value = true;
    }

    var response = await ApiService.fetchMyBookings();

    if (response['status'] == 'success') {
      var data = response['data'];

      if (data['active'] != null && data['active'] is List) {
        activeOrders.assignAll((data['active'] as List).map((item) {
          return _mapOrderToUI(item as Map<String, dynamic>);
        }).toList());
      } else {
        activeOrders.clear();
      }

      if (data['history'] != null && data['history'] is List) {
        pastOrders.assignAll((data['history'] as List).map((item) {
          return _mapOrderToUI(item as Map<String, dynamic>);
        }).toList());
      } else {
        pastOrders.clear();
      }
    } else {
      print("Error loading orders: ${response['message']}");
    }

    isLoading.value = false;
  }

  Map<String, dynamic> _mapOrderToUI(Map<String, dynamic> apiItem) {
    String status = (apiItem['raw_status'] ?? apiItem['status'] ?? "").toString().toLowerCase();
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
        color = Colors.purple;
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

    // 🔥 FIX 3: Fetching Exact Price without fail
    String displayPrice = "QR 0.00";
    if (apiItem['raw_price'] != null) {
      displayPrice = "QR ${double.parse(apiItem['raw_price'].toString()).toStringAsFixed(2)}";
    } else if (apiItem['price'] != null) {
      displayPrice = apiItem['price'].toString().replaceAll("SAR", "QR");
    }

    return {
      "id": apiItem['id'],
      "display_id": apiItem['booking_id_str'] ?? "#ORD-${apiItem['id']}",
      "service": apiItem['service_name'] ?? "Service",
      "date": apiItem['date'] ?? "N/A",
      "time": apiItem['time'] ?? "N/A",
      "price": displayPrice,
      "status": apiItem['status'] ?? status.capitalizeFirst,
      "image": icon,
      "color": color
    };
  }
}