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
      final items = c.items;
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: Row(
          children: [
            // 🔥 "All" Button Added
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: ChoiceChip(
                label: Text("All",
                    style: GoogleFonts.poppins(
                      color: c.selectedItemIndex.value == -1 ? Colors.white : Colors.black87,
                      fontWeight: c.selectedItemIndex.value == -1 ? FontWeight.w600 : FontWeight.w500,
                    )),
                selected: c.selectedItemIndex.value == -1,
                onSelected: (_) => c.selectItem(-1), // -1 মানে All
                selectedColor: AppColors.primary,
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(
                    color: c.selectedItemIndex.value == -1 ? AppColors.primary : Colors.grey[300]!,
                  ),
                ),
              ),
            ),

            // 🔹 বাকি ক্যাটাগরিগুলো (যেমন: Servicing, Installation ইত্যাদি)
            ...List.generate(
              items.length,
                  (index) {
                final isSelected = c.selectedItemIndex.value == index;
                final title = (items[index]["title"] ?? "Item").toString();
                return Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: ChoiceChip(
                    label: Text(title,
                        style: GoogleFonts.poppins(
                          color: isSelected ? Colors.white : Colors.black87,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                        )),
                    selected: isSelected,
                    onSelected: (_) => c.selectItem(index),
                    selectedColor: AppColors.primary,
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(
                        color: isSelected ? AppColors.primary : Colors.grey[300]!,
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      );
    });
  }
}