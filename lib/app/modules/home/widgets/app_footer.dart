import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class AppFooter extends StatelessWidget {
  const AppFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: const Color(0xFF111111), // সুপার ডার্ক ব্যাকগ্রাউন্ড (Pro Look)
      child: Column(
        children: [
          // 🔵 Main Footer Content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Logo & Short Description
                const _FooterBrand(),
                const SizedBox(height: 30),

                // 2. Links Section (Play Store Essentials)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _FooterLinkColumn(
                        title: "Company",
                        links: [
                          _LinkItem("About Us", () => Get.to(() => const CustomPageView(title: "About Us"))),
                          _LinkItem("Contact Us", () => Get.to(() => const CustomPageView(title: "Contact Us"))),
                        ],
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: _FooterLinkColumn(
                        title: "Legal",
                        links: [
                          _LinkItem("Privacy Policy", () => Get.to(() => const CustomPageView(title: "Privacy Policy"))),
                          _LinkItem("Terms & Conditions", () => Get.to(() => const CustomPageView(title: "Terms & Conditions"))),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                // 3. Social Media
                const Text(
                  "Follow Us",
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _SocialIcon(icon: Icons.facebook, onTap: () => _showToast("Facebook")),
                    _SocialIcon(icon: Icons.camera_alt_outlined, onTap: () => _showToast("Instagram")),
                    _SocialIcon(icon: Icons.video_library_rounded, onTap: () => _showToast("YouTube")),
                  ],
                ),
              ],
            ),
          ),

          // ➖ Divider
          Divider(color: Colors.white.withOpacity(0.1), height: 1),

          // 🔵 Bottom Copyright Bar
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            color: const Color(0xFF000000), // Slightly darker for bottom bar
            child: Column(
              children: [
                Text(
                  "© 2026 Willko Service. All rights reserved.",
                  style: GoogleFonts.poppins(color: Colors.grey[600], fontSize: 12),
                  textAlign: TextAlign.center,
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showToast(String platform) {
    Get.snackbar(
      "Social Link",
      "Redirecting to $platform...",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.black87,
      colorText: Colors.white,
      margin: const EdgeInsets.all(20),
      borderRadius: 10,
    );
  }
}

// --- SUB WIDGETS ---

class _FooterBrand extends StatelessWidget {
  const _FooterBrand();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Logo
        Row(
          children: [
            Container(
              height: 36, width: 36,
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
              child: const Center(child: Text("W", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 20, color: Colors.black))),
            ),
            const SizedBox(width: 10),
            Text("WILLKO", style: GoogleFonts.montserrat(fontWeight: FontWeight.w800, fontSize: 18, color: Colors.white, letterSpacing: 1.2)),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          "Your trusted partner for home services. Quality, reliability, and safety guaranteed.",
          style: GoogleFonts.poppins(color: Colors.grey[500], fontSize: 13, height: 1.6),
        ),
      ],
    );
  }
}

class _LinkItem {
  final String title;
  final VoidCallback onTap;
  _LinkItem(this.title, this.onTap);
}

class _FooterLinkColumn extends StatelessWidget {
  final String title;
  final List<_LinkItem> links;

  const _FooterLinkColumn({required this.title, required this.links});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        ...links.map((link) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: InkWell(
            onTap: link.onTap, // ✅ Added Click Action
            child: Text(
              link.title,
              style: GoogleFonts.poppins(color: Colors.grey[400], fontSize: 13),
            ),
          ),
        )),
      ],
    );
  }
}

class _SocialIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _SocialIcon({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        height: 40, width: 40,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withOpacity(0.1)),
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }
}

// =======================================================
// 🚀 DUMMY PAGE TO HANDLE CLICKS (Later replace with real API Data)
// =======================================================
class CustomPageView extends StatelessWidget {
  final String title;
  const CustomPageView({required this.title, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(title, style: GoogleFonts.poppins(color: Colors.black, fontWeight: FontWeight.w600)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.playfairDisplay(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(
              "This is the official $title page for Willko Service. Content for this section will be fetched from the backend or added statically before publishing to the Play Store.\n\n"
                  "We prioritize user safety and data security. Please read our guidelines carefully.",
              style: GoogleFonts.poppins(fontSize: 15, color: Colors.grey[700], height: 1.6),
            ),
          ],
        ),
      ),
    );
  }
}