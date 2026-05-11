import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:willko_user/utils/app_colors.dart'; // আপনার অ্যাপ কালার
import '../home_controller.dart';

class ServicesChipsUC extends StatelessWidget {
  final HomeController controller;
  const ServicesChipsUC({required this.controller, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 🔥 ১. SECTION TITLE (আল্ট্রা-মডার্ন হেডার)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Our Categories",
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    "Explore Services",
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF1E1E1E), // Deep Dark Color
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 20), // টাইটেল এবং চিপসের মাঝে গ্যাপ

        // 🔥 ২. CHIPS LIST (2 Items per row on Any Mobile)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Obx(() {
            // প্রো লেভেল লোডিং (Shimmer Animation)
            if (controller.isLoading.value && controller.categories.isEmpty) {
              return const _ShimmerLoadingGrid();
            }

            // ডাটা না থাকলে হাইড
            if (controller.categories.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    "No services available",
                    style: GoogleFonts.poppins(color: Colors.grey),
                  ),
                ),
              );
            }

            // মেইন ডাটা ভিউ (২টি করে আইটেম গ্রিড স্টাইলে)
            return LayoutBuilder(
                builder: (context, constraints) {
                  // স্ক্রিনের প্রস্থ অনুযায়ী প্রতিটি চিপের সাইজ বের করা
                  final double gap = 12.0; // মাঝখানের গ্যাপ
                  final double itemWidth = (constraints.maxWidth - gap) / 2; // ২ দিয়ে ভাগ

                  return Wrap(
                    spacing: gap,
                    runSpacing: 16,
                    children: List.generate(controller.categories.length, (i) {
                      final cat = controller.categories[i];
                      final bool isSelected = controller.selectedCategoryIndex.value == i;

                      return SizedBox(
                        width: itemWidth, // ফিক্সড উইডথ যাতে প্রতি লাইনে ২টি বসে
                        child: _ProServiceChip(
                          selected: isSelected,
                          imageUrl: cat['image_url'],
                          label: cat['name'] ?? "Service",
                          onTap: () => controller.onCategoryTap(i),
                        ),
                      );
                    }),
                  );
                }
            );
          }),
        ),
      ],
    );
  }
}

// 🔥 ULTRA PRO CHIP DESIGN 🔥
class _ProServiceChip extends StatelessWidget {
  final bool selected;
  final String? imageUrl;
  final String label;
  final VoidCallback onTap;

  const _ProServiceChip({
    required this.selected,
    this.imageUrl,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          gradient: selected
              ? LinearGradient(
            colors: [AppColors.primary, AppColors.primary.withOpacity(0.8)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )
              : null,
          color: selected ? null : Colors.white,
          borderRadius: BorderRadius.circular(16), // একটু স্কয়ারিশ লুক
          boxShadow: selected
              ? [BoxShadow(color: AppColors.primary.withOpacity(0.4), blurRadius: 15, offset: const Offset(0, 6))]
              : [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4))],
          border: Border.all(
            color: selected ? Colors.transparent : Colors.grey.shade200,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // ✅ Image / Icon with Animation
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: 32, // আইকনের সাইজ একটু বড়
              width: 32,
              decoration: BoxDecoration(
                color: selected ? Colors.white : Colors.grey.shade100,
                shape: BoxShape.circle,
                boxShadow: selected ? [const BoxShadow(color: Colors.black12, blurRadius: 4)] : [],
              ),
              child: ClipOval(
                child: imageUrl != null
                    ? Image.network(
                  imageUrl!,
                  fit: BoxFit.cover,
                  errorBuilder: (c, o, s) => Icon(Icons.category_rounded, size: 18, color: selected ? AppColors.primary : Colors.grey.shade600),
                )
                    : Icon(Icons.category_rounded, size: 18, color: selected ? AppColors.primary : Colors.grey.shade600),
              ),
            ),
            const SizedBox(width: 8), // টেক্সট এবং আইকনের মাঝে গ্যাপ
            // ✅ Text Style (Expanded to prevent overflow)
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                  color: selected ? Colors.white : const Color(0xFF2D3436),
                  letterSpacing: 0.3,
                ),
                maxLines: 1, // এক লাইনের বেশি হবে না
                overflow: TextOverflow.ellipsis, // বড় নাম হলে শেষে ... আসবে
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 🦴 ADVANCED SHIMMER LOADING FOR GRID 🦴
class _ShimmerLoadingGrid extends StatefulWidget {
  const _ShimmerLoadingGrid();

  @override
  State<_ShimmerLoadingGrid> createState() => _ShimmerLoadingGridState();
}

class _ShimmerLoadingGridState extends State<_ShimmerLoadingGrid> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1000))..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (context, constraints) {
          final double gap = 12.0;
          final double itemWidth = (constraints.maxWidth - gap) / 2;

          return Wrap(
            spacing: gap,
            runSpacing: 16,
            children: List.generate(6, (index) { // ৬টা ডামি কার্ড
              return FadeTransition(
                opacity: Tween<double>(begin: 0.4, end: 1.0).animate(_controller),
                child: SizedBox(
                  width: itemWidth,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade100, width: 1.5),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 32, height: 32,
                          decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Container(
                            height: 14,
                            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(6)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          );
        }
    );
  }
}