import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart'; // 🔥 FontAwesome Import Kora Hoyeche
import 'package:willko_user/app/modules/home/widgets/app_footer.dart';
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
      endDrawer: const UrbanDrawer(),

      // 🔥 WhatsApp Floating Action Button (Original Icon & Qatar Number)
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // 💡 Qatar Country Code: 974 (Nicher jaygay apnar asol number ta din)
          // Udahoron: "97433123456"
          const String phoneNumber = "97433667970";
          const String message = "Hello Willko Services, I need some help.";

          final Uri whatsappUri = Uri.parse(
              "https://wa.me/$phoneNumber?text=${Uri.encodeComponent(message)}");

          try {
            if (await canLaunchUrl(whatsappUri)) {
              await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
            } else {
              Get.snackbar("Error", "Could not open WhatsApp. Make sure it's installed.",
                  backgroundColor: Colors.redAccent, colorText: Colors.white, snackPosition: SnackPosition.BOTTOM);
            }
          } catch (e) {
            Get.snackbar("Error", "Something went wrong!",
                backgroundColor: Colors.redAccent, colorText: Colors.white, snackPosition: SnackPosition.BOTTOM);
          }
        },
        backgroundColor: const Color(0xFF25D366), // Official WhatsApp Color
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
        child: const FaIcon(
            FontAwesomeIcons.whatsapp, // 🔥 Ekdom Hubohu WhatsApp Icon
            color: Colors.white,
            size: 32
        ),
      ),

      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// ================= HERO SECTION (Always Visible) =================
            UrbanHeroSection(),

            /// ================= SERVICES (Dynamic) =================
            const SizedBox(height: 60),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: ServicesChipsUC(controller: controller),
            ),

            /// ================= WHY SECTION =================
            const SizedBox(height: 60),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: WhySectionUC(controller: controller),
            ),

            /// ================= POPULAR SERVICES (Dynamic) =================
            const SizedBox(height: 60),

            // ✅✅ FOOTER ADDED HERE ✅✅
            const AppFooter(),
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