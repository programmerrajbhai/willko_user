import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsController extends GetxController {
  // সেটিংস ভেরিয়েবল
  var isDarkMode = false.obs;
  var isNotificationEnabled = true.obs;
  var selectedLanguage = "English".obs;

  // অ্যাপ ইনফো (স্ট্যাটিক ডাটা)
  final String appVersion = "1.0.0";
  final String supportPhone = "+8801712345678"; // আপনার সাপোর্ট নাম্বার

  // ১. থিম টগল করা
  void toggleTheme(bool val) {
    isDarkMode.value = val;
    Get.changeThemeMode(val ? ThemeMode.dark : ThemeMode.light);
    // রিয়েল অ্যাপে এখানে GetStorage বা SharedPreferences এ সেভ করতে হবে
  }

  // ২. নোটিফিকেশন টগল
  void toggleNotification(bool val) {
    isNotificationEnabled.value = val;
    // সার্ভারে সেটিং আপডেট করার API কল হবে এখানে
    if(val) {
      Get.snackbar("Notifications On", "You will receive updates now.");
    } else {
      Get.snackbar("Notifications Off", "You won't receive updates.");
    }
  }

  // ৩. ভাষা পরিবর্তন (Bottom Sheet)
  void changeLanguage() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        ),
        child: Wrap(
          children: [
            ListTile(
              leading: const Text("🇺🇸", style: TextStyle(fontSize: 20)),
              title: const Text("English"),
              trailing: selectedLanguage.value == "English" ? const Icon(Icons.check, color: Colors.blue) : null,
              onTap: () {
                selectedLanguage.value = "English";
                Get.updateLocale(const Locale('en', 'US'));
                Get.back();
              },
            ),
            ListTile(
              leading: const Text("🇧🇩", style: TextStyle(fontSize: 20)),
              title: const Text("বাংলা"),
              trailing: selectedLanguage.value == "বাংলা" ? const Icon(Icons.check, color: Colors.blue) : null,
              onTap: () {
                selectedLanguage.value = "বাংলা";
                Get.updateLocale(const Locale('bn', 'BD'));
                Get.back();
              },
            ),
          ],
        ),
      ),
    );
  }

  // ৪. সাপোর্টে কল করা
  void callSupport() async {
    final Uri url = Uri(scheme: 'tel', path: supportPhone);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      Get.snackbar("Error", "Could not launch dialer.");
    }
  }
}