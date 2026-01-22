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
    return Obx(() {
      // ✅ ১. প্রো লেভেল লোডিং (Shimmer Animation)
      if (controller.isLoading.value && controller.categories.isEmpty) {
        return const _ShimmerLoadingChips();
      }

      // ✅ ২. ডাটা না থাকলে হাইড
      if (controller.categories.isEmpty) return const SizedBox();

      // ✅ ৩. মেইন ডাটা ভিউ
      return Wrap(
        spacing: 12,
        runSpacing: 12,
        children: List.generate(controller.categories.length, (i) {
          final cat = controller.categories[i];
          final bool isSelected = controller.selectedCategoryIndex.value == i;

          return _ProServiceChip(
            selected: isSelected,
            imageUrl: cat['image_url'],
            label: cat['name'] ?? "Service",
            onTap: () => controller.onCategoryTap(i),
          );
        }),
      );
    });
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          // ✅ Background Color Logic
          color: selected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(30),
          
          // ✅ Pro Shadow Effect
          boxShadow: [
            if (selected)
              BoxShadow(
                color: AppColors.primary.withOpacity(0.4),
                blurRadius: 12,
                offset: const Offset(0, 6),
              )
            else
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
          ],
          
          // ✅ Subtle Border for Unselected State
          border: Border.all(
            color: selected ? Colors.transparent : Colors.grey.shade200,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ✅ Image / Icon with Animation
            Container(
              height: 24, width: 24,
              decoration: BoxDecoration(
                color: selected ? Colors.white.withOpacity(0.2) : Colors.grey.shade100,
                shape: BoxShape.circle,
              ),
              child: ClipOval(
                child: imageUrl != null
                    ? Image.network(
                        imageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (c, o, s) => Icon(
                          Icons.category_rounded,
                          size: 14,
                          color: selected ? Colors.white : Colors.grey.shade600,
                        ),
                      )
                    : Icon(
                        Icons.category_rounded,
                        size: 14,
                        color: selected ? Colors.white : Colors.grey.shade600,
                      ),
              ),
            ),
            
            const SizedBox(width: 10),
            
            // ✅ Text Style
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: selected ? Colors.white : const Color(0xFF2D3436),
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 🦴 ADVANCED SHIMMER LOADING 🦴
class _ShimmerLoadingChips extends StatefulWidget {
  const _ShimmerLoadingChips();

  @override
  State<_ShimmerLoadingChips> createState() => _ShimmerLoadingChipsState();
}

class _ShimmerLoadingChipsState extends State<_ShimmerLoadingChips> with SingleTickerProviderStateMixin {
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
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: List.generate(5, (index) {
        return FadeTransition(
          opacity: Tween<double>(begin: 0.4, end: 1.0).animate(_controller),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 24, height: 24,
                  decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                ),
                const SizedBox(width: 10),
                Container(
                  width: 60, height: 12,
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4)),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}