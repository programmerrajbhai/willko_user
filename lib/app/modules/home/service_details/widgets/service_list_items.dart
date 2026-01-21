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
      // লোডিং হ্যান্ডলিং
      if (c.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      final list = c.packages;
      final idx = c.selectedItemIndex.value;
      
      // টাইটেল হ্যান্ডলিং
      final currentTitle = (c.items.isNotEmpty && idx < c.items.length) 
          ? (c.items[idx]["title"] ?? "Services").toString() 
          : "All Services";

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            currentTitle,
            style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textBlack),
          ),
          const SizedBox(height: 16),

          if (list.isEmpty)
            Container(
              padding: const EdgeInsets.all(30),
              width: double.infinity,
              decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(10)),
              child: Column(
                children: [
                  const Icon(Icons.search_off, size: 40, color: Colors.grey),
                  const SizedBox(height: 10),
                  Text("No services found in this category.", style: GoogleFonts.poppins(color: Colors.grey)),
                ],
              ),
            ),

          ...list.map((p) => ProductRow(p: p, c: c)),
        ],
      );
    });
  }
}

class ProductRow extends StatelessWidget {
  final Map<String, dynamic> p;
  final ServiceDetailsController c;
  const ProductRow({required this.p, required this.c, super.key});

  @override
  Widget build(BuildContext context) {
    // সেফটি চেক: shortDetails লিস্ট কিনা
    final shortDetails = (p["shortDetails"] is List) ? (p["shortDetails"] as List) : [];

    return InkWell(
      onTap: () => c.openProductDetailsSheet(context, p),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
             BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4)),
          ],
          border: Border.all(color: AppColors.inputBorder),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left Side: Text Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Discount Tag
                  if ((p["tag"] ?? "").toString().isNotEmpty)
                    Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        (p["tag"] ?? "").toString(),
                        style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.orange[800]),
                      ),
                    ),

                  // Title
                  Text(
                    (p["title"] ?? "Unknown Service").toString(),
                    style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textBlack),
                  ),
                  const SizedBox(height: 6),

                  // Rating
                  Row(
                    children: [
                      const Icon(Icons.star_rounded, size: 16, color: Colors.amber),
                      const SizedBox(width: 4),
                      Text(
                        "${p["rating"] ?? 4.5} (${p["reviews"] ?? '0 Reviews'})",
                        style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textGrey, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),
                  
                  // Price
                  Text(
                    (p["priceStr"] ?? "SAR 0").toString(),
                    style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primary),
                  ),
                  const SizedBox(height: 8),

                  // Bullet Points
                  ...shortDetails.map((d) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      children: [
                        const Icon(Icons.check_circle, size: 12, color: Colors.green),
                        const SizedBox(width: 6),
                        Expanded(child: Text(d.toString(), style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textGrey), maxLines: 1, overflow: TextOverflow.ellipsis)),
                      ],
                    ),
                  )),
                ],
              ),
            ),

            const SizedBox(width: 12),

            // Right Side: Image & Add Button
            Column(
              children: [
                Container(
                  height: 90, width: 90,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  // ইমেজ হ্যান্ডলিং: নেটওয়ার্ক ইমেজ এরর হলে ডিফল্ট আইকন দেখাবে
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      (p['image_url'] ?? "").toString(),
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.image_not_supported, color: Colors.grey);
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // Add Button
                InkWell(
                  onTap: () => c.quickAdd(p),
                  child: Container(
                    width: 90,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: AppColors.primary),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        "ADD +",
                        style: GoogleFonts.poppins(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}