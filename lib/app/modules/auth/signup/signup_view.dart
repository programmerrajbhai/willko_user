import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../utils/app_colors.dart';
import 'signup_controller.dart';

class SignUpView extends StatelessWidget {
  const SignUpView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignUpController());

    return Scaffold(
      backgroundColor: Colors.white, // Clean modern background
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
          // 🔥 Premium Background Element
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
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    // 🔥 Header Icon / Logo
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
                              Icons.person_add_rounded,
                              size: 50,
                              color: AppColors.primary
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 35),

                    // 🔥 Header Text
                    Text(
                        "Create Account ✨",
                        style: GoogleFonts.manrope(
                            fontSize: 30,
                            fontWeight: FontWeight.w800,
                            color: Colors.black87,
                            letterSpacing: -0.5
                        )
                    ),
                    const SizedBox(height: 6),
                    Text(
                        "Sign up to get started",
                        style: GoogleFonts.manrope(
                            fontSize: 15,
                            color: Colors.grey.shade500,
                            fontWeight: FontWeight.w500
                        )
                    ),
                    const SizedBox(height: 40),

                    // 🔥 Name Field
                    _buildPremiumTextField(
                      controller: controller.nameController,
                      label: "Full Name",
                      hint: "Enter your full name",
                      icon: Icons.person_outline_rounded,
                    ),
                    const SizedBox(height: 20),

                    // 🔥 Email Field (NEW)
                    _buildPremiumTextField(
                      controller: controller.emailController,
                      label: "Email Address",
                      hint: "Enter your email address",
                      icon: Icons.email_outlined,
                      inputType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 20),

                    // 🔥 Phone Field
                    _buildPremiumTextField(
                      controller: controller.phoneController,
                      label: "Phone Number",
                      hint: "Enter your phone number",
                      icon: Icons.phone_android_rounded,
                      inputType: TextInputType.phone,
                    ),
                    const SizedBox(height: 20),

                    // 🔥 Password Field
                    Obx(() => _buildPremiumTextField(
                      controller: controller.passwordController,
                      label: "Password",
                      hint: "Create a strong password",
                      icon: Icons.lock_outline_rounded,
                      isPassword: true,
                      obscureText: controller.isPasswordHidden.value,
                      onTogglePassword: controller.togglePasswordVisibility,
                    )),
                    const SizedBox(height: 20),

                    // 🔥 Confirm Password Field
                    Obx(() => _buildPremiumTextField(
                      controller: controller.confirmPasswordController,
                      label: "Confirm Password",
                      hint: "Re-enter your password",
                      icon: Icons.lock_outline_rounded,
                      isPassword: true,
                      obscureText: controller.isPasswordHidden.value,
                      onTogglePassword: controller.togglePasswordVisibility,
                    )),

                    const SizedBox(height: 45),

                    // 🔥 Sign Up Button
                    SizedBox(
                      width: double.infinity,
                      height: 58,
                      child: Obx(() => ElevatedButton(
                        onPressed: controller.isLoading.value ? null : controller.register,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          elevation: controller.isLoading.value ? 0 : 5,
                          shadowColor: AppColors.primary.withOpacity(0.4),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        child: controller.isLoading.value
                            ? const SizedBox(
                            height: 24, width: 24,
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5)
                        )
                            : Text(
                            "Sign Up",
                            style: GoogleFonts.manrope(
                                fontSize: 17,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.5
                            )
                        ),
                      )),
                    ),
                    const SizedBox(height: 35),

                    // 🔥 Login Link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                            "Already have an account? ",
                            style: GoogleFonts.manrope(
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.w500,
                                fontSize: 15
                            )
                        ),
                        GestureDetector(
                          onTap: controller.goToLogin,
                          child: Text(
                              "Sign In",
                              style: GoogleFonts.manrope(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 15
                              )
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 🔥 Custom Widget for Premium Text Field
  Widget _buildPremiumTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType inputType = TextInputType.text,
    bool isPassword = false,
    bool obscureText = false,
    VoidCallback? onTogglePassword,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.manrope(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.grey.shade200, width: 1.5),
          ),
          child: TextField(
            controller: controller,
            keyboardType: inputType,
            obscureText: obscureText,
            style: GoogleFonts.manrope(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.black87),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: GoogleFonts.manrope(color: Colors.grey.shade400, fontSize: 14, fontWeight: FontWeight.w500),
              prefixIcon: Icon(icon, color: Colors.grey.shade400, size: 22),
              suffixIcon: isPassword
                  ? IconButton(
                icon: Icon(
                  obscureText ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                  color: Colors.grey.shade400,
                  size: 20,
                ),
                onPressed: onTogglePassword,
                splashRadius: 20,
              )
                  : null,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            ),
          ),
        ),
      ],
    );
  }
}