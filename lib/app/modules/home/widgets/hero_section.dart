import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:willko_user/app/modules/home/home_controller.dart';
import 'package:willko_user/utils/app_colors.dart';
import '../../auth/login/login_view.dart';
import '../../auth/signup/signup_view.dart';
import '../../home/search/search_view.dart';
// ✅ Profile View Import (আপনার ফোল্ডার স্ট্রাকচার অনুযায়ী পাথ চেক করুন)
import '../../profile/profile_view.dart'; 

class UrbanHeroSection extends StatelessWidget {
  final String selectedCityText;
  final VoidCallback onPickCity;

  const UrbanHeroSection({
    super.key,
    required this.selectedCityText,
    required this.onPickCity,
  });

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.find<HomeController>();
    final size = MediaQuery.sizeOf(context);
    final bool isMobile = size.width < 900;

    final double heroHeight = isMobile
        ? 850
        : (size.height * 0.90).clamp(650.0, 900.0);
    final double sidePad = (size.width >= 1100) ? 80 : 24;

    return Container(
      height: heroHeight,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF0F0F0F), Color(0xFF1A1A1A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          // Glow Effect
          Positioned(
            top: -100, right: -100,
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
              child: Container(
                height: 400, width: 400,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),

          // Main Content
          Padding(
            padding: EdgeInsets.symmetric(horizontal: sidePad, vertical: 30),
            child: Column(
              children: [
                // --- Top Navbar ---
                Row(
                  children: [
                    const _BrandLogo(),
                    const Spacer(),
                    Obx(() => _buildAuthSection(context, controller, isMobile)),
                  ],
                ),

                const Spacer(),
                
                // --- Split Layout ---
                isMobile
                    ? Column(
                        children: [
                          _HeroContentBox(
                            selectedCityText: selectedCityText,
                            onPickCity: onPickCity,
                            isMobile: true,
                          ),
                          const SizedBox(height: 40),
                          const _HeroImageDisplay(isMobile: true),
                        ],
                      )
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 5,
                            child: _HeroContentBox(
                              selectedCityText: selectedCityText,
                              onPickCity: onPickCity,
                              isMobile: false,
                            ),
                          ),
                          const SizedBox(width: 40),
                          Expanded(
                            flex: 4,
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: const _HeroImageDisplay(isMobile: false),
                            ),
                          ),
                        ],
                      ),

                const Spacer(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAuthSection(
    BuildContext context,
    HomeController controller,
    bool isMobile,
  ) {
    if (controller.isLoggedIn.value) {
      return _ProProfileMenu(
        userName: controller.userName.value,
        onLogout: controller.logout,
      );
    } else {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _GlassButton(
            text: "Login",
            onTap: () => Get.to(() => const LoginView()),
            isPrimary: false,
          ),
          const SizedBox(width: 16),
          _GlassButton(
            text: "Sign Up",
            onTap: () => Get.to(() => const SignUpView()),
            isPrimary: true,
          ),
        ],
      );
    }
  }
}

