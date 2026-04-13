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
              // Optional: See All Button
              InkWell(
                onTap: () {},
                borderRadius: BorderRadius.circular(20),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Text(
                    "See All",
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 20), // টাইটেল এবং চিপসের মাঝে গ্যাপ

        // 🔥 ২. CHIPS LIST (Vertically Wrapped)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Obx(() {
            // প্রো লেভেল লোডিং (Shimmer Animation)
            if (controller.isLoading.value && controller.categories.isEmpty) {
              return const _ShimmerLoadingChips();
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

            // মেইন ডাটা ভিউ (Wrap ব্যবহার করা হয়েছে যাতে নিচে নিচে বসে)
            return Wrap(
              spacing: 12, // ডানে-বামে গ্যাপ
              runSpacing: 16, // উপর-নিচে গ্যাপ
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          // ✅ Background Color Logic (Gradient for Selected)
          gradient: selected
              ? LinearGradient(
            colors: [
              AppColors.primary,
              AppColors.primary.withOpacity(0.8),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )
              : null,
          color: selected ? null : Colors.white,
          borderRadius: BorderRadius.circular(30),

          // ✅ Pro Shadow Effect
          boxShadow: selected
              ? [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.4),
              blurRadius: 15,
              spreadRadius: 1,
              offset: const Offset(0, 6),
            )
          ]
              : [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // ✅ Image / Icon with Animation
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: 28,
              width: 28,
              decoration: BoxDecoration(
                color: selected ? Colors.white : Colors.grey.shade100,
                shape: BoxShape.circle,
                boxShadow: selected
                    ? [const BoxShadow(color: Colors.black12, blurRadius: 4)]
                    : [],
              ),
              child: ClipOval(
                child: imageUrl != null
                    ? Image.network(
                  imageUrl!,
                  fit: BoxFit.cover,
                  errorBuilder: (c, o, s) => Icon(
                    Icons.category_rounded,
                    size: 16,
                    color: selected ? AppColors.primary : Colors.grey.shade600,
                  ),
                )
                    : Icon(
                  Icons.category_rounded,
                  size: 16,
                  color: selected ? AppColors.primary : Colors.grey.shade600,
                ),
              ),
            ),

            const SizedBox(width: 10),

            // ✅ Text Style
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
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

// 🦴 ADVANCED SHIMMER LOADING (Updated for Vertical Wrap) 🦴
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
    // শিমারটিকেও Wrap এ কনভার্ট করা হয়েছে যাতে রিয়েল ডাটার মতো দেখায়
    return Wrap(
      spacing: 12,
      runSpacing: 16,
      children: List.generate(6, (index) { // ৬টা ডামি চিপ দেখাবে
        return FadeTransition(
          opacity: Tween<double>(begin: 0.4, end: 1.0).animate(_controller),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: Colors.grey.shade100, width: 1.5),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 28, height: 28,
                  decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                ),
                const SizedBox(width: 10),
                Container(
                  width: 60, height: 14,
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(6)),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}