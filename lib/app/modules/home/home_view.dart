import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'home_controller.dart';

// Widgets
import 'widgets/hero_section.dart';
import 'widgets/why_section.dart';
import 'widgets/services_section.dart';
import 'widgets/popular_services_section.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());

    return Scaffold(
      backgroundColor: Colors.white,
      // ❌ আগে এখানে Obx দিয়ে লোডিং চেক ছিল, সেটা বাদ দেওয়া হয়েছে।
      // ✅ এখন সরাসরি UI বিল্ড হবে।
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// ================= HERO SECTION (Always Visible) =================
            // এটি স্ট্যাটিক, তাই সাথে সাথেই দেখা যাবে
            UrbanHeroSection(
              selectedCityText: controller.selectedCity.value,
              onPickCity: () => _showCityPicker(controller),
            ),

            /// ================= WHY SECTION =================
            const SizedBox(height: 60),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: WhySectionUC(controller: controller),
            ),

            /// ================= SERVICES (Dynamic) =================
            const SizedBox(height: 60),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: ServicesChipsUC(controller: controller),
            ),

            /// ================= POPULAR SERVICES (Dynamic) =================
            const SizedBox(height: 60),
            PopularServicesSection(controller: controller),

            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  void _showCityPicker(HomeController controller) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: controller.cities
              .map((c) => ListTile(
                    title: Text(c),
                    onTap: () {
                      controller.pickCity(c);
                      Get.back();
                    },
                  ))
              .toList(),
        ),
      ),
    );
  }
}