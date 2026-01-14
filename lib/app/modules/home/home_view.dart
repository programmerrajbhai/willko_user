import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:willko_user/app/modules/auth/login/login_view.dart';
import 'package:willko_user/app/modules/auth/signup/signup_view.dart';

import '../../../../utils/app_colors.dart';
import '../booking/cart/cart_view.dart';
import '../notifications/notification_view.dart';
import '../order/my_orders_view.dart';
import '../profile/profile_view.dart';
import 'home_controller.dart';
import 'service_details/service_details_view.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            /// ================= HERO =================
            UrbanHeroSection(
              selectedCityText: controller.selectedCity.value,
              onPickCity: () => _showCityPicker(controller),
            ),

            /// ================= WHY =================
            const SizedBox(height: 60),
           // _WhySection(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: _WhySectionUC(controller: controller),
            ),

            /// ================= SERVICES =================
            const SizedBox(height: 60),
           // _ServicesSection(controller: controller),
            ServicesChipsUC(controller: controller),

            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  void _showCityPicker(HomeController controller) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: controller.cities
              .map(
                (c) => ListTile(
              title: Text(c),
              onTap: () {
                controller.pickCity(c);
                Get.back();
              },
            ),
          )
              .toList(),
        ),
      ),
    );
  }
}

// ------------------ HERO SECTION ------------------


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
    final size = MediaQuery.sizeOf(context);

    // ✅ Responsive height rule:
    // Desktop/Web: 90% of screen height
    // Mobile: nice fixed min height (avoid too short hero)
    final bool isMobile = size.width < 700;
    final double heroHeight = isMobile
        ? 520
        : (size.height * 0.90).clamp(620.0, 900.0);

    // ✅ responsive padding
    final double sidePad = (size.width >= 1100) ? 60 : 22;

    return SizedBox(
      height: heroHeight,
      width: double.infinity,
      child: Container(
        color: Colors.black,
        child: Stack(
          children: [
            // ✅ Left hero image (like UrbanCompany)
            Positioned.fill(
              child: Align(
                alignment: Alignment.centerLeft,
                child: SizedBox(
                  width: isMobile ? double.infinity : size.width * 0.55,
                  child: Image.asset(
                    "assets/images/service_man.jpg/",
                    fit: BoxFit.cover,
                    alignment: Alignment.centerLeft,
                  ),
                ),
              ),
            ),

            // ✅ Fade to black (soft gradient) so right text pops
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color.fromARGB(0, 0, 0, 0),
                      Color.fromARGB(255, 0, 0, 0),
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
              ),
            ),

            // ✅ Content layer
            Padding(
              padding: EdgeInsets.symmetric(horizontal: sidePad, vertical: 26),
              child: Column(
                children: [
                  // -------- Top bar --------
                  Row(
                    children: [
                      const _UcLogo(),
                      const Spacer(),

                      // ✅ Hover + click
                      _HoverNavText(
                        text: "Register As A Professional",
                        underlineByDefault: true,
                        onTap: () => Get.to(() => const SignUpView()),
                      ),
                      const SizedBox(width: 26),
                      _HoverNavText(
                        text: "Help",
                        onTap: () {
                          Get.snackbar(
                            "Help",
                            "Support page later add হবে",
                            snackPosition: SnackPosition.BOTTOM,
                          );
                        },
                      ),
                      const SizedBox(width: 26),
                      _HoverNavText(
                        text: "Login / Sign Up",
                        onTap: () => Get.to(() => const LoginView()),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  // -------- Main hero content --------
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 520),
                        child: _HeroRightContent(
                          selectedCityText: selectedCityText,
                          onPickCity: onPickCity,
                          isMobile: isMobile,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeroRightContent extends StatelessWidget {
  final String selectedCityText;
  final VoidCallback onPickCity;
  final bool isMobile;

  const _HeroRightContent({
    required this.selectedCityText,
    required this.onPickCity,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: isMobile ? 6 : 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Willko Service",
            style: GoogleFonts.poppins(
              fontSize: 12,
              letterSpacing: 4,
              color: Colors.white.withOpacity(.65),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 14),

          Text(
            "Quality home services, on\ndemand",
            style: GoogleFonts.poppins(
              fontSize: isMobile ? 30 : 38,
              height: 1.08,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 14),

          Text(
            "Experienced, hand-picked Professionals to serve you at your\ndoorstep",
            style: GoogleFonts.poppins(
              fontSize: isMobile ? 13.5 : 15,
              height: 1.45,
              color: Colors.white.withOpacity(.75),
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 22),

          // ✅ White card (City selector)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(.35),
                  blurRadius: 22,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Where do you need a service?",
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 12),

                // ✅ dropdown box (like UC)
                InkWell(
                  onTap: onPickCity,
                  borderRadius: BorderRadius.circular(6),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black12),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            selectedCityText,
                            style: GoogleFonts.poppins(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w500,
                              color: selectedCityText == "Select your city"
                                  ? Colors.black54
                                  : Colors.black87,
                            ),
                          ),
                        ),
                        const Icon(Icons.keyboard_arrow_down_rounded),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _UcLogo extends StatelessWidget {
  const _UcLogo();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 42,
          width: 42,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(6),
          ),
          child: const Center(
            child: Text("WC", style: TextStyle(fontWeight: FontWeight.w900)),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          "Willko\nService",
          style: GoogleFonts.poppins(
            fontSize: 16,
            height: 1.0,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}

class _HoverNavText extends StatefulWidget {
  final String text;
  final VoidCallback onTap;
  final bool underlineByDefault;

  const _HoverNavText({
    required this.text,
    required this.onTap,
    this.underlineByDefault = false,
  });

  @override
  State<_HoverNavText> createState() => _HoverNavTextState();
}

class _HoverNavTextState extends State<_HoverNavText> {
  bool hovering = false;

  @override
  Widget build(BuildContext context) {
    final bool showUnderline = widget.underlineByDefault || hovering;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => hovering = true),
      onExit: (_) => setState(() => hovering = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 140),
          style: GoogleFonts.poppins(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: hovering ? Colors.white : Colors.white.withOpacity(.92),
            decoration: showUnderline ? TextDecoration.underline : TextDecoration.none,
            decorationColor: Colors.white.withOpacity(.92),
          ),
          child: Text(widget.text),
        ),
      ),
    );
  }
}


// ------------------ WHY SECTION ------------------

class _WhySectionUC extends StatelessWidget {
  final HomeController controller;
  const _WhySectionUC({required this.controller});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, c) {
        final isWide = c.maxWidth >= 900;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Why Willko Service?",
              style: GoogleFonts.poppins(
                fontSize: isWide ? 40 : 28,
                fontWeight: FontWeight.w800,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 26),

            isWide
                ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _WhyItemsUC(controller: controller, isWide: true)),
                const SizedBox(width: 28),
                Expanded(child: const _QualityCardUC(isWide: true)),
              ],
            )
                : Column(
              children: [
                _WhyItemsUC(controller: controller, isWide: false),
                const SizedBox(height: 18),
                const _QualityCardUC(isWide: false),
              ],
            ),
          ],
        );
      },
    );
  }
}

