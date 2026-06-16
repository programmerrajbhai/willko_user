// ফাইল: lib/app/modules/auth/splash/splash_view.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'splash_controller.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    // Controller ইনজেক্ট করা হচ্ছে (Get.put)
    final SplashController controller = Get.put(SplashController());
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // 🏆 ১. প্রিমিয়াম গ্রেডিয়েন্ট ব্যাকগ্রাউন্ড
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF0B1528), // আল্ট্রা ডার্ক ব্লু
                  Color(0xFF083C76), // সিগনেচার প্রাইমারি ব্লু
                ],
              ),
            ),
          ),

          // ⚽ ব্যাকগ্রাউন্ড ফুটবল জলছাপ
          Positioned(
            right: -size.width * 0.2,
            top: -size.height * 0.05,
            child: Icon(
              Icons.sports_soccer_rounded,
              size: size.width * 0.6,
              color: Colors.white.withOpacity(0.02),
            ),
          ),

          // 🏆 ২. মেইন কন্টেন্ট (ফিক্সড অ্যানিমেশন)
          Center(
            child: TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 1200),
              curve: Curves.easeOutBack, // বাউন্সি ইফেক্ট থাকবে
              builder: (context, value, child) {
                return Opacity(
                  // 🔥 FIXED: .clamp(0.0, 1.0) দেওয়ার ফলে ভ্যালু ১ এর বেশি হয়ে ক্র্যাশ করবে না
                  opacity: value.clamp(0.0, 1.0),
                  child: Transform.scale(
                    scale: value,
                    child: child,
                  ),
                );
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 💎 লোগো সেকশন
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white.withOpacity(0.1)),
                    ),
                    child: Image.asset(
                      "assets/images/splash_logo.png",
                      width: 110,
                      height: 110,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.cleaning_services_rounded,
                          size: 70,
                          color: Color(0xFFD4AF37), // Trophy Gold
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 24),

                  // 🏆 ব্র্যান্ড নেম
                  Text(
                    "WILLKO",
                    style: GoogleFonts.montserrat(
                      fontSize: 34,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: 4,
                    ),
                  ),

                  // ✨ সাব-টাইটেল
                  Text(
                    "Premium Home Services Partner",
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: Colors.white.withOpacity(0.6),
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 🏆 ৩. বটম লোডার এবং কপিরাইট টেক্সট
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Column(
              children: [
                const SizedBox(
                  width: 30,
                  height: 30,
                  child: CircularProgressIndicator(
                    color: Color(0xFFD4AF37), // Trophy Gold
                    strokeWidth: 2.5,
                  ),
                ),
                const SizedBox(height: 25),

                Text(
                  "© 2026 Willko Services. All Rights Reserved.",
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    color: Colors.white.withOpacity(0.3),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}