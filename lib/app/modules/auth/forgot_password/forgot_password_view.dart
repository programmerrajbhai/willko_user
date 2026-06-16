import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../utils/app_colors.dart';
import 'forgot_password_controller.dart';

class ForgotPasswordView extends StatelessWidget {
  const ForgotPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ForgotPasswordController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black87, size: 22),
          onPressed: () => Get.back(),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Positioned(
            top: -100,
            right: -50,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withOpacity(0.05),
              ),
            ),
          ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Hero(
                        tag: 'auth_icon',
                        child: Container(
                          padding: const EdgeInsets.all(22),
                          decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.08),
                              shape: BoxShape.circle,
                              border: Border.all(color: AppColors.primary.withOpacity(0.2), width: 1.5),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primary.withOpacity(0.15),
                                  blurRadius: 30,
                                  offset: const Offset(0, 10),
                                )
                              ]
                          ),
                          child: const Icon(
                              Icons.lock_reset_rounded,
                              size: 55,
                              color: AppColors.primary
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 35),
                    Text(
                        "Reset Password 🔐",
                        style: GoogleFonts.manrope(
                            fontSize: 30,
                            fontWeight: FontWeight.w800,
                            color: Colors.black87,
                            letterSpacing: -0.5
                        )
                    ),
                    const SizedBox(height: 6),
                    Text(
                        "Enter your email to receive an OTP",
                        style: GoogleFonts.manrope(
                            fontSize: 15,
                            color: Colors.grey.shade500,
                            fontWeight: FontWeight.w500
                        )
                    ),
                    const SizedBox(height: 45),

                    // Email Field
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Email Address", style: GoogleFonts.manrope(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.black87)),
                        const SizedBox(height: 8),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: Colors.grey.shade200, width: 1.5),
                          ),
                          child: TextField(
                            controller: controller.emailController,
                            keyboardType: TextInputType.emailAddress,
                            style: GoogleFonts.manrope(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.black87),
                            decoration: InputDecoration(
                              hintText: "Enter your registered email",
                              hintStyle: GoogleFonts.manrope(color: Colors.grey.shade400, fontSize: 14, fontWeight: FontWeight.w500),
                              prefixIcon: Icon(Icons.email_outlined, color: Colors.grey.shade400, size: 22),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 35),

                    // Send Code Button
                    SizedBox(
                      width: double.infinity,
                      height: 58,
                      child: Obx(() => ElevatedButton(
                        onPressed: controller.isLoading.value ? null : controller.sendOtp,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          elevation: controller.isLoading.value ? 0 : 5,
                          shadowColor: AppColors.primary.withOpacity(0.4),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        child: controller.isLoading.value
                            ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
                            : Text("Send OTP", style: GoogleFonts.manrope(fontSize: 17, fontWeight: FontWeight.w800, letterSpacing: 0.5)),
                      )),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}