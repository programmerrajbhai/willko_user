import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsController extends GetxController {
  // Settings variables
  var isNotificationEnabled = true.obs;

  // App Info (Static Data)
  final String appVersion = "1.0.0";
  final String supportPhone = "+8801712345678"; // Apnar ashol support number din

  // 1. Notification Toggle
  void toggleNotification(bool val) {
    isNotificationEnabled.value = val;
    if(val) {
      Get.snackbar("Notifications On", "You will receive updates now.", snackPosition: SnackPosition.BOTTOM);
    } else {
      Get.snackbar("Notifications Off", "You won't receive updates.", snackPosition: SnackPosition.BOTTOM);
    }
  }

  // 2. Call Support
  void callSupport() async {
    final Uri url = Uri(scheme: 'tel', path: supportPhone);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      Get.snackbar("Error", "Could not launch dialer.", snackPosition: SnackPosition.BOTTOM);
    }
  }
}