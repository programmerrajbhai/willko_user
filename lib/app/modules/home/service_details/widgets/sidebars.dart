import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:willko_user/utils/app_colors.dart';
import '../service_details_controller.dart';

// Desktop Left Sidebar (Categories)
class LeftSidebar extends StatelessWidget {
  final ServiceDetailsController c;
  const LeftSidebar({required this.c, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.inputBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Service Title & Stats
          Text(c.title, style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text("⭐ ${c.rating} (${c.bookings} Bookings)", style: GoogleFonts.poppins(color: Colors.grey)),
          const Divider(height: 30),
          
          Text("Select Category", style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey)),
          const SizedBox(height: 12),

          // Categories List (Tabs)
          Obx(() => Column(
            children: List.generate(c.items.length, (i) {
              final isSelected = c.selectedItemIndex.value == i;
              return InkWell(
                onTap: () => c.selectItem(i),
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary.withOpacity(0.1) : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: isSelected ? AppColors.primary : Colors.transparent),
                  ),
                  child: Text(
                    c.items[i]["title"] ?? "",
                    style: GoogleFonts.poppins(
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected ? AppColors.primary : Colors.black87
                    ),
                  ),
                ),
              );
            }),
          )),
        ],
      ),
    );
  }
}

// Desktop Right Sidebar (Cart) - আগের মতোই আছে
class RightSidebar extends StatelessWidget {
  final ServiceDetailsController c;
  const RightSidebar({required this.c, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Obx(() {
          if (c.totalCartPrice == 0) return const SizedBox.shrink();
          return ElevatedButton(
            onPressed: () => c.openCartSheet(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Total: SAR ${c.totalCartPrice}", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.white)),
                const Text("View Cart >", style: TextStyle(color: Colors.white)),
              ],
            ),
          );
        }),
      ],
    );
  }
}