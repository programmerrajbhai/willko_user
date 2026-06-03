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
        // 🔥 ১. SECTION TITLE
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
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
                  color: const Color(0xFF1E1E1E),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        // 🔥 ২. CHIPS LIST (Responsive Grid)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Obx(() {
            if (controller.isLoading.value && controller.categories.isEmpty) {
              return const _ShimmerLoadingGrid();
            }

            if (controller.categories.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text("No services available",
                      style: GoogleFonts.poppins(color: Colors.grey)),
                ),
              );
            }

            return LayoutBuilder(builder: (context, constraints) {
              final double gap = 12.0;
              final double itemWidth = (constraints.maxWidth - gap) / 2;

              return Wrap(
                spacing: gap,
                runSpacing: 12,
                children: List.generate(controller.categories.length, (i) {
                  final cat = controller.categories[i];
                  final bool isSelected = controller.selectedCategoryIndex.value == i;

                  return SizedBox(
                    width: itemWidth,
                    child: _ProServiceChip(
                      selected: isSelected,
                      label: cat['name'] ?? "Service",
                      onTap: () => controller.onCategoryTap(i),
                    ),
                  );
                }),
              );
            });
          }),
        ),
      ],
    );
  }
}

// 🔥 ULTRA PRO CHIP DESIGN (With Icon & Text Start & Multi-line) 🔥
class _ProServiceChip extends StatelessWidget {
  final bool selected;
  final String label;
  final VoidCallback onTap;

  const _ProServiceChip({
    required this.selected,
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
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          gradient: selected
              ? LinearGradient(
            colors: [AppColors.primary, AppColors.primary.withOpacity(0.8)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )
              : null,
          color: selected ? null : Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: selected
              ? [BoxShadow(color: AppColors.primary.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 4))]
              : [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 6, offset: const Offset(0, 2))],
          border: Border.all(
            color: selected ? Colors.transparent : Colors.grey.shade200,
            width: 1,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 🔹 ৪-ডট আইকন (Grid View)
            Icon(
              Icons.grid_view_rounded,
              size: 16,
              color: selected ? Colors.white : AppColors.primary,
            ),
            const SizedBox(width: 8), // আইকন ও টেক্সটের মাঝে গ্যাপ

            // 🔹 টেক্সট সেকশন (Start Alignment & Multi-line Support)
            Expanded(
              child: Text(
                label,
                textAlign: TextAlign.start,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                  color: selected ? Colors.white : const Color(0xFF2D3436),
                  height: 1.2, // লাইনের স্পেসিং পারফেক্ট করার জন্য
                ),
                maxLines: 2, // বড় টেক্সট হলে পরের লাইনে যাবে
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 🦴 SHIMMER LOADING (Updated with Icon Space) 🦴
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
    return LayoutBuilder(builder: (context, constraints) {
      final double gap = 12.0;
      final double itemWidth = (constraints.maxWidth - gap) / 2;

      return Wrap(
        spacing: gap,
        runSpacing: 12,
        children: List.generate(6, (index) {
          return FadeTransition(
            opacity: Tween<double>(begin: 0.4, end: 1.0).animate(_controller),
            child: SizedBox(
              width: itemWidth,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // ডামি আইকন
                    Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // ডামি টেক্সট
                    Expanded(
                      child: Container(
                        height: 12,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      );
    });
  }
}