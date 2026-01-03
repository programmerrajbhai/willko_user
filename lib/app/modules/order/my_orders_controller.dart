import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyOrdersController extends GetxController {
  var activeOrders = <Map<String, dynamic>>[].obs;
  var pastOrders = <Map<String, dynamic>>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadOrders();
  }

  void loadOrders() async {
    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 1)); // ফেক লোডিং

    // ১. Active Orders (চলমান বা শিডিউল করা)
    activeOrders.addAll([
      {
        "id": "#ORD-2026",
        "service": "AC Service (Split)",
        "date": "05 Jan, 2026",
        "time": "10:00 AM",
        "price": "৳800",
        "status": "Scheduled",
        "image": Icons.ac_unit_rounded,
        "color": Colors.blue
      },
      {
        "id": "#ORD-2027",
        "service": "Sofa Cleaning",
        "date": "06 Jan, 2026",
        "time": "03:00 PM",
        "price": "৳1200",
        "status": "In Progress",
        "image": Icons.chair_rounded,
        "color": Colors.orange
      }
    ]);

    // ২. Past Orders (সম্পন্ন বা বাতিল)
    pastOrders.addAll([
      {
        "id": "#ORD-1098",
        "service": "Full Home Cleaning",
        "date": "20 Dec, 2025",
        "time": "09:00 AM",
        "price": "৳3000",
        "status": "Completed",
        "image": Icons.home_work_rounded,
        "color": Colors.green
      },
      {
        "id": "#ORD-1055",
        "service": "Haircut for Men",
        "date": "15 Dec, 2025",
        "time": "06:00 PM",
        "price": "৳300",
        "status": "Cancelled",
        "image": Icons.content_cut_rounded,
        "color": Colors.red
      }
    ]);

    isLoading.value = false;
  }
}