import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:willko_user/app/modules/home/home_controller.dart';
import 'package:willko_user/app/modules/home/widgets/we_are_hiring_section.dart';
import 'package:willko_user/utils/app_colors.dart';

// --- AUTH VIEWS ---
import '../../auth/login/login_view.dart';
import '../../auth/signup/signup_view.dart';

// --- USER VIEWS (100% Working Screens) ---
import '../../profile/profile_view.dart';
import '../../booking/cart/cart_view.dart';
import '../../order/my_orders_view.dart';
import '../../notifications/notification_view.dart';
import '../../booking/address/address_view.dart';
import '../../settings/settings_view.dart';

// ==========================================
// 🚀 HERO SECTION WIDGET (Stateful for Slider)
// ==========================================
class UrbanHeroSection extends StatefulWidget {
  const UrbanHeroSection({super.key});

  @override
  State<UrbanHeroSection> createState() => _UrbanHeroSectionState();
}

class _UrbanHeroSectionState extends State<UrbanHeroSection> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _timer;

  final List<Map<String, String>> heroSlides = [
    {
      "image": "assets/images/service_man.jpg",
      "title": "Home services,\nredefined.",
      "subtitle":
          "Book trusted professionals for cleaning, repair, and grooming.\nExperience luxury at your doorstep.",
    },
    {
      "image": "assets/images/img.png",
      "title": "Expert repairs,\ninstant relief.",
      "subtitle":
          "AC, plumbing, and electrical experts just a tap away.\nFast, reliable, and verified.",
    },
    {
      "image": "assets/images/img_1.png",
      "title": "Premium cleaning,\nsparkling homes.",
      "subtitle":
          "Deep cleaning, sofa washing, and sanitization.\nYour home, cleaner than ever.",
    },
  ];

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 4), (Timer timer) {
      if (_currentPage < heroSlides.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.find<HomeController>();
    final size = MediaQuery.of(context).size;
    final bool isMobile = size.width < 700;

    final double heroHeight = isMobile ? 550 : 700;

    return SizedBox(
      height: heroHeight,
      width: double.infinity,
      child: Stack(
        children: [
          // --- AUTO SLIDER ---
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() => _currentPage = index);
            },
            itemCount: heroSlides.length,
            itemBuilder: (context, index) {
              final slide = heroSlides[index];
              return Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    slide["image"]!,
                    fit: BoxFit.cover,
                    alignment: Alignment.topCenter,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.7),
                          Colors.black.withOpacity(0.1),
                          Colors.black.withOpacity(0.95),
                        ],
                        stops: const [0.0, 0.4, 1.0],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 20,
                    left: isMobile ? 20 : 80,
                    right: isMobile ? 20 : 80,
                    child: _buildHeroText(
                      isMobile: isMobile,
                      title: slide["title"]!,
                      subtitle: slide["subtitle"]!,
                    ),
                  ),
                ],
              );
            },
          ),

          // --- STATIC HEADER ---
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 16 : 60,
                  vertical: 10,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const _BrandLogo(),
                    if (isMobile)
                      IconButton(
                        icon: const Icon(
                          Icons.menu_rounded,
                          color: Colors.white,
                          size: 32,
                        ),
                        onPressed: () {
                          Scaffold.of(context).openEndDrawer();
                        },
                      )
                    else
                      _buildDesktopAuth(controller),
                  ],
                ),
              ),
            ),
          ),

          // --- SLIDER DOT INDICATORS ---
          Positioned(
            bottom: 10,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(heroSlides.length, (index) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  height: 6,
                  width: _currentPage == index ? 24 : 8,
                  decoration: BoxDecoration(
                    color: _currentPage == index
                        ? AppColors.primary
                        : Colors.white54,
                    borderRadius: BorderRadius.circular(10),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopAuth(HomeController controller) {
    return Obx(() {
      if (controller.isLoggedIn.value) {
        return InkWell(
          onTap: () => Get.to(() => const ProfileView()),
          borderRadius: BorderRadius.circular(30),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: Colors.white24),
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 16,
                  backgroundColor: AppColors.primary,
                  child: Icon(Icons.person, color: Colors.white, size: 18),
                ),
                const SizedBox(width: 10),
                Text(
                  controller.userName.value,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 8),
              ],
            ),
          ),
        );
      }
      return Row(
        children: [
          _NavButton(
            text: "Login",
            onTap: () => Get.to(() => const LoginView()),
          ),
          const SizedBox(width: 15),
          _NavButton(
            text: "Sign Up",
            onTap: () => Get.to(() => const SignUpView()),
            isPrimary: true,
          ),
        ],
      );
    });
  }

  Widget _buildHeroText({
    required bool isMobile,
    required String title,
    required String subtitle,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 50,
          height: 4,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(2),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.5),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
        ),
        Text(
          title,
          style: GoogleFonts.playfairDisplay(
            fontSize: isMobile ? 42 : 68,
            fontWeight: FontWeight.w800,
            color: Colors.white,
            height: 1.1,
            letterSpacing: 1.2,
            shadows: [
              Shadow(
                color: Colors.black.withOpacity(0.5),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text(
          subtitle,
          style: GoogleFonts.poppins(
            fontSize: isMobile ? 14 : 18,
            color: Colors.white.withOpacity(0.9),
            fontWeight: FontWeight.w400,
            height: 1.6,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}

// ==========================================
// 🚀 100% WORKING DEEP CURVED DRAWER WIDGET
// ==========================================
class UrbanDrawer extends StatelessWidget {
  const UrbanDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.find<HomeController>();

    return Drawer(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40),
          bottomLeft: Radius.circular(40),
        ),
      ),
      backgroundColor: const Color(0xFF121212),
      child: SafeArea(
        child: Column(
          children: [
            // --- Drawer Header ---
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(40),
                ),
                border: Border(
                  bottom: BorderSide(color: Colors.white.withOpacity(0.05)),
                ),
              ),
              child: Obx(
                () => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 35,
                      backgroundColor: AppColors.primary.withOpacity(0.2),
                      child: const Icon(
                        Icons.person,
                        size: 40,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      controller.isLoggedIn.value
                          ? controller.userName.value
                          : "Welcome, Guest!",
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    if (!controller.isLoggedIn.value) ...[
                      const SizedBox(height: 8),
                      Text(
                        "Login to book services",
                        style: GoogleFonts.poppins(
                          color: Colors.grey,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            const SizedBox(height: 10),

            // --- Full Working Menu Items ---
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                physics: const BouncingScrollPhysics(),
                child: Obx(
                  () => Column(
                    children: [
                      _DrawerTile(
                        icon: Icons.home_rounded,
                        title: "Home",
                        onTap: () => Get.back(),
                      ),

                      if (controller.isLoggedIn.value) ...[
                        // ✅ 1. Cart
                        // _DrawerTile(icon: Icons.shopping_cart_outlined, title: "My Cart", onTap: () {
                        //   Get.back();
                        //   Get.to(() => const CartView());
                        // }),

                        // ✅ 2. Order History & Tracking
                        _DrawerTile(
                          icon: Icons.receipt_long_rounded,
                          title: "My Orders & Tracking",
                          onTap: () {
                            Get.back();
                            Get.to(() => const MyOrdersView());
                          },
                        ),

                        // ✅ 3. Notifications
                        _DrawerTile(
                          icon: Icons.notifications_none_rounded,
                          title: "Notifications",
                          onTap: () {
                            Get.back();
                            Get.to(() => const NotificationView());
                          },
                        ),

                        // ✅ 4. Saved Addresses
                        _DrawerTile(
                          icon: Icons.location_on_outlined,
                          title: "Saved Addresses",
                          onTap: () {
                            Get.back();
                            Get.to(() => const AddressView());
                          },
                        ),

                        // ✅ 5. Profile
                        _DrawerTile(
                          icon: Icons.person_outline_rounded,
                          title: "My Profile",
                          onTap: () {
                            Get.back();
                            Get.to(() => const ProfileView());
                          },
                        ),
                      ] else ...[
                        _DrawerTile(
                          icon: Icons.login_rounded,
                          title: "Login",
                          onTap: () {
                            Get.back();
                            Get.to(() => const LoginView());
                          },
                        ),
                        _DrawerTile(
                          icon: Icons.person_add_alt_1_rounded,
                          title: "Sign Up",
                          onTap: () {
                            Get.back();
                            Get.to(() => const SignUpView());
                          },
                        ),
                      ],

                      const Divider(color: Colors.white12, height: 30),

                      // ✅ 6. Settings
                      _DrawerTile(
                        icon: Icons.settings_outlined,
                        title: "Settings",
                        onTap: () {
                          Get.back();
                          Get.to(() => const SettingsView());
                        },
                      ),

                      // ✅ 7. Help & Support
                      _DrawerTile(
                        icon: Icons.support_agent_rounded,
                        title: "Help & Support",
                        onTap: () {
                          Get.back();
                          Get.snackbar(
                            "Help & Support",
                            "Live chat will be available soon!",
                            backgroundColor: Colors.black87,
                            colorText: Colors.white,
                            snackPosition: SnackPosition.BOTTOM,
                            margin: const EdgeInsets.all(20),
                          );
                        },
                      ),

                      // 💎 8. We Are Hiring
                      HiringSection(),

                      if (controller.isLoggedIn.value) ...[
                        const Divider(color: Colors.white12, height: 30),
                        // ✅ 9. Logout
                        _DrawerTile(
                          icon: Icons.logout_rounded,
                          title: "Logout",
                          isDestructive: true,
                          onTap: () {
                            Get.back();
                            controller.logout();
                          },
                        ),
                      ],
                      const SizedBox(height: 30),
                    ],
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

// --- Menu Tile Widget ---
class _DrawerTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool isDestructive;

  const _DrawerTile({
    required this.icon,
    required this.title,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = isDestructive ? Colors.redAccent : Colors.white;
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: color.withOpacity(0.8), size: 24),
      title: Text(
        title,
        style: GoogleFonts.poppins(
          color: color,
          fontWeight: FontWeight.w500,
          fontSize: 15,
        ),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      hoverColor: Colors.white.withOpacity(0.05),
    );
  }
}

// --- 🔥 We Are Hiring Tile ---
class _HiringTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withOpacity(0.8),
            AppColors.primary.withOpacity(0.4),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withOpacity(0.5)),
      ),
      child: ListTile(
        onTap: () {
          Get.back();
          Get.snackbar(
            "We are Hiring!",
            "Redirecting to careers page...",
            backgroundColor: AppColors.primary,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
            margin: const EdgeInsets.all(20),
            borderRadius: 12,
          );
        },
        leading: const Icon(Icons.work_rounded, color: Colors.white, size: 24),
        title: Text(
          "We are hiring!",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            "NEW",
            style: GoogleFonts.poppins(
              color: AppColors.primary,
              fontSize: 10,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),
    );
  }
}

// --- Sub Widgets (Logos & Buttons) ---
class _BrandLogo extends StatelessWidget {
  const _BrandLogo();
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Text(
            "W",
            style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 20,
              color: Colors.black,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          "WILLKO",
          style: GoogleFonts.montserrat(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            fontSize: 22,
            letterSpacing: 1.5,
          ),
        ),
      ],
    );
  }
}

class _NavButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final bool isPrimary;
  const _NavButton({
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
        padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 12),
        decoration: BoxDecoration(
          color: isPrimary ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: isPrimary ? null : Border.all(color: Colors.white54),
        ),
        child: Text(
          text,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}
