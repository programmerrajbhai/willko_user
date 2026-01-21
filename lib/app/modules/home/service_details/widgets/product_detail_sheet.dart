import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:willko_user/utils/app_colors.dart';
import '../service_details_controller.dart';

class ProductDetailSheet extends StatelessWidget {
  final ScrollController scrollController;
  const ProductDetailSheet({super.key, required this.scrollController});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<ServiceDetailsController>();
    return Obx(() {
      final prod = c.selectedProductForSheet.value;
      if (prod == null) return const SizedBox.shrink();
      
      final currentQty = c.sheetTempQty.value;
      final price = (prod["priceInt"] ?? 0) as int;

      return Container(
        decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
        child: Column(
          children: [
            Align(alignment: Alignment.centerRight, child: IconButton(onPressed: () => Get.back(), icon: const Icon(Icons.close))),
            Expanded(
              child: SingleChildScrollView(
                controller: scrollController,
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text((prod["title"] ?? "").toString(), style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    Text((prod["description"] ?? "").toString(), style: const TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(24),
              child: Row(
                children: [
                  // Qty
                  Row(
                    children: [
                      IconButton(onPressed: c.decrementSheetQty, icon: const Icon(Icons.remove)),
                      Text("$currentQty", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      IconButton(onPressed: c.incrementSheetQty, icon: const Icon(Icons.add)),
                    ],
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: c.confirmSheetSelection,
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, padding: const EdgeInsets.symmetric(vertical: 16)),
                      child: Text(currentQty == 0 ? "Remove" : "Add (SAR ${price * currentQty})", style: const TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      );
    });
  }
}