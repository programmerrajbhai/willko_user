import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:willko_user/utils/app_colors.dart';

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

                // 2. Links Section (Grid Layout)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _FooterLinkColumn(
                        title: "Company",
                        links: const ["About Us", "Terms & Conditions", "Privacy Policy", "Anti-discrimination Policy", "Careers"],
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: _FooterLinkColumn(
                        title: "For Customers",
                        links: const ["UC Reviews", "Categories", "Blog", "Contact Us", "Help Center"],
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 30),
                
                // 3. Social Media & Apps
                const Text(
                  "Follow Us",
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _SocialIcon(icon: Icons.facebook),
                    _SocialIcon(icon: Icons.camera_alt_outlined), // Instagram alternative
                    _SocialIcon(icon: Icons.alternate_email), // Twitter alternative
                    _SocialIcon(icon: Icons.video_library_rounded), // YouTube alternative
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
                  "© 2026 Willko Technologies India Pvt. Ltd.",
                  style: GoogleFonts.poppins(color: Colors.grey[600], fontSize: 12),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.location_on, color: Colors.grey, size: 14),
                    const SizedBox(width: 4),
                    Text(
                      "Bangladesh",
                      style: GoogleFonts.poppins(color: Colors.grey[400], fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
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
              child: const Center(child: Text("WC", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 20, color: Colors.black))),
            ),
            const SizedBox(width: 10),
            Text("Willko\nService", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white, height: 1)),
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

class _FooterLinkColumn extends StatelessWidget {
  final String title;
  final List<String> links;

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
          padding: const EdgeInsets.only(bottom: 10),
          child: InkWell(
            onTap: () {}, // ফাংশনালিটি পরে এড করা যাবে
            child: Text(
              link,
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
  const _SocialIcon({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      height: 40, width: 40,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Icon(icon, color: Colors.white, size: 20),
    );
  }
}