import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../utils/app_colors.dart';
import 'settings_controller.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SettingsController());

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC), // প্রিমিয়াম গ্রে ব্যাকগ্রাউন্ড
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20, color: Colors.black87),
          onPressed: () => Get.back(),
        ),
        title: Text(
          "Settings",
          style: GoogleFonts.poppins(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Section 1: General ---
            _buildSectionHeader("General"),

            _buildSettingsContainer(
              children: [
                // Language
                Obx(() => ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: Colors.blue.shade50, shape: BoxShape.circle),
                    child: const Icon(Icons.language, color: Colors.blue),
                  ),
                  title: Text("Language", style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
                  subtitle: Text(controller.selectedLanguage.value, style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey)),
                  trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.grey),
                  onTap: controller.changeLanguage,
                )),
                Divider(height: 1, color: Colors.grey.shade100),

                // Dark Mode
                Obx(() => SwitchListTile(
                  secondary: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: Colors.purple.shade50, shape: BoxShape.circle),
                    child: const Icon(Icons.dark_mode_outlined, color: Colors.purple),
                  ),
                  title: Text("Dark Mode", style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
                  value: controller.isDarkMode.value,
                  onChanged: controller.toggleTheme,
                  activeColor: AppColors.primary,
                )),
                Divider(height: 1, color: Colors.grey.shade100),

                // Notifications
                Obx(() => SwitchListTile(
                  secondary: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: Colors.orange.shade50, shape: BoxShape.circle),
                    child: const Icon(Icons.notifications_active_outlined, color: Colors.orange),
                  ),
                  title: Text("Notifications", style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
                  value: controller.isNotificationEnabled.value,
                  onChanged: controller.toggleNotification,
                  activeColor: AppColors.primary,
                )),
              ],
            ),
            const SizedBox(height: 25),

            // --- Section 2: Support ---
            _buildSectionHeader("Support & Legal"),

            _buildSettingsContainer(
              children: [
                // Contact Support
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: Colors.green.shade50, shape: BoxShape.circle),
                    child: const Icon(Icons.headset_mic_outlined, color: Colors.green),
                  ),
                  title: Text("Contact Support", style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
                  subtitle: Text("Call us at ${controller.supportPhone}", style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey)),
                  trailing: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(color: Color(0xFFE8F5E9), shape: BoxShape.circle),
                    child: const Icon(Icons.phone, size: 18, color: Colors.green),
                  ),
                  onTap: controller.callSupport,
                ),
                Divider(height: 1, color: Colors.grey.shade100),

                // Privacy Policy
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: Colors.grey.shade100, shape: BoxShape.circle),
                    child: const Icon(Icons.privacy_tip_outlined, color: Colors.black54),
                  ),
                  title: Text("Privacy Policy", style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
                  trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.grey),
                  onTap: () {}, // Open WebView
                ),
                Divider(height: 1, color: Colors.grey.shade100),

                // Terms
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: Colors.grey.shade100, shape: BoxShape.circle),
                    child: const Icon(Icons.description_outlined, color: Colors.black54),
                  ),
                  title: Text("Terms & Conditions", style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
                  trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.grey),
                  onTap: () {},
                ),
              ],
            ),

            const SizedBox(height: 40),

            // --- Version Info ---
            Center(
              child: Column(
                children: [
                  Text(
                    "Urban Service App",
                    style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.grey.shade500),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "Version ${controller.appVersion}",
                    style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey.shade400),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // --- Helper Widgets ---

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, left: 5),
      child: Text(
        title.toUpperCase(),
        style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade600,
            letterSpacing: 1.2
        ),
      ),
    );
  }

  Widget _buildSettingsContainer({required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.withOpacity(0.05),
              blurRadius: 15,
              offset: const Offset(0, 5)
          )
        ],
      ),
      child: Column(children: children),
    );
  }
}