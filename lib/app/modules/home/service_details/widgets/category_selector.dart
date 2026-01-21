import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:willko_user/utils/app_colors.dart';
import '../service_details_controller.dart';

class MobileCategorySelector extends StatelessWidget {
  final ServiceDetailsController c;
  const MobileCategorySelector({required this.c, super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // যদি ক্যাটাগরি লোড না হয়
      if (c.items.isEmpty) return const SizedBox.shrink();

      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(c.items.length, (i) {
            final isSelected = c.selectedItemIndex.value == i;
            return Padding(
              padding: const EdgeInsets.only(right: 10),
              child: ChoiceChip(
                label: Text(
                  c.items[i]["title"] ?? "",
                  style: GoogleFonts.poppins(
                    color: isSelected ? Colors.white : Colors.black87,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500
                  ),
                ),
                selected: isSelected,
                selectedColor: AppColors.primary,
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(color: isSelected ? Colors.transparent : Colors.grey.shade300)
                ),
                onSelected: (bool selected) {
                  if (selected) c.selectItem(i);
                },
              ),
            );
          }),
        ),
      );
    });
  }
}