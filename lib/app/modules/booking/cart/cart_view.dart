import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../utils/app_colors.dart'; // আপনার কালার ফাইল
import 'cart_controller.dart';

class CartView extends GetView<CartController> {
  const CartView({super.key});

  @override
  Widget build(BuildContext context) {
    // GetView ব্যবহার করায় controller ভেরিয়েবল অটোমেটিক পাওয়া যাবে

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        title: const Text("My Cart"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        if (controller.cartItems.isEmpty) {
          return _buildEmptyCart();
        }

        return Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- 1. Cart Items List ---
                    Text("Selected Services", 
                      style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textBlack)
                    ),
                    const SizedBox(height: 15),
                    
                    ...controller.cartItems.asMap().entries.map((entry) {
                      return _buildCartItem(entry.value, entry.key);
                    }),

                    const SizedBox(height: 25),

                    // --- 2. Coupon Section (Redesigned) ---
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.inputBorder),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.confirmation_num_outlined, color: AppColors.primary),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  controller.appliedCouponCode.value.isEmpty ? "Have a Coupon?" : "Coupon Applied",
                                  style: const TextStyle(fontSize: 12, color: AppColors.textGrey),
                                ),
                                Text(
                                  controller.appliedCouponCode.value.isEmpty ? "Apply now for discount" : controller.appliedCouponCode.value,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: controller.appliedCouponCode.value.isEmpty ? AppColors.textBlack : AppColors.secondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          TextButton(
                            onPressed: controller.appliedCouponCode.value.isEmpty ? controller.goToCouponPage : controller.removeCoupon,
                            child: Text(
                              controller.appliedCouponCode.value.isEmpty ? "APPLY" : "REMOVE",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: controller.appliedCouponCode.value.isEmpty ? AppColors.primary : Colors.red,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),

                    const SizedBox(height: 25),

                    // --- 3. Bill Summary ---
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 15, offset: const Offset(0, 5)),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildBillRow("Item Total", "৳${controller.itemTotal}"),
                          const SizedBox(height: 12),
                          _buildBillRow("Tax (5%)", "৳${controller.taxAmount.toStringAsFixed(0)}"),
                          const SizedBox(height: 12),
                          if (controller.discount.value > 0)
                            _buildBillRow("Discount", "- ৳${controller.discount}", color: AppColors.secondary),
                          
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            child: Divider(),
                          ),
                          
                          _buildBillRow("Grand Total", "৳${controller.grandTotal.toStringAsFixed(0)}", isBold: true, size: 18),
                        ],
                      ),
                    ),
                    const SizedBox(height: 100), // Bottom padding
                  ],
                ),
              ),
            ),

            // --- Bottom Bar ---
            _buildBottomBar(controller),
          ],
        );
      }),
    );
  }

  // --- Helper Widgets ---

  Widget _buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(25),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.shopping_basket_outlined, size: 60, color: AppColors.primary),
          ),
          const SizedBox(height: 20),
          Text("Your cart is empty!", style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          const Text("Add some services to get started.", style: TextStyle(color: AppColors.textGrey)),
        ],
      ),
    );
  }

  Widget _buildCartItem(var item, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Row(
        children: [
          // Image Box
          Container(
            height: 70, width: 70,
            decoration: BoxDecoration(
              color: AppColors.scaffoldBackground,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(item.image, color: AppColors.textGrey, size: 30),
          ),
          const SizedBox(width: 15),

          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                const SizedBox(height: 6),
                Text("৳${item.price}", style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
              ],
            ),
          ),

          // Quantity Buttons (Modern Pill Shape)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.scaffoldBackground,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              children: [
                _qtyBtn(Icons.remove, () => controller.decrementQty(index)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text("${item.quantity}", style: const TextStyle(fontWeight: FontWeight.bold)),
                ),
                _qtyBtn(Icons.add, () => controller.incrementQty(index)),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _qtyBtn(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
        child: Icon(icon, size: 16, color: AppColors.textBlack),
      ),
    );
  }

  Widget _buildBillRow(String title, String value, {bool isBold = false, Color? color, double size = 14}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: TextStyle(fontSize: size, color: AppColors.textGrey, fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
        Text(value, style: TextStyle(fontSize: size, color: color ?? AppColors.textBlack, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildBottomBar(CartController controller) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, -5))],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Total Price", style: TextStyle(fontSize: 12, color: AppColors.textGrey)),
                Text("৳${controller.grandTotal.toStringAsFixed(0)}", 
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textBlack)
                ),
              ],
            ),
          ),
          Expanded(
            child: ElevatedButton(
              onPressed: controller.proceedToCheckout,
              child: const Text("Checkout"),
            ),
          ),
        ],
      ),
    );
  }
}