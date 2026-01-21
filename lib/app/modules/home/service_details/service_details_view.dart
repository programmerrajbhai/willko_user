import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../utils/app_colors.dart';
import 'service_details_controller.dart';

// Widgets Import (আপনার ফোল্ডার স্ট্রাকচার অনুযায়ী পাথ ঠিক রাখুন)
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
      backgroundColor: AppColors.scaffoldBackground,
      body: SafeArea(
        child: Column(
          children: [
            const ServiceNavbar(), // কাস্টম উইজেট
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
      ),
      // মোবাইল বটম কার্ট (যদি মোবাইল হয়)
      bottomNavigationBar: MediaQuery.of(context).size.width <= 900 
          ? MobileBottomCart(c: c) 
          : null,
    );
  }
}

// ------------------------------------
// LAYOUTS
// ------------------------------------

class _DesktopLayout extends StatelessWidget {
  final ServiceDetailsController c;
  const _DesktopLayout({required this.c});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1280),
        child: Padding(
          padding: const EdgeInsets.only(top: 20, left: 16, right: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(width: 300, child: LeftSidebar(c: c)),
              const SizedBox(width: 24),
              Expanded(
                child: Scrollbar(
                  thumbVisibility: true,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(bottom: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DynamicHeroBanner(c: c, isMobile: false),
                        const SizedBox(height: 24),
                        MainContentList(c: c),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 24),
              SizedBox(width: 320, child: RightSidebar(c: c)),
            ],
          ),
        ),
      ),
    );
  }
}

class _MobileLayout extends StatelessWidget {
  final ServiceDetailsController c;
  const _MobileLayout({required this.c});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DynamicHeroBanner(c: c, isMobile: true),
          const SizedBox(height: 20),

          // Category Selector (Tabs)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Select a service",
                  style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textBlack),
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

          const SizedBox(height: 30),
          
          
        ],
      ),
    );
  }
}