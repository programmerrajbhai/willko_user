import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../utils/app_colors.dart';
import 'cart_controller.dart';

class CartView extends StatelessWidget {
  const CartView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CartController());

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5), // হালকা ধূসর ব্যাকগ্রাউন্ড
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: Text(
          "Summary",
          style: GoogleFonts.poppins(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.cartItems.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.remove_shopping_cart_outlined, size: 80, color: Colors.grey.shade400),
                const SizedBox(height: 20),
                Text("Your cart is empty!", style: GoogleFonts.poppins(fontSize: 18, color: Colors.grey)),
              ],
            ),
          );
        }

        return Column(
          children: [
            // --- Scrollable List (Items + Bill) ---
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. Added Services List
                    Text("Added Services", style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),

                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: controller.cartItems.length,
                      itemBuilder: (context, index) {
                        var item = controller.cartItems[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 15),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              // Image
                              Container(
                                height: 60,
                                width: 60,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(item.image, color: Colors.grey),
                              ),
                              const SizedBox(width: 15),

                              // Name & Price
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(item.name, style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                                    const SizedBox(height: 5),
                                    Text("৳${item.price}", style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),

                              // Quantity Controls
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: AppColors.primary.withOpacity(0.5)),
                                  borderRadius: BorderRadius.circular(6),
                                  color: AppColors.primary.withOpacity(0.05),
                                ),
                                child: Row(
                                  children: [
                                    InkWell(
                                      onTap: () => controller.decrementQty(index),
                                      child: const Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        child: Icon(Icons.remove, size: 16, color: AppColors.primary),
                                      ),
                                    ),
                                    Text("${item.quantity}", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: AppColors.primary)),
                                    InkWell(
                                      onTap: () => controller.incrementQty(index),
                                      child: const Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        child: Icon(Icons.add, size: 16, color: AppColors.primary),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 20),

                    // 2. Bill Summary Section
                    Text("Payment Summary", style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold)),
                    // --- Coupon Section ---
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 20),
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Obx(() => Row(
                        children: [
                          const Icon(Icons.local_offer_outlined, color: AppColors.primary),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              controller.appliedCouponCode.value.isEmpty
                                  ? "Apply Coupon"
                                  : "Coupon '${controller.appliedCouponCode.value}' Applied",
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w600,
                                  color: controller.appliedCouponCode.value.isEmpty ? Colors.black87 : Colors.green
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: controller.appliedCouponCode.value.isEmpty
                                ? controller.goToCouponPage
                                : controller.removeCoupon,
                            child: Text(
                              controller.appliedCouponCode.value.isEmpty ? "Select" : "Remove",
                              style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.redAccent),
                            ),
                          )
                        ],
                      )),
                    ),

                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          _buildBillRow("Item Total", "৳${controller.itemTotal}"),
                          const SizedBox(height: 10),
                          _buildBillRow("Tax & Fee (5%)", "৳${controller.taxAmount.toStringAsFixed(0)}"),
                          const SizedBox(height: 10),
                          _buildBillRow("Discount", "- ৳${controller.discount}", isDiscount: true),
                          const Divider(height: 30),
                          _buildBillRow("Grand Total", "৳${controller.grandTotal.toStringAsFixed(0)}", isBold: true),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Safety Info
                    Row(
                      children: [
                        const Icon(Icons.security, color: Colors.green, size: 20),
                        const SizedBox(width: 8),
                        Text("Safe & Secure Payment", style: GoogleFonts.poppins(color: Colors.grey, fontSize: 12)),
                      ],
                    ),
                    const SizedBox(height: 100), // Bottom padding for button
                  ],
                ),
              ),
            ),

            // --- Fixed Bottom Button ---
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -4))],
              ),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: controller.proceedToCheckout,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "৳${controller.grandTotal.toStringAsFixed(0)}",
                        style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      Text(
                        "Proceed to Checkout >",
                        style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  // Helper Widget for Bill Row
  Widget _buildBillRow(String title, String value, {bool isBold = false, bool isDiscount = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: isBold ? 16 : 14,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            color: Colors.black87,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: isBold ? 16 : 14,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            color: isDiscount ? Colors.green : Colors.black87,
          ),
        ),
      ],
    );
  }
}