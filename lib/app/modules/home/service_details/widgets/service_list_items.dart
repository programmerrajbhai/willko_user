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

      final idx = c.selectedItemIndex.value;
      final categories = c.items;

      // ============================================
      // 🔥 যদি "All" সিলেক্ট করা থাকে (Index -1)
      // ============================================
      if (idx == -1) {
        if (categories.isEmpty) return _buildEmptyState();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(categories.length, (i) {
            final categoryTitle = (categories[i]["title"] ?? "Services").toString();
            final categoryItems = c.getPackagesForIndex(i);

            // যদি এই ক্যাটাগরিতে কোনো সার্ভিস না থাকে, তাহলে কিছুই দেখাবে না
            if (categoryItems.isEmpty) return const SizedBox.shrink();

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🔹 ক্যাটাগরির টাইটেল (যেমন: Servicing, Installation)
                Padding(
                  padding: EdgeInsets.only(bottom: 16, top: i == 0 ? 0 : 24),
                  child: Text(
                    categoryTitle,
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textBlack,
                    ),
                  ),
                ),

                // 🔹 ওই ক্যাটাগরির আন্ডারে থাকা সার্ভিসগুলোর লিস্ট
                ...categoryItems.map((p) => ProductRow(p: p, c: c)),
              ],
            );
          }),
        );
      }

      // ============================================
      // 🔥 যদি নির্দিষ্ট কোনো ক্যাটাগরি সিলেক্ট করা থাকে
      // ============================================
      final list = c.packages;
      final currentTitle = (categories.isNotEmpty && idx >= 0 && idx < categories.length)
          ? (categories[idx]["title"] ?? "Services").toString()
          : "Services";

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Text(
              currentTitle,
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textBlack,
              ),
            ),
          ),

          if (list.isEmpty) _buildEmptyState(),

          ...list.map((p) => ProductRow(p: p, c: c)),
        ],
      );
    });
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(40),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(Icons.search_off_rounded, size: 48, color: Colors.grey[400]),
          const SizedBox(height: 12),
          Text(
            "No services available here.",
            style: GoogleFonts.poppins(color: Colors.grey[500]),
          ),
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
    final shortDetails = (p["shortDetails"] is List)
        ? (p["shortDetails"] as List)
        : [];
    final hasDiscount = (p["tag"] ?? "").toString().isNotEmpty;

    // 🔥 SMART IMAGE LOGIC
    String imageVal = (p['image'] ?? p['image_url'] ?? p['thumbnail'] ?? p['picture'] ?? p['service_image'] ?? "").toString().trim();

    if (imageVal.toLowerCase() == "null") {
      imageVal = "";
    }

    // 🔴🔴 CRITICAL FIX: Double URL Extractor 🔴🔴
    // যদি লিংকের ভেতর দুইবার http থাকে, তাহলে এটি পেছনের ভুল লিংকটি কেটে ফেলবে এবং সঠিক লিংকটি বের করে আনবে।
    int lastHttpIndex = imageVal.lastIndexOf('http');
    if (lastHttpIndex > 0) {
      imageVal = imageVal.substring(lastHttpIndex);
    }

    String fullImageUrl = "";
    if (imageVal.isEmpty) {
      fullImageUrl = "https://ui-avatars.com/api/?name=Service&background=E0E0E0";
    } else if (imageVal.startsWith('http')) {
      if (imageVal.startsWith('http://')) {
        fullImageUrl = imageVal.replaceFirst('http://', 'https://');
      } else {
        fullImageUrl = imageVal;
      }
    } else {
      const String baseApiUrl = "https://willkoservices.com/willkoadmin/uploads/services";
      final String safeImageVal = imageVal.startsWith('/') ? imageVal : '/$imageVal';
      fullImageUrl = "$baseApiUrl$safeImageVal";
    }

    // URL এ কোনো স্পেস থাকলে ফিক্স করার জন্য
    try {
      fullImageUrl = Uri.encodeFull(fullImageUrl);
    } catch (e) {
      debugPrint("URL Encoding Error: $e");
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
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
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF0E6),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            (p["tag"] ?? "").toString().toUpperCase(),
                            style: GoogleFonts.poppins(
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              color: Colors.deepOrange,
                            ),
                          ),
                        ),

                      Text(
                        (p["title"] ?? p["name"] ?? "Service").toString(),
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textBlack,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),

                      // Rating
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(2),
                            decoration: const BoxDecoration(
                              color: Colors.amber,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.star,
                              size: 10,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            "${p["rating"] ?? 4.8} (${p["reviews"] ?? p["reviews_count"] ?? '100+'} reviews)",
                            style: GoogleFonts.poppins(
                              fontSize: 11,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      // QR Currency Fix
                      Text(
                        (p["priceStr"] ?? "QR 0").toString().replaceAll('SAR', 'QR'),
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textBlack,
                        ),
                      ),

                      const SizedBox(height: 8),
                      // Details
                      ...shortDetails.take(2).map(
                            (d) => Padding(
                          padding: const EdgeInsets.only(bottom: 2),
                          child: Row(
                            children: [
                              Icon(
                                Icons.check,
                                size: 12,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  d.toString(),
                                  style: GoogleFonts.poppins(
                                    fontSize: 11,
                                    color: Colors.grey[600],
                                  ),
                                  maxLines: 1,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 16),

                // Right Image & Button
                Column(
                  children: [
                    SizedBox(
                      height: 100,
                      width: 85,
                      child: Stack(
                        alignment: Alignment.topCenter,
                        clipBehavior: Clip.none,
                        children: [
                          // 🔥 100% BULLETPROOF IMAGE LOADER 🔥
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              fullImageUrl,
                              width: 85,
                              height: 85,
                              fit: BoxFit.cover,
                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Container(
                                  width: 85,
                                  height: 85,
                                  color: Colors.grey[200],
                                  child: Center(
                                    child: SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        value: loadingProgress.expectedTotalBytes != null
                                            ? loadingProgress.cumulativeBytesLoaded /
                                            (loadingProgress.expectedTotalBytes ?? 1)
                                            : null,
                                      ),
                                    ),
                                  ),
                                );
                              },
                              errorBuilder: (context, error, stackTrace) {
                                debugPrint("🔴 Image Error URL: $fullImageUrl");
                                return Container(
                                  width: 85,
                                  height: 85,
                                  color: Colors.grey[300],
                                  child: const Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.broken_image, color: Colors.grey, size: 24),
                                      SizedBox(height: 4),
                                      Text("No Image", style: TextStyle(fontSize: 9, color: Colors.grey)),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),

                          // ADD বাটন
                          Positioned(
                            bottom: -5,
                            child: InkWell(
                              onTap: () => c.quickAdd(p),
                              child: Container(
                                width: 70,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: AppColors.primary.withOpacity(0.2),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 5,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Text(
                                    "ADD +",
                                    style: GoogleFonts.poppins(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}