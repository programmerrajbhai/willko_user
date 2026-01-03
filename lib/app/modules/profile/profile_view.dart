import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../utils/app_colors.dart';
import '../booking/address/address_view.dart';
import '../settings/settings_view.dart';
import 'edit_profile_view.dart';
import 'profile_controller.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileController());

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,

        title: Text(
          "Profile",
          style: GoogleFonts.poppins(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator(color: AppColors.primary));
        }

        var userData = controller.user.value!;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              // --- 1. User Info Header ---
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.05), blurRadius: 15, offset: const Offset(0, 5))],
                ),
                child: Row(
                  children: [
                    // Avatar
                    Container(
                      height: 70,
                      width: 70,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.primary.withOpacity(0.2), width: 2),
                        image: const DecorationImage(
                          image: AssetImage("assets/images/user_avatar.png"), // আপনার ইমেজ পাথ দিন
                          fit: BoxFit.cover,
                        ),
                      ),
                      // ফেইলসেফ আইকন (যদি ইমেজ না থাকে)
                      child: const Icon(Icons.person, color: Colors.grey, size: 35),
                    ),
                    const SizedBox(width: 20),

                    // Text Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            userData.name,
                            style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            userData.email,
                            style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey.shade600),
                          ),
                          Text(
                            userData.phone,
                            style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey.shade600),
                          ),
                        ],
                      ),
                    ),

                    // Edit Icon
                    IconButton(
                      onPressed: () {
                        // Edit Profile Page Link
                        // Edit Profile Page Link
                        Get.to(() => const EditProfileView()); // ইমপোর্ট করে নিন
                      },
                      icon: const Icon(Icons.edit_outlined, color: AppColors.primary),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // --- 2. Menu Options ---

              // Section: Account
              _buildSectionTitle("Account Settings"),
              _buildMenuTile(
                icon: Icons.location_on_outlined,
                title: "Manage Addresses",
                onTap: () => Get.to(() => const AddressView()), // আমাদের তৈরি করা এড্রেস পেজে যাবে
              ),


              _buildMenuTile(
                icon: Icons.notifications_none_rounded,
                title: "Notifications",
                onTap: () {},
                trailing: Switch(
                    value: true,
                    onChanged: (val) {},
                    activeColor: AppColors.primary
                ),
              ),

              const SizedBox(height: 20),

              // Section: General
              _buildSectionTitle("General"),
              _buildMenuTile(
                icon: Icons.settings_outlined,
                title: "Settings",
                onTap: () => Get.to(() => const SettingsView()), // এখানে লিংক করা হয়েছে
              ),
              _buildMenuTile(
                icon: Icons.language_rounded,
                title: "Language",
                subtitle: "English (US)",
                onTap: () {},
              ),
              _buildMenuTile(
                icon: Icons.help_outline_rounded,
                title: "Help & Support",
                onTap: () {},
              ),
              _buildMenuTile(
                icon: Icons.privacy_tip_outlined,
                title: "Privacy Policy",
                onTap: () {},
              ),

              const SizedBox(height: 30),

              // --- 3. Logout Button ---
              Container(
                decoration: BoxDecoration(
                  color: Colors.redAccent.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ListTile(
                  onTap: controller.logout,
                  leading: const Icon(Icons.logout_rounded, color: Colors.redAccent),
                  title: Text(
                    "Logout",
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        color: Colors.redAccent,
                        fontSize: 15
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
              Text(
                "Version 1.0.0",
                style: GoogleFonts.poppins(color: Colors.grey.shade400, fontSize: 12),
              ),
              const SizedBox(height: 80), // Bottom padding for Navbar
            ],
          ),
        );
      }),
    );
  }

  // --- Helper Widgets ---

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15, left: 5),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade600,
            letterSpacing: 1,
          ),
        ),
      ),
    );
  }

  Widget _buildMenuTile({
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
    Widget? trailing,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.02), blurRadius: 5)],
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.08),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: AppColors.primary, size: 22),
        ),
        title: Text(
          title,
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 15),
        ),
        subtitle: subtitle != null ? Text(subtitle, style: GoogleFonts.poppins(fontSize: 12)) : null,
        trailing: trailing ?? const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.grey),
      ),
    );
  }
}