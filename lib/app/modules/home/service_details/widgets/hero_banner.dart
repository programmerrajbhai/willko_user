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
      final Color baseColor = data['color'] as Color;
      final IconData icon = data['icon'] as IconData;

      return Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 0),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            colors: [baseColor, baseColor.withOpacity(0.8)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: baseColor.withOpacity(0.4),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Background Icon Faded
            Positioned(
              right: -20,
              bottom: -20,
              child: Icon(
                icon,
                size: isMobile ? 140 : 180,
                color: Colors.white.withOpacity(0.15),
              ),
            ),
            
            // Content
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    "PREMIUM SERVICE",
                    style: GoogleFonts.montserrat(
                      fontSize: 10, 
                      fontWeight: FontWeight.bold, 
                      color: Colors.white, 
                      letterSpacing: 1.5
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                
                // Title
                Text(
                  data['title'],
                  style: GoogleFonts.poppins(
                    fontSize: isMobile ? 26 : 36,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 16),
                
                // Bullets
                Wrap(
                  spacing: 16,
                  runSpacing: 8,
                  children: (data['bullets'] as List).map((b) => Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.verified_rounded, color: Colors.greenAccent, size: 18),
                      const SizedBox(width: 6),
                      Text(
                        b, 
                        style: GoogleFonts.poppins(
                          color: Colors.white.withOpacity(0.9), 
                          fontSize: 13, 
                          fontWeight: FontWeight.w500
                        )
                      ),
                    ],
                  )).toList(),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}