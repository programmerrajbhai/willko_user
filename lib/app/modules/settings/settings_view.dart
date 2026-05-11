import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../utils/app_colors.dart';
import 'settings_controller.dart';

// ========================================================
// 1. MAIN SETTINGS VIEW
// ========================================================
class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SettingsController());

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20, color: Colors.black87),
          onPressed: () => Get.back(),
        ),
        title: Text(
          "Settings",
          style: GoogleFonts.poppins(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 18),
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

            // --- Section 2: Support & Legal ---
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
                  onTap: () => Get.to(() => const PrivacyPolicyView()),
                ),
                Divider(height: 1, color: Colors.grey.shade100),

                // Terms and Conditions
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: Colors.grey.shade100, shape: BoxShape.circle),
                    child: const Icon(Icons.description_outlined, color: Colors.black54),
                  ),
                  title: Text("Terms & Conditions", style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
                  trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.grey),
                  onTap: () => Get.to(() => const TermsConditionsView()),
                ),
              ],
            ),

            const SizedBox(height: 40),

            // --- Version Info ---
            Center(
              child: Column(
                children: [
                  Text(
                    "Willko Service Platform",
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

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, left: 5),
      child: Text(
        title.toUpperCase(),
        style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey.shade600, letterSpacing: 1.2),
      ),
    );
  }

  Widget _buildSettingsContainer({required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.05), blurRadius: 15, offset: const Offset(0, 5))],
      ),
      child: Column(children: children),
    );
  }
}

// ========================================================
// 2. PRIVACY POLICY VIEW (Same File)
// ========================================================
class PrivacyPolicyView extends StatelessWidget {
  const PrivacyPolicyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black87),
          onPressed: () => Get.back(),
        ),
        title: Text("Privacy Policy", style: GoogleFonts.poppins(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 18)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Privacy Policy", style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text("Last updated: May 2026\n\nYour privacy is critically important to us. At Willko Service, we have a few fundamental principles:\n\n"
                "1. Information We Collect\nWe only collect information about you if we have a reason to do so, such as providing our services, communicating with you, or making our services better.\n\n"
                "2. How We Use Information\nWe use the information we collect to provide our services to you, to communicate with you, and to improve our platform. We never sell your personal data.\n\n"
                "3. Security\nWhile no online service is 100% secure, we work very hard to protect information about you against unauthorized access, use, alteration, or destruction.\n\n"
                "4. Changes to Policy\nWe may update this Privacy Policy from time to time. We will notify you of any changes by posting the new Privacy Policy on this page.",
              style: GoogleFonts.manrope(fontSize: 14, color: Colors.grey.shade800, height: 1.6),
            ),
          ],
        ),
      ),
    );
  }
}

// ========================================================
// 3. TERMS & CONDITIONS VIEW (Same File)
// ========================================================
class TermsConditionsView extends StatelessWidget {
  const TermsConditionsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black87),
          onPressed: () => Get.back(),
        ),
        title: Text("Terms & Conditions", style: GoogleFonts.poppins(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 18)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Terms & Conditions", style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text("Welcome to Willko Service!\n\nThese terms and conditions outline the rules and regulations for the use of our app and services.\n\n"
                "1. Acceptance of Terms\nBy accessing this app we assume you accept these terms and conditions. Do not continue to use Willko Service if you do not agree to take all of the terms and conditions stated on this page.\n\n"
                "2. Service Booking\nWhen booking a service through our platform, you agree to provide accurate information and ensure your availability at the scheduled time.\n\n"
                "3. Payments & Cancellations\nPayments are processed securely. Cancellations must be made within the allowed timeframe to avoid penalty charges.\n\n"
                "4. User Conduct\nUsers must treat service providers with respect. Any form of harassment or illegal activity will result in immediate account termination.",
              style: GoogleFonts.manrope(fontSize: 14, color: Colors.grey.shade800, height: 1.6),
            ),
          ],
        ),
      ),
    );
  }
}