class _WhyItemsUC extends StatelessWidget {
  final HomeController controller;
  final bool isWide;

  const _WhyItemsUC({required this.controller, required this.isWide});

  @override
  Widget build(BuildContext context) {
    return Obx(
          () => Column(
        children: List.generate(controller.whyItems.length, (i) {
          final it = controller.whyItems[i];

          return Padding(
            padding: EdgeInsets.only(bottom: i == controller.whyItems.length - 1 ? 0 : 34),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // UC-like bigger icon box
                Container(
                  height: isWide ? 68 : 58,
                  width: isWide ? 68 : 58,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF3D6),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Stack(
                    children: [
                      Center(
                        child: Icon(
                          it["icon"],
                          size: isWide ? 34 : 30,
                          color: const Color(0xFFB46A00),
                        ),
                      ),
                      // small accent dot (UC vibe)
                      Positioned(
                        right: 10,
                        bottom: 10,
                        child: Container(
                          height: 6,
                          width: 6,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFF8A00),
                            borderRadius: BorderRadius.circular(99),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 22),

                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          it["title"],
                          style: GoogleFonts.poppins(
                            fontSize: isWide ? 18 : 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          it["subtitle"],
                          style: GoogleFonts.poppins(
                            fontSize: isWide ? 15 : 13.5,
                            height: 1.45,
                            color: Colors.black54,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

class _QualityCardUC extends StatelessWidget {
  final bool isWide;
  const _QualityCardUC({required this.isWide});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(isWide ? 44 : 26),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F6FF),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE5EDFF)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // bigger shield icon like UC block
          Container(
            height: isWide ? 92 : 72,
            width: isWide ? 92 : 72,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(.7),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Center(
              child: Icon(Icons.shield_rounded, size: 54, color: Color(0xFF4A7DFF)),
            ),
          ),
          SizedBox(height: isWide ? 26 : 18),

          Text(
            "100% Quality Assured",
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: isWide ? 34 : 24,
              fontWeight: FontWeight.w800,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 12),

          Text(
            "If you don’t love our service, we will make it right.",
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: isWide ? 16 : 13.5,
              height: 1.45,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}

// ------------------ SERVICES CHIPS ------------------

// ------------------ SERVICES CHIPS ------------------
class ServicesChipsUC extends StatelessWidget {
  final HomeController controller;
  const ServicesChipsUC({required this.controller, super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Wrap(
        spacing: 12,
        runSpacing: 12,
        children: List.generate(controller.services.length, (i) {
          final it = controller.services[i];
          final selected = controller.selectedServiceIndex.value == i;

          return _HoverChip(
            selected: selected,
            icon: it["icon"],
            label: it["label"],
            onTap: () {
              controller.selectService(i);

              // ✅ Pass whole service object
              Get.to(
                    () => const ServiceDetailsView(),
                arguments: it,
              );
            },
          );
        }),
      );
    });
  }
}

class _HoverChip extends StatefulWidget {
  final bool selected;
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _HoverChip({
    required this.selected,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  State<_HoverChip> createState() => _HoverChipState();
}

class _HoverChipState extends State<_HoverChip> {
  bool hovering = false;

  @override
  Widget build(BuildContext context) {
    final active = widget.selected || hovering;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => hovering = true),
      onExit: (_) => setState(() => hovering = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 140),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: active ? const Color(0xFFEFF3FF) : const Color(0xFFF6F7FB),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: active ? const Color(0xFF7B61FF).withOpacity(.35) : const Color(0xFFE6E8F0),
            ),
            boxShadow: active
                ? [
              BoxShadow(
                color: Colors.black.withOpacity(.06),
                blurRadius: 14,
                offset: const Offset(0, 8),
              )
            ]
                : [],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(widget.icon, size: 18, color: active ? const Color(0xFF7B61FF) : Colors.black54),
              const SizedBox(width: 10),
              Text(
                widget.label,
                style: GoogleFonts.poppins(
                  fontSize: 12.8,
                  fontWeight: FontWeight.w600,
                  color: active ? const Color(0xFF4A3DCC) : Colors.black87,
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.keyboard_arrow_down_rounded,
                size: 18,
                color: active ? const Color(0xFF7B61FF) : Colors.black38,
              ),
            ],
          ),
        ),
      ),
    );
  }
}


