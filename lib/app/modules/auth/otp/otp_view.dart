import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../utils/app_colors.dart';
import 'otp_controller.dart';

class OtpView extends StatelessWidget {
  const OtpView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OtpController());

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.textBlack),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          children: [
            const SizedBox(height: 20),

            // Icon
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.mark_email_read_rounded, size: 50, color: AppColors.primary),
            ),
            const SizedBox(height: 30),

            // Texts
            Text(
              "Verification Code",
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textBlack,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "We have sent the code verification to\nyour mobile number",
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(color: AppColors.textGrey),
            ),
            const SizedBox(height: 40),

            // OTP Input Field (Custom Style)
            // এখানে আমরা একটি লেটার স্পেসিং সহ ইনপুট ফিল্ড দিচ্ছি যা দেখতে OTP বক্সের মতো লাগবে
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: AppColors.inputBorder),
              ),
              child: TextField(
                onChanged: (val) => controller.otpCode.value = val,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 15, // ডিজিটগুলোর মাঝে গ্যাপ
                ),
                maxLength: 6, // 4 বা 6 ডিজিট
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  counterText: "", // নিচে কাউন্টার টেক্সট হাইড করা
                  hintText: "- - - - - -",
                  hintStyle: TextStyle(letterSpacing: 15),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Verify Button
            SizedBox(
              width: double.infinity,
              height: 55,
              child: Obx(() => ElevatedButton(
                onPressed: controller.isLoading.value ? null : controller.verifyOtp,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: controller.isLoading.value
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(
                  "VERIFY",
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              )),
            ),
            const SizedBox(height: 30),

            // Resend Timer
            Obx(() => controller.isResendEnabled.value
                ? TextButton(
              onPressed: controller.resendCode,
              child: Text(
                "Resend Code",
                style: GoogleFonts.poppins(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold
                ),
              ),
            )
                : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Resend code in ",
                  style: GoogleFonts.poppins(color: AppColors.textGrey),
                ),
                Text(
                  "00:${controller.timerValue.value.toString().padLeft(2, '0')}",
                  style: GoogleFonts.poppins(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            )
            ),
          ],
        ),
      ),
    );
  }
}