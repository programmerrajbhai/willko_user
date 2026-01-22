import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:willko_user/app/modules/order/my_orders_view.dart';
import 'package:willko_user/utils/app_colors.dart';
import '../booking/address/address_view.dart';
import '../settings/settings_view.dart';
import 'edit_profile_view.dart';
import 'profile_controller.dart';
import 'widgets/order_status_card.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    // কন্ট্রোলার চেক বা ইনিশিয়ালাইজ
    final controller = Get.isRegistered<ProfileController>() 
        ? Get.find<ProfileController>() 
        : Get.put(ProfileController());

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F9), 
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "Profile",
          style: GoogleFonts.poppins(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20, color: Colors.black),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator(color: AppColors.primary));
        }

        var userData = controller.user.value!;

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              // --- 1. User Profile Card ---
              Container(
                padding: const EdgeInsets.all(20),
                decoration: _cardDecoration(),
                child: Row(
                  children: [
                    Stack(
                      children: [
                        Container(
                          height: 80, width: 80,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.primary, width: 2),
                            image: DecorationImage(
                              image: (userData.image != null && userData.image!.isNotEmpty)
                                  ? NetworkImage(userData.image!) as ImageProvider 
                                  : const AssetImage("assets/images/service_man.jpg"),
                              fit: BoxFit.cover,
                              onError: (exception, stackTrace) {}, // Error Handler
                            ),
                          ),
                        ),
                        // Edit Button
                        Positioned(
                          bottom: 0, right: 0,
                          child: InkWell(
                            onTap: () => Get.to(() => const EditProfileView()),
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                              child: const Icon(Icons.edit, color: Colors.white, size: 14),
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(userData.name, style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)),
                          
                          // ফোন বা ইমেইল যেটা আছে সেটা দেখাবে
                          Text(
                            userData.phone.isNotEmpty ? userData.phone : userData.email, 
                            style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey[600])
                          ),
                          
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(color: Colors.green.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
                            child: Text("Verified Member", style: GoogleFonts.poppins(fontSize: 10, color: Colors.green, fontWeight: FontWeight.bold)),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // --- 2. Order & Booking Stats (Dynamic) ---
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Get.to(() => const MyOrdersView()),
                      child: OrderStatusCard(
                        icon: Icons.pending_actions, 
                        title: "Active Orders", 
                        // ✅ ডায়নামিক কাউন্ট ব্যবহার করা হচ্ছে
                        count: "${controller.activeOrderCount.value}", 
                        color: Colors.orange
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Get.to(() => const MyOrdersView()),
                      child: OrderStatusCard(
                        icon: Icons.check_circle_outline, 
                        title: "Completed", 
                        // ✅ ডায়নামিক কাউন্ট ব্যবহার করা হচ্ছে
                        count: "${controller.completedOrderCount.value}", 
                        color: Colors.green
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 24),

              // --- 3. Account Settings Card ---
              _buildSectionTitle("ACCOUNT"),
              Container(
                decoration: _cardDecoration(),
                child: Column(
                  children: [
                    _buildMenuTile(
                      Icons.location_on_outlined, 
                      "Manage Addresses", 
                      () => Get.to(() => const AddressView())
                    ),
                    const Divider(height: 1, indent: 60),
                    _buildMenuTile(
                      Icons.shopping_bag_outlined, 
                      "My Bookings", 
                      () => Get.to(() => const MyOrdersView())
                    ),
                    const Divider(height: 1, indent: 60),
                    _buildMenuTile(
                      Icons.favorite_border, 
                      "Saved Services", 
                      () {}
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // --- 4. General Settings Card ---
              _buildSectionTitle("GENERAL"),
              Container(
                decoration: _cardDecoration(),
                child: Column(
                  children: [
                    _buildMenuTile(
                      Icons.settings_outlined, 
                      "App Settings", 
                      () => Get.to(() => const SettingsView())
                    ),
                    const Divider(height: 1, indent: 60),
                    _buildMenuTile(
                      Icons.language, 
                      "Language", 
                      () {}, 
                      trailing: Text("English", style: GoogleFonts.poppins(color: Colors.grey))
                    ),
                    const Divider(height: 1, indent: 60),
                    _buildMenuTile(
                      Icons.headset_mic_outlined, 
                      "Help & Support", 
                      () {}
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // --- 5. Logout Button ---
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: controller.logout,
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.redAccent.withOpacity(0.1),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text("Log Out", style: GoogleFonts.poppins(color: Colors.redAccent, fontWeight: FontWeight.bold)),
                ),
              ),
              
              const SizedBox(height: 20),
              Center(child: Text("App Version 1.0.0", style: GoogleFonts.poppins(color: Colors.grey[400], fontSize: 12))),
              const SizedBox(height: 40),
            ],
          ),
        );
      }),
    );
  }

  // --- Helpers ---
  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, left: 4),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(title, style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey[500], letterSpacing: 1.2)),
      ),
    );
  }

  Widget _buildMenuTile(IconData icon, String title, VoidCallback onTap, {Widget? trailing}) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(8)),
        child: Icon(icon, color: Colors.black87, size: 20),
      ),
      title: Text(title, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500)),
      trailing: trailing ?? const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Colors.grey),
    );
  }
}