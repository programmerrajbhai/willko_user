import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../utils/app_colors.dart';
import '../../home/home_view.dart';


class OrderSuccessView extends StatelessWidget {
  const OrderSuccessView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // --- 1. Lottie Animation ---
            SizedBox(
              height: 200,
              width: 200,
              child: Lottie.asset(
                'assets/animations/success.json', // আপনার ডাউনলোড করা ফাইল
                repeat: false, // একবারই প্লে হবে
                errorBuilder: (context, error, stackTrace) {
                  // যদি ফাইল না থাকে তবে এই আইকন দেখাবে
                  return const Icon(Icons.check_circle, color: Colors.green, size: 100);
                },
              ),
            ),

            const SizedBox(height: 30),

            // --- 2. Success Text ---
            Text(
              "Booking Confirmed!",
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Your service has been scheduled successfully.\nOur professional will arrive on time.",
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.grey,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 50),

            // --- 3. Buttons ---
            // View Order Details Button (Optional)
            OutlinedButton(
              onPressed: () {
                // TODO: Go to Order History Page
                Get.snackbar("Info", "Order History page coming soon!");
              },
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.primary),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                minimumSize: const Size(double.infinity, 50),
              ),
              child: Text(
                "View Booking Details",
                style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primary),
              ),
            ),

            const SizedBox(height: 15),

            // Back to Home Button
            ElevatedButton(
              onPressed: () {
                // পেছনের সব স্ট্যাক ক্লিয়ার করে হোমে যাবে
                Get.offAll(() => const HomeView());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                minimumSize: const Size(double.infinity, 50),
              ),
              child: Text(
                "Back to Home",
                style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}