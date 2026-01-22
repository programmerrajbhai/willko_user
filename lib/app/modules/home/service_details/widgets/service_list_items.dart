import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:willko_user/utils/app_colors.dart';
import '../service_details_controller.dart';

class MainContentList extends StatelessWidget {
  final ServiceDetailsController c;
  const MainContentList({required this.c, super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (c.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      final list = c.packages;
      final idx = c.selectedItemIndex.value;
      
      final currentTitle = (c.items.isNotEmpty && idx < c.items.length) 
          ? (c.items[idx]["title"] ?? "Services").toString() 
          : "All Services";

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Text(
              currentTitle,
              style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textBlack),
            ),
          ),

          if (list.isEmpty)
            _buildEmptyState(),

          ...list.map((p) => ProductRow(p: p, c: c)),
        ],
      );
    });
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(40),
      width: double.infinity,
      decoration: BoxDecoration(color: Colors.grey[50], borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          Icon(Icons.search_off_rounded, size: 48, color: Colors.grey[400]),
          const SizedBox(height: 12),
          Text("No services available here.", style: GoogleFonts.poppins(color: Colors.grey[500])),
        ],
      ),
    );
  }
}

class ProductRow extends StatelessWidget {
  final Map<String, dynamic> p;
  final ServiceDetailsController c;
  const ProductRow({required this.p, required this.c, super.key});

  @override
  Widget build(BuildContext context) {
    final shortDetails = (p["shortDetails"] is List) ? (p["shortDetails"] as List) : [];
    final hasDiscount = (p["tag"] ?? "").toString().isNotEmpty;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
           BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 15, offset: const Offset(0, 5)),
        ],
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => c.openProductDetailsSheet(context, p),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Tag
                      if (hasDiscount)
                        Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF0E6),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            (p["tag"] ?? "").toString().toUpperCase(),
                            style: GoogleFonts.poppins(fontSize: 9, fontWeight: FontWeight.w700, color: Colors.deepOrange),
                          ),
                        ),

                      Text(
                        (p["title"] ?? "Service").toString(),
                        style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textBlack),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),

                      // Rating
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(2),
                            decoration: const BoxDecoration(color: Colors.amber, shape: BoxShape.circle),
                            child: const Icon(Icons.star, size: 10, color: Colors.white),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            "${p["rating"] ?? 4.8} (${p["reviews"] ?? '100+'} reviews)",
                            style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey[600], fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 12),
                      
                      // Price
                      Text(
                        (p["priceStr"] ?? "SAR 0").toString(),
                        style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textBlack),
                      ),
                      
                      const SizedBox(height: 8),
                      // Details (Max 2 lines)
                      ...shortDetails.take(2).map((d) => Padding(
                        padding: const EdgeInsets.only(bottom: 2),
                        child: Row(
                          children: [
                            Icon(Icons.check, size: 12, color: Colors.grey[400]),
                            const SizedBox(width: 6),
                            Expanded(child: Text(d.toString(), style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey[600]), maxLines: 1)),
                          ],
                        ),
                      )),
                    ],
                  ),
                ),

                const SizedBox(width: 16),

                // Right Image & Button
                Column(
                  children: [
                    Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        Container(
                          height: 85, width: 85,
                          margin: const EdgeInsets.only(bottom: 14), // Space for button
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.grey[100],
                            image: DecorationImage(
                              image: NetworkImage((p['image_url'] ?? "").toString()),
                              fit: BoxFit.cover,
                              onError: (_, __) => {}, // Error placeholder handled by color
                            ),
                          ),
                        ),
                        
                        // Add Button Overlay
                        Transform.translate(
                          offset: const Offset(0, 0),
                          child: InkWell(
                            onTap: () => c.quickAdd(p),
                            child: Container(
                              width: 70,
                              height: 32,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: AppColors.primary.withOpacity(0.2)),
                                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 5, offset: const Offset(0, 2))],
                              ),
                              child: Center(
                                child: Text(
                                  "ADD +",
                                  style: GoogleFonts.poppins(
                                    color: AppColors.primary, 
                                    fontWeight: FontWeight.bold, 
                                    fontSize: 12
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}