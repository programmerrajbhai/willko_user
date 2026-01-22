import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:willko_user/app/modules/home/widgets/app_footer.dart';
import '../../../../utils/app_colors.dart';
import 'service_details_controller.dart';

// Widgets Import
import 'widgets/service_navbar.dart';
import 'widgets/hero_banner.dart';
import 'widgets/category_selector.dart';
import 'widgets/service_list_items.dart';
import 'widgets/sidebars.dart';
import 'widgets/cart_sheets.dart';

class ServiceDetailsView extends StatelessWidget {
  const ServiceDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    // হোম পেজ থেকে আসা আর্গুমেন্ট রিসিভ করা
    final serviceArg = (Get.arguments as Map<String, dynamic>?);
    
    // সেফটি চেক
    if (serviceArg == null) {
      return const Scaffold(body: Center(child: Text("No service data found")));
    }

    // কন্ট্রোলার পুট করা
    final c = Get.put(ServiceDetailsController(service: serviceArg));

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB), // Modern Soft Background
      body: Column(
        children: [
          // 1. Fixed Navbar
          const ServiceNavbar(), 
          
          // 2. Scrollable Content Area
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                // রেস্পন্সিভ লেআউট (Desktop vs Mobile)
                if (constraints.maxWidth > 900) {
                  return _DesktopLayout(c: c);
                } else {
                  return _MobileLayout(c: c);
                }
              },
            ),
          ),
        ],
      ),
      // মোবাইল বটম কার্ট (শুধুমাত্র মোবাইলে দেখাবে)
      bottomNavigationBar: MediaQuery.of(context).size.width <= 900 
          ? MobileBottomCart(c: c) 
          : null,
    );
  }
}

// ------------------------------------
// 🖥️ DESKTOP LAYOUT (Web Optimized)
// ------------------------------------

class _DesktopLayout extends StatelessWidget {
  final ServiceDetailsController c;
  const _DesktopLayout({required this.c});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      child: Column(
        children: [
          // Main Content Section
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1280),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Left Sidebar (Categories & Info)
                    SizedBox(width: 320, child: LeftSidebar(c: c)),
                    
                    const SizedBox(width: 32),
                    
                    // Middle Content (Hero & Services)
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          DynamicHeroBanner(c: c, isMobile: false),
                          const SizedBox(height: 32),
                          MainContentList(c: c),
                        ],
                      ),
                    ),
                    
                    const SizedBox(width: 32),
                    
                    // Right Sidebar (Cart Summary)
                    SizedBox(width: 340, child: RightSidebar(c: c)),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 60),

          // ✅ Full Width Footer
          const AppFooter(),
        ],
      ),
    );
  }
}

// ------------------------------------
// 📱 MOBILE LAYOUT (App Optimized)
// ------------------------------------

class _MobileLayout extends StatelessWidget {
  final ServiceDetailsController c;
  const _MobileLayout({required this.c});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner
          DynamicHeroBanner(c: c, isMobile: true),
          const SizedBox(height: 24),

          // Category Selector (Sticky Header Style)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Browse by Category",
                  style: GoogleFonts.poppins(
                    fontSize: 16, 
                    fontWeight: FontWeight.bold, 
                    color: Colors.black87
                  ),
                ),
                const SizedBox(height: 12),
                MobileCategorySelector(c: c),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Main Service List
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: MainContentList(c: c),
          ),

          const SizedBox(height: 40),
          
          // ✅ Mobile Footer
          const AppFooter(),
        ],
      ),
    );
  }
}