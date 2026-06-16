import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../utils/app_colors.dart';
import 'forgot_password_controller.dart';

class ResetPasswordView extends StatelessWidget {
  const ResetPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ForgotPasswordController>();

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
                    Text(
                        "Create New Password 🔒",
                        style: GoogleFonts.manrope(
                            fontSize: 30,
                            fontWeight: FontWeight.w800,
                            color: Colors.black87,
                            letterSpacing: -0.5
                        )
                    ),
                    const SizedBox(height: 6),
                    Text(
                        "Your new password must be different from previously used passwords.",
                        style: GoogleFonts.manrope(
                            fontSize: 15,
                            color: Colors.grey.shade500,
                            fontWeight: FontWeight.w500
                        )
                    ),
                    const SizedBox(height: 45),

                    // New Password Field
                    Obx(() => _buildPasswordField(
                      controller: controller.newPasswordController,
                      label: "New Password",
                      hint: "Enter new password",
                      obscureText: controller.isPasswordHidden.value,
                      onToggle: controller.togglePasswordVisibility,
                    )),
                    const SizedBox(height: 20),

                    // Confirm Password Field
                    Obx(() => _buildPasswordField(
                      controller: controller.confirmPasswordController,
                      label: "Confirm Password",
                      hint: "Re-enter new password",
                      obscureText: controller.isPasswordHidden.value,
                      onToggle: controller.togglePasswordVisibility,
                    )),
                    const SizedBox(height: 45),

                    // Reset Button
                    SizedBox(
                      width: double.infinity,
                      height: 58,
                      child: Obx(() => ElevatedButton(
                        onPressed: controller.isLoading.value ? null : controller.resetPassword,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          elevation: controller.isLoading.value ? 0 : 5,
                          shadowColor: AppColors.primary.withOpacity(0.4),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        child: controller.isLoading.value
                            ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
                            : Text("Update Password", style: GoogleFonts.manrope(fontSize: 17, fontWeight: FontWeight.w800, letterSpacing: 0.5)),
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

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required bool obscureText,
    required VoidCallback onToggle,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.manrope(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.black87)),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.grey.shade200, width: 1.5),
          ),
          child: TextField(
            controller: controller,
            obscureText: obscureText,
            style: GoogleFonts.manrope(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.black87),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: GoogleFonts.manrope(color: Colors.grey.shade400, fontSize: 14, fontWeight: FontWeight.w500),
              prefixIcon: Icon(Icons.lock_outline_rounded, color: Colors.grey.shade400, size: 22),
              suffixIcon: IconButton(
                icon: Icon(obscureText ? Icons.visibility_off_rounded : Icons.visibility_rounded, color: Colors.grey.shade400, size: 20),
                onPressed: onToggle,
                splashRadius: 20,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            ),
          ),
        ),
      ],
    );
  }
}