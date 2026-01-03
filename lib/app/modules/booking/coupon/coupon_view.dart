import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../utils/app_colors.dart';
import 'coupon_controller.dart';

class CouponView extends StatelessWidget {
  final double cartTotal; // কার্ট থেকে টোটাল এমাউন্ট আসবে ভ্যালিডেশনের জন্য

  const CouponView({super.key, required this.cartTotal});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CouponController());

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Get.back(),
        ),
        title: Text(
          "Apply Coupon",
          style: GoogleFonts.poppins(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- 1. Input Field ---
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10)],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller.couponInputController,
                      style: GoogleFonts.poppins(fontWeight: FontWeight.bold, letterSpacing: 1.5),
                      decoration: InputDecoration(
                        hintText: "Enter Coupon Code",
                        hintStyle: GoogleFonts.poppins(fontWeight: FontWeight.normal, letterSpacing: 0, color: Colors.grey),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  Obx(() => TextButton(
                    onPressed: controller.isLoading.value
                        ? null
                        : () => controller.applyCoupon(controller.couponInputController.text, cartTotal),
                    child: controller.isLoading.value
                        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                        : Text("APPLY", style: GoogleFonts.poppins(color: AppColors.primary, fontWeight: FontWeight.bold)),
                  )),
                ],
              ),
            ),

            const SizedBox(height: 30),
            Text("Available Offers", style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),

            // --- 2. Coupon List ---
            Expanded(
              child: ListView.builder(
                itemCount: controller.availableCoupons.length,
                itemBuilder: (context, index) {
                  var coupon = controller.availableCoupons[index];
                  return GestureDetector(
                    onTap: () {
                      // ট্যাপ করলে অটোমেটিক ইনপুট ফিল্ডে কোড বসে যাবে এবং অ্যাপ্লাই হবে
                      controller.couponInputController.text = coupon['code'];
                      controller.applyCoupon(coupon['code'], cartTotal);
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 15),
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade200), // Dotted border would be nicer
                      ),
                      child: Row(
                        children: [
                          // Left Icon Part
                          Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.local_offer, color: AppColors.primary),
                          ),
                          const SizedBox(width: 15),

                          // Details
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  coupon['code'],
                                  style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  coupon['title'],
                                  style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 13),
                                ),
                                Text(
                                  coupon['description'],
                                  style: GoogleFonts.poppins(color: Colors.grey, fontSize: 12),
                                ),
                              ],
                            ),
                          ),

                          // Apply Text
                          Text(
                            "APPLY",
                            style: GoogleFonts.poppins(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 13),
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}