// --- 🔥 HERO IMAGE DISPLAY ---
class _HeroImageDisplay extends StatelessWidget {
  final bool isMobile;
  const _HeroImageDisplay({required this.isMobile});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: isMobile ? 350 : 500,
      width: isMobile ? double.infinity : 400,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 40,
            spreadRadius: -5,
            offset: const Offset(10, 20),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 30,
            spreadRadius: -5,
            offset: const Offset(-5, -5),
          ),
        ],
        border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              "assets/images/service_man.jpg",
              fit: BoxFit.cover,
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.transparent, Colors.black.withOpacity(0.4)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
            Positioned(
              bottom: 20,
              left: 20,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    color: Colors.white.withOpacity(0.2),
                    child: Row(
                      children: [
                        const Icon(Icons.verified, color: Colors.blueAccent, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          "Verified Professionals",
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- CONTENT WIDGETS ---

class _HeroContentBox extends StatelessWidget {
  final String selectedCityText;
  final VoidCallback onPickCity;
  final bool isMobile;

  const _HeroContentBox({
    required this.selectedCityText,
    required this.onPickCity,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.primary.withOpacity(0.5)),
            borderRadius: BorderRadius.circular(30),
            color: AppColors.primary.withOpacity(0.1),
          ),
          child: Text(
            "TRUSTED BY MILLIONS",
            style: GoogleFonts.montserrat(
              fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.primary, letterSpacing: 1.5,
            ),
          ),
        ),
        const SizedBox(height: 24),
        Text(
          "Home services,\nredefined.",
          style: GoogleFonts.playfairDisplay(
            fontSize: isMobile ? 42 : 72, height: 1.05, fontWeight: FontWeight.w700, color: Colors.white,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          "Book trusted professionals for cleaning, repair, and grooming. Experience luxury at your doorstep.",
          style: GoogleFonts.poppins(
            fontSize: isMobile ? 15 : 18, color: Colors.grey.shade400, height: 1.6, fontWeight: FontWeight.w300,
          ),
        ),
        const SizedBox(height: 40),
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(color: AppColors.primary.withOpacity(0.15), blurRadius: 40, offset: const Offset(0, 10)),
            ],
          ),
          child: isMobile
              ? Column(children: [_buildLocationRow(), const Divider(height: 1), _buildSearchRow()])
              : Row(
                  children: [
                    Expanded(flex: 2, child: _buildLocationRow()),
                    Container(width: 1, height: 30, color: Colors.grey.shade300),
                    Expanded(flex: 3, child: _buildSearchRow()),
                    const SizedBox(width: 8),
                    _buildSearchButton(),
                  ],
                ),
        ),
      ],
    );
  }

  Widget _buildLocationRow() {
    return InkWell(
      onTap: onPickCity,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            const Icon(Icons.location_on, color: AppColors.primary, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Location", style: GoogleFonts.poppins(fontSize: 10, color: Colors.grey.shade500, fontWeight: FontWeight.w500)),
                  Text(selectedCityText, style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: Colors.black87)),
                ],
              ),
            ),
            const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchRow() {
    return InkWell(
      onTap: () => Get.to(() => const SearchView()),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Search", style: GoogleFonts.poppins(fontSize: 10, color: Colors.grey.shade500, fontWeight: FontWeight.w500)),
                  Text("AC Repair, Cleaning...", style: GoogleFonts.poppins(color: Colors.grey.shade400, fontSize: 14)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchButton() {
    return Container(
      height: 48, width: 48,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: AppColors.primary.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: const Icon(Icons.search, color: Colors.white, size: 24),
    );
  }
}

// --- HELPER WIDGETS ---

class _BrandLogo extends StatelessWidget {
  const _BrandLogo();
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 40, width: 40,
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [Colors.white, Colors.grey.shade200]),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Center(child: Text("W", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 22, color: Colors.black))),
        ),
        const SizedBox(width: 12),
        Text("WILLKO", style: GoogleFonts.montserrat(fontWeight: FontWeight.w700, fontSize: 18, color: Colors.white, letterSpacing: 1)),
      ],
    );
  }
}

// ✅ Updated Profile Menu to Navigate to ProfileView
class _ProProfileMenu extends StatelessWidget {
  final String userName;
  final VoidCallback onLogout;
  const _ProProfileMenu({required this.userName, required this.onLogout});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white24),
      ),
      child: PopupMenuButton<String>(
        onSelected: (v) {
          if (v == 'logout') {
            onLogout();
          } else if (v == 'profile') {
            // ✅ Profile Navigation Logic
            Get.to(() => const ProfileView()); 
          }
        },
        offset: const Offset(0, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: const Color(0xFF1E1E1E), // Dark Theme Menu
        child: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: AppColors.primary,
              child: Text(
                userName.isNotEmpty ? userName[0].toUpperCase() : "U",
                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              userName,
              style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.white70),
            const SizedBox(width: 8),
          ],
        ),
        itemBuilder: (_) => [
          // ✅ My Profile Item
          PopupMenuItem(
            value: 'profile',
            child: Row(
              children: [
                const Icon(Icons.person_outline_rounded, color: Colors.white70),
                const SizedBox(width: 10),
                Text(
                  "My Profile",
                  style: GoogleFonts.poppins(color: Colors.white),
                ),
              ],
            ),
          ),
          // Divider
          const PopupMenuDivider(height: 1),
          // Logout Item
          PopupMenuItem(
            value: 'logout',
            child: Row(
              children: [
                const Icon(Icons.logout, color: Colors.redAccent),
                const SizedBox(width: 10),
                Text(
                  "Logout",
                  style: GoogleFonts.poppins(color: Colors.redAccent),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _GlassButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final bool isPrimary;
  const _GlassButton({
    required this.text,
    required this.onTap,
    this.isPrimary = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        decoration: BoxDecoration(
          color: isPrimary ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: isPrimary ? null : Border.all(color: Colors.white54),
        ),
        child: Text(
          text,
          style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}