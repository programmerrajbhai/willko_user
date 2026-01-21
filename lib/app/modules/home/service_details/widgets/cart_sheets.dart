import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:willko_user/utils/app_colors.dart';
import '../service_details_controller.dart';

class MobileBottomCart extends StatelessWidget {
  final ServiceDetailsController c;
  const MobileBottomCart({required this.c, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 15, offset: const Offset(0, -5))],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () => c.openCartSheet(context),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(() => Text(
                      "SAR ${c.totalCartPrice}",
                      style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textBlack),
                    )),
                    Text("View Cart", style: GoogleFonts.poppins(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () => c.openCartSheet(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text("Proceed", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}

class CartBottomSheet extends StatelessWidget {
  final ScrollController scrollController;
  const CartBottomSheet({super.key, required this.scrollController});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<ServiceDetailsController>();

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.scaffoldBackground,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
            child: Row(
              children: [
                const Icon(Icons.shopping_bag, color: AppColors.primary),
                const SizedBox(width: 10),
                Text("Your Cart", style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)),
                const Spacer(),
                IconButton(icon: const Icon(Icons.close), onPressed: () => Get.back()),
              ],
            ),
          ),
          const Divider(),
          
          Expanded(
            child: Obx(() {
              if (c.cartItems.isEmpty) return const Center(child: Text("Cart is empty"));
              final keys = c.cartItems.keys.toList();
              return ListView.separated(
                controller: scrollController,
                padding: const EdgeInsets.all(20),
                itemCount: keys.length,
                separatorBuilder: (_, __) => const SizedBox(height: 16),
                itemBuilder: (_, index) => CartItemRow(itemKey: keys[index], item: c.cartItems[keys[index]]!, c: c),
              );
            }),
          ),
          
          Container(
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
            child: SafeArea(
              top: false,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Total"),
                      Obx(() => Text("SAR ${c.totalCartPrice}", style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold))),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: c.checkout,
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                      child: const Text("Checkout", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class CartItemRow extends StatelessWidget {
  final String itemKey;
  final Map<String, dynamic> item;
  final ServiceDetailsController c;
  const CartItemRow({required this.itemKey, required this.item, required this.c, super.key});

  @override
  Widget build(BuildContext context) {
    final title = (item['title'] ?? '').toString();
    final price = (item['priceInt'] ?? 0) as int;
    final qty = (item['quantity'] ?? 0) as int;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text("SAR $price", style: const TextStyle(color: Colors.grey)),
              ],
            ),
          ),
          Row(
            children: [
              IconButton(onPressed: () => c.updateCartQty(itemKey, qty - 1), icon: const Icon(Icons.remove_circle_outline, color: AppColors.textGrey)),
              Text("$qty", style: const TextStyle(fontWeight: FontWeight.bold)),
              IconButton(onPressed: () => c.updateCartQty(itemKey, qty + 1), icon: const Icon(Icons.add_circle, color: AppColors.primary)),
            ],
          )
        ],
      ),
    );
  }
}