import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../home_controller.dart';

class ServicesChipsUC extends StatelessWidget {
  final HomeController controller;
  const ServicesChipsUC({required this.controller, super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // ✅ ১. যদি লোডিং চলে, তবে ফেইক চিপস (Skeleton) দেখাবে
      if (controller.isLoading.value && controller.categories.isEmpty) {
        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children: List.generate(6, (index) => _buildSkeletonChip()),
        );
      }

      // ✅ ২. ডাটা না থাকলে হাইড হয়ে যাবে
      if (controller.categories.isEmpty) return const SizedBox();

      // ✅ ৩. ডাটা আসলে রিয়েল চিপস দেখাবে
      return Wrap(
        spacing: 12,
        runSpacing: 12,
        children: List.generate(controller.categories.length, (i) {
          final cat = controller.categories[i];
          final selected = controller.selectedCategoryIndex.value == i;

          return _HoverChip(
            selected: selected,
            imageUrl: cat['image_url'],
            label: cat['name'] ?? "Service",
            onTap: () => controller.onCategoryTap(i),
          );
        }),
      );
    });
  }

  // 🦴 Skeleton Chip Widget (ডাটা আসার আগে এটা দেখাবে)
  Widget _buildSkeletonChip() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100, // হালকা ধূসর
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 18, height: 18, color: Colors.grey.shade300),
          const SizedBox(width: 10),
          Container(width: 60, height: 12, color: Colors.grey.shade300),
        ],
      ),
    );
  }
}

class _HoverChip extends StatelessWidget {
  final bool selected;
  final String? imageUrl;
  final String label;
  final VoidCallback onTap;

  const _HoverChip({required this.selected, this.imageUrl, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFEFF3FF) : const Color(0xFFF6F7FB),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: selected ? const Color(0xFF7B61FF).withOpacity(.35) : const Color(0xFFE6E8F0)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (imageUrl != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  imageUrl!, width: 20, height: 20, fit: BoxFit.cover,
                  errorBuilder: (c,o,s) => const Icon(Icons.category, size: 18, color: Colors.black54),
                ),
              )
            else
              const Icon(Icons.category, size: 18, color: Colors.black54),
            
            const SizedBox(width: 10),
            Text(label, style: GoogleFonts.poppins(fontSize: 12.8, fontWeight: FontWeight.w600, color: selected ? const Color(0xFF4A3DCC) : Colors.black87)),
          ],
        ),
      ),
    );
  }
}