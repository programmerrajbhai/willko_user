import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../../utils/app_colors.dart';
import '../../../data/services/api_service.dart';

class ProviderRegistrationView extends StatefulWidget {
  const ProviderRegistrationView({super.key});

  @override
  State<ProviderRegistrationView> createState() => _ProviderRegistrationViewState();
}

class _ProviderRegistrationViewState extends State<ProviderRegistrationView> {
  final _formKey = GlobalKey<FormState>();

  // ✅ TextEditingControllers (QID সহ)
  final TextEditingController nameController = TextEditingController();
  final TextEditingController whatsappController = TextEditingController();
  final TextEditingController qidController = TextEditingController(); // 🔥 New QID Controller
  final TextEditingController expController = TextEditingController();

  String? selectedCategory;
  bool _isSubmitting = false;

  final List<String> categories = [
    "AC Servicing",
    "Installation",
    "Gas Refill",
    "Cleaning",
    "Plumbing"
  ];

  // ✅ ডাটাবেসে ডাটা সেভ করার ফাংশন
  Future<void> _submitApplication() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    try {
      final response = await http.post(
        Uri.parse("${ApiService.baseUrl}/user/auth/register_provider.11"),
        body: {
          "full_name": nameController.text.trim(),
          "whatsapp_number": whatsappController.text.trim(),
          "qid_number": qidController.text.trim(), // 🔥 QID Data Sent to Backend
          "category": selectedCategory,
          "experience": expController.text.trim(),
        },
      ).timeout(const Duration(seconds: 15)); // Timeout added for safety

      final result = jsonDecode(response.body);

      if (response.statusCode == 200 && result['status'] == 'success') {
        _showDoneDialog();
      } else {
        Get.snackbar(
          "Submission Failed",
          result['message'] ?? "An error occurred",
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(16),
        );
      }
    } catch (e) {
      Get.snackbar(
        "Connection Error",
        "Please check your internet connection and try again.",
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    whatsappController.dispose();
    qidController.dispose(); // 🔥 Dispose QID controller
    expController.dispose();
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
              _buildInputLabel("Qatar ID (QID)"), // 🔥 QID UI Field
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
              _buildInputLabel("Select Category"),
              DropdownButtonFormField<String>(
                value: selectedCategory,
                style: GoogleFonts.poppins(color: Colors.black, fontSize: 14),
                decoration: _inputDecoration("Choose your skill", Icons.category_outlined),
                items: categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                onChanged: (val) => setState(() => selectedCategory = val),
                validator: (v) => v == null ? "Required" : null,
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
                height: 55, // Height slightly increased for premium look
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

  void _showDoneDialog() {
    Get.defaultDialog(
      title: "Success!",
      titleStyle: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.green),
      middleText: "Your application has been submitted. Our team will verify your QID and contact you on WhatsApp soon.",
      middleTextStyle: GoogleFonts.poppins(fontSize: 13),
      textConfirm: "Back to Home",
      confirmTextColor: Colors.white,
      buttonColor: AppColors.primary,
      radius: 16,
      onConfirm: () {
        Get.back(); // Close Dialog
        Get.back(); // Go back to Home
      },
    );
  }
}