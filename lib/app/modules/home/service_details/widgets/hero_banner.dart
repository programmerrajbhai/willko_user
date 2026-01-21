import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../service_details_controller.dart';

class DynamicHeroBanner extends StatelessWidget {
  final ServiceDetailsController c;
  final bool isMobile;
  const DynamicHeroBanner({required this.c, required this.isMobile, super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final data = c.currentBannerData;
      final color = data['color'] as Color;
      final icon = data['icon'] as IconData;

      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(color: color.withOpacity(0.4), blurRadius: 20, offset: const Offset(0, 8))
          ]
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data['title'],
                    style: GoogleFonts.poppins(
                      fontSize: isMobile ? 22 : 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ... (data['bullets'] as List).map((b) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      children: [
                        const Icon(Icons.check_circle, color: Colors.white70, size: 16),
                        const SizedBox(width: 8),
                        Text(b, style: GoogleFonts.poppins(color: Colors.white, fontSize: 14)),
                      ],
                    ),
                  )),
                ],
              ),
            ),
            Icon(icon, size: isMobile ? 80 : 120, color: Colors.white.withOpacity(0.2)),
          ],
        ),
      );
    });
  }
}