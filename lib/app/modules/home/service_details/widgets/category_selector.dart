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
      // ডাটা না থাকলে হাইড
      if (c.items.isEmpty) return const SizedBox.shrink();

      return Container(
        height: 60, // টাচ এরিয়া বাড়ানো হয়েছে
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          // নিচে হালকা বর্ডার (সেপারেটর)
          border: Border(bottom: BorderSide(color: Colors.grey.shade100, width: 1)),
        ),
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          scrollDirection: Axis.horizontal,
          itemCount: c.items.length,
          separatorBuilder: (_, __) => const SizedBox(width: 12),
          itemBuilder: (context, i) {
            final isSelected = c.selectedItemIndex.value == i;
            
            return GestureDetector(
              onTap: () => c.selectItem(i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250), // স্মুথ অ্যানিমেশন
                curve: Curves.easeOutQuad,
                padding: EdgeInsets.symmetric(
                  horizontal: isSelected ? 22 : 18, // সিলেক্ট হলে একটু বড় হবে
                  vertical: 8
                ),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : const Color(0xFFF5F7FA), // গ্রে ব্যাকগ্রাউন্ড আনসিলেক্টেড এর জন্য
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: isSelected ? Colors.transparent : Colors.transparent,
                  ),
                  // সিলেক্টেড আইটেমে গ্লো ইফেক্ট
                  boxShadow: isSelected 
                    ? [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        )
                      ] 
                    : [],
                ),
                child: Center(
                  child: Row(
                    children: [
                      // সিলেক্টেড হলে ছোট ডট ইন্ডিকেটর (অপশনাল, প্রো লুক দেয়)
                      if (isSelected) ...[
                        Container(
                          width: 6, height: 6,
                          decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                        ),
                        const SizedBox(width: 8),
                      ],
                      
                      Text(
                        c.items[i]["title"] ?? "",
                        style: GoogleFonts.poppins(
                          color: isSelected ? Colors.white : Colors.grey.shade600,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                          fontSize: 13.5,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      );
    });
  }
}