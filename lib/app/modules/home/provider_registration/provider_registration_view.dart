import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../../utils/app_colors.dart';
// আপনার এপিআই সার্ভিসের লোকেশন ঠিক থাকলে নিচের লাইনটি কাজ করবে
import '../../../data/services/api_service.dart';

class ProviderRegistrationView extends StatefulWidget {
  const ProviderRegistrationView({super.key});

  @override
  State<ProviderRegistrationView> createState() => _ProviderRegistrationViewState();
}

class _ProviderRegistrationViewState extends State<ProviderRegistrationView> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController whatsappController = TextEditingController();
  final TextEditingController qidController = TextEditingController();
  final TextEditingController expController = TextEditingController();
  final TextEditingController categoryController = TextEditingController(); // 🔥 ড্রপডাউনের বদলে নতুন ফিল্ড

  bool _isSubmitting = false;

  // ✅ ১০০% সেফ এবং বুলেটপ্রুফ সাবমিট ফাংশন
  Future<void> _submitApplication() async {
    // কিবোর্ড হাইড করা
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    try {
      final Map<String, String> requestBody = {
        "full_name": nameController.text.trim(),
        "whatsapp_number": whatsappController.text.trim(),
        "qid_number": qidController.text.trim(),
        "category": categoryController.text.trim(), // 🔥 ইউজারের টাইপ করা ডাটা
        "experience": expController.text.trim(),
      };

      print("📤 Sending Data: $requestBody"); // Debugging

      final response = await http.post(
        Uri.parse("https://willkoservices.com/WillkoServiceApi/api/user/auth/register_provider.php"),
        body: requestBody,
      ).timeout(const Duration(seconds: 15));

      print("📥 Response Status: ${response.statusCode}"); // Debugging
      print("📥 Response Body: ${response.body}"); // Debugging

      if (response.statusCode != 200) {
        Get.snackbar(
          "Server Error ${response.statusCode}",
          "Could not connect to the server. Check API URL.",
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
        setState(() => _isSubmitting = false);
        return;
      }

      final result = jsonDecode(response.body);

      if (result['status'] == 'success') {
        _showModernDoneDialog(); // 🔥 মডার্ন ডায়লগ কল করা হলো
      } else {
        Get.snackbar(
          "Submission Failed",
          result['message'] ?? "Unknown error from server",
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      print("❌ Crash Error: $e");

      Get.snackbar(
        "Oops!",
        "Something went wrong. Check your internet or API.",
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    whatsappController.dispose();
    qidController.dispose();
    expController.dispose();
    categoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Partner Registration",
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 16, color: Colors.black)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Apply to Join Willko",
                style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.primary),
              ),
              Text(
                "Fill in the details below to register as a service provider.",
                style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 25),

              _buildInputLabel("Full Name"),
              _buildTextField(
                  controller: nameController,
                  hint: "Your name as per QID",
                  icon: Icons.person_outline
              ),

              const SizedBox(height: 16),
              _buildInputLabel("Qatar ID (QID)"),
              _buildTextField(
                  controller: qidController,
                  hint: "Enter your 11-digit QID number",
                  icon: Icons.badge_outlined,
                  keyboardType: TextInputType.number,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return "QID is required";
                    if (v.trim().length != 11) return "QID must be exactly 11 digits";
                    return null;
                  }
              ),

              const SizedBox(height: 16),
              _buildInputLabel("WhatsApp Number"),
              _buildTextField(
                  controller: whatsappController,
                  hint: "Active WhatsApp number",
                  icon: Icons.phone_android,
                  keyboardType: TextInputType.phone
              ),

              const SizedBox(height: 16),
              _buildInputLabel("Service Category"),
              // 🔥 ড্রপডাউনের বদলে লেখার বক্স
              _buildTextField(
                  controller: categoryController,
                  hint: "Ex: AC Servicing, Cleaning, Plumbing",
                  icon: Icons.category_outlined
              ),

              const SizedBox(height: 16),
              _buildInputLabel("Experience"),
              _buildTextField(
                  controller: expController,
                  hint: "Ex: 3 Years",
                  icon: Icons.history_edu_outlined
              ),

              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submitApplication,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    elevation: 0,
                  ),
                  child: _isSubmitting
                      ? const SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                  )
                      : Text("Submit Application",
                      style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: Text(label, style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.grey.shade800)),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      style: GoogleFonts.poppins(fontSize: 14),
      decoration: _inputDecoration(hint, icon),
      validator: validator ?? (v) => v!.trim().isEmpty ? "Required" : null,
    );
  }

  InputDecoration _inputDecoration(String? hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon, size: 22, color: Colors.grey.shade500),
      hintStyle: GoogleFonts.poppins(fontSize: 13, color: Colors.grey.shade400),
      filled: true,
      fillColor: const Color(0xFFF8F9FA),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.grey.shade200, width: 1)
      ),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5)
      ),
      errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1)
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 16),
    );
  }

  // ========================================================
  // 🔥 SMART & MODERN SUCCESS ALERT DIALOG 🔥
  // ========================================================
  void _showModernDoneDialog() {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: const [
              BoxShadow(color: Colors.black26, blurRadius: 20, offset: Offset(0, 10)),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Premium Check Icon Setup
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check_circle, color: Colors.green, size: 60),
              ),
              const SizedBox(height: 24),

              Text(
                "Application Received!",
                style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              const SizedBox(height: 12),

              Text(
                "Thank you for joining Willko.\nOur team will verify your QID and contact you on WhatsApp soon.",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey.shade600, height: 1.5),
              ),
              const SizedBox(height: 32),

              // Custom Dialog Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Get.back(); // ডায়লগ বন্ধ করবে
                    Get.back(); // আগের পেজ (হোম) এ ফেরত যাবে
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  child: Text(
                    "Back to Home",
                    style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false, // বাইরে ক্লিক করলে কাটবে না
    );
  }
}