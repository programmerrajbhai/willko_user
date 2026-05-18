// ফাইল: lib/app/modules/booking/success/order_success_view.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../utils/app_colors.dart';
import '../../home/home_view.dart';
import '../../order/my_orders_view.dart';

class OrderSuccessView extends StatelessWidget {
  const OrderSuccessView({super.key});

  @override
  Widget build(BuildContext context) {
    // 🔥 GetX Argument থেকে ডাটা রিসিভ করা হচ্ছে
    final Map<String, dynamic> args = Get.arguments ?? {};
    final String orderId = args['orderId']?.toString() ?? "WK-12345";
    final double totalAmount = (args['totalAmount'] as num?)?.toDouble() ?? 0.0;

    final String displayOrderId = orderId.startsWith('#') ? orderId : "#ORD-$orderId";

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),

              // --- 1. Animation Section ---
              Center(
                child: SizedBox(
                  height: 180,
                  width: 180,
                  child: Lottie.asset(
                    'assets/animations/success.json',
                    repeat: false,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        padding: const EdgeInsets.all(30),
                        decoration: BoxDecoration(color: Colors.green.shade50, shape: BoxShape.circle),
                        child: Icon(Icons.check_rounded, color: Colors.green.shade600, size: 80),
                      );
                    },
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // --- 2. Title & Message ---
              Text(
                "Booking Confirmed!",
                textAlign: TextAlign.center,
                style: GoogleFonts.manrope(fontSize: 26, fontWeight: FontWeight.w800, color: Colors.black87, letterSpacing: -0.5),
              ),
              const SizedBox(height: 12),
              Text(
                "Your service request has been successfully placed. We've sent a confirmation email.",
                textAlign: TextAlign.center,
                style: GoogleFonts.manrope(fontSize: 15, color: Colors.grey.shade600, height: 1.5),
              ),

              const SizedBox(height: 30),

              // --- 3. Order Info Card ---
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFF9FAFB),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  children: [
                    _buildInfoRow("Booking ID", displayOrderId, isBold: true),
                    const Divider(height: 24, color: Color(0xFFEEEEEE)),
                    _buildInfoRow("Total Amount", "QR ${totalAmount.toStringAsFixed(2)}"),
                    const SizedBox(height: 12),
                    _buildInfoRow("Payment Status", "Pending"),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // --- 4. Action Buttons ---
              SizedBox(
                width: double.infinity,
                height: 55,
                child: OutlinedButton(
                  onPressed: () {
                    Get.off(() => const MyOrdersView());
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.primary, width: 1.5),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: Text(
                    "View Booking Details",
                    style: GoogleFonts.manrope(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.primary),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Back to Home
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () {
                    Get.offAll(() => const HomeView());
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    elevation: 5,
                    shadowColor: AppColors.primary.withOpacity(0.3),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: Text(
                    "Back to Home",
                    style: GoogleFonts.manrope(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: GoogleFonts.manrope(fontSize: 14, color: Colors.grey.shade500, fontWeight: FontWeight.w500)),
        Text(value, style: GoogleFonts.manrope(fontSize: 14, color: isBold ? Colors.black87 : Colors.black54, fontWeight: isBold ? FontWeight.w800 : FontWeight.w600)),
      ],
    );
  }
}