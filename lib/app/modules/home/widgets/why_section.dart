import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:willko_user/utils/app_colors.dart'; // নিশ্চিত করুন পাথ ঠিক আছে
import '../home_controller.dart';

class WhySectionUC extends StatelessWidget {
  final HomeController controller;
  const WhySectionUC({required this.controller, super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, c) {
        final isWide = c.maxWidth >= 900;
        final double padding = isWide ? 40 : 20;

        return Container(
          padding: EdgeInsets.symmetric(vertical: 40, horizontal: padding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title with decorative underline
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Why Willko Service?",
                    style: GoogleFonts.poppins(
                      fontSize: isWide ? 36 : 26,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textBlack, // বা Colors.black87
                      height: 1.2
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 4, width: 60,
                    decoration: BoxDecoration(
                      color: AppColors.primary, // ব্র্যান্ড কালার
                      borderRadius: BorderRadius.circular(2)
                    ),
                  )
                ],
              ),
              const SizedBox(height: 40),
              
              // Content Area
              isWide
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start, 
                      children: [
                        Expanded(flex: 3, child: _WhyItemsUC(controller: controller, isWide: true)), 
                        const SizedBox(width: 40), 
                        Expanded(flex: 2, child: const _QualityCardUC(isWide: true))
                      ]
                    )
                  : Column(
                      children: [
                        _WhyItemsUC(controller: controller, isWide: false), 
                        const SizedBox(height: 30), 
                        const _QualityCardUC(isWide: false)
                      ]
                    ),
            ],
          ),
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
    return Column(
      children: List.generate(controller.whyItems.length, (i) {
        final it = controller.whyItems[i];
        final isLast = i == controller.whyItems.length - 1;
        
        return Container(
          margin: EdgeInsets.only(bottom: isLast ? 0 : 24),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 15,
                offset: const Offset(0, 5)
              )
            ],
            border: Border.all(color: Colors.grey.withOpacity(0.1))
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Stylish Icon Box
              Container(
                height: 55, width: 55,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1), 
                  borderRadius: BorderRadius.circular(14)
                ),
                child: Center(
                  child: Icon(it["icon"] as IconData, size: 28, color: AppColors.primary),
                ),
              ),
              const SizedBox(width: 20),
              
              // Text Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      it["title"] as String, 
                      style: GoogleFonts.poppins(
                        fontSize: 17, 
                        fontWeight: FontWeight.w700, 
                        color: Colors.black87
                      )
                    ),
                    const SizedBox(height: 6),
                    Text(
                      it["subtitle"] as String, 
                      style: GoogleFonts.poppins(
                        fontSize: 14, 
                        height: 1.5, 
                        color: Colors.black54, 
                        fontWeight: FontWeight.w400
                      )
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

class _QualityCardUC extends StatelessWidget {
  final bool isWide;
  const _QualityCardUC({required this.isWide});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isWide ? 40 : 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [const Color(0xFFF0F4FF), Colors.white],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE0E7FF), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4A7DFF).withOpacity(0.15),
            blurRadius: 20,
            offset: const Offset(0, 10)
          )
        ]
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center, 
        children: [
          // Shield Icon with Glow
          Container(
            height: 80, width: 80, 
            decoration: BoxDecoration(
              color: Colors.white, 
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF4A7DFF).withOpacity(0.3),
                  blurRadius: 15,
                  spreadRadius: 2
                )
              ]
            ), 
            child: const Center(
              child: Icon(Icons.verified_user_rounded, size: 40, color: Color(0xFF4A7DFF))
            )
          ),
          SizedBox(height: isWide ? 24 : 20),
          
          Text(
            "100% Quality Assured", 
            textAlign: TextAlign.center, 
            style: GoogleFonts.poppins(
              fontSize: isWide ? 26 : 22, 
              fontWeight: FontWeight.w800, 
              color: Colors.black87
            )
          ),
          const SizedBox(height: 12),
          Text(
            "If you don’t love our service, we will make it right. Your satisfaction is our priority.", 
            textAlign: TextAlign.center, 
            style: GoogleFonts.poppins(
              fontSize: 14, 
              height: 1.5, 
              color: Colors.black54
            )
          ),
        ]
      ),
    );
  }
}