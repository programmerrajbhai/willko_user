import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
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
                // Contact Support (Updated with Bottom Sheet)
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: Colors.green.shade50, shape: BoxShape.circle),
                    child: const Icon(Icons.headset_mic_outlined, color: Colors.green),
                  ),
                  title: Text("Contact Support", style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
                  subtitle: Text("WhatsApp: 3366 7970", style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey)),
                  trailing: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(color: Color(0xFFE8F5E9), shape: BoxShape.circle),
                    child: const Icon(Icons.support_agent, size: 18, color: Colors.green),
                  ),
                  onTap: () => _showSupportBottomSheet(context, "33667970"),
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

  // ========================================================
  // 🔥 BOTTOM SHEET FOR SUPPORT OPTIONS
  // ========================================================
  void _showSupportBottomSheet(BuildContext context, String phoneNumber) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(10))),
              const SizedBox(height: 20),
              Text("Contact Support", style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
              const SizedBox(height: 8),
              Text("How would you like to reach us?", style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey.shade600)),
              const SizedBox(height: 24),

              // 1. WhatsApp Action
              _supportActionCard(
                icon: Icons.chat_outlined,
                color: const Color(0xFF25D366),
                title: "Message on WhatsApp",
                onTap: () async {
                  Get.back();
                  final Uri url = Uri.parse("https://wa.me/$phoneNumber");
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url, mode: LaunchMode.externalApplication);
                  } else {
                    Get.snackbar("Error", "Could not open WhatsApp", snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
                  }
                },
              ),
              const SizedBox(height: 12),

              // 2. Call Action
              _supportActionCard(
                icon: Icons.phone_outlined,
                color: Colors.blue,
                title: "Call Direct",
                onTap: () async {
                  Get.back();
                  final Uri url = Uri.parse("tel:$phoneNumber");
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url);
                  } else {
                    Get.snackbar("Error", "Could not open dialer", snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
                  }
                },
              ),
              const SizedBox(height: 12),

              // 3. Copy Number Action
              _supportActionCard(
                icon: Icons.copy_rounded,
                color: Colors.grey.shade700,
                title: "Copy Number",
                onTap: () {
                  Get.back();
                  Clipboard.setData(ClipboardData(text: phoneNumber));
                  Get.snackbar(
                    "Copied!",
                    "Support number $phoneNumber copied to clipboard.",
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.green.shade600,
                    colorText: Colors.white,
                    margin: const EdgeInsets.all(16),
                    icon: const Icon(Icons.check_circle, color: Colors.white),
                  );
                },
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  Widget _supportActionCard({required IconData icon, required Color color, required String title, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(width: 16),
            Text(title, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: color)),
            const Spacer(),
            Icon(Icons.arrow_forward_ios_rounded, color: color.withOpacity(0.5), size: 14),
          ],
        ),
      ),
    );
  }
}

// ========================================================
// 2. PRIVACY POLICY VIEW
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
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black87), onPressed: () => Get.back()),
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
// 3. TERMS & CONDITIONS VIEW
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
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black87), onPressed: () => Get.back()),
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