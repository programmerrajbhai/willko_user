import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../../utils/app_colors.dart';
import '../../../data/services/api_service.dart'; // আপনার বেস ইউআরএল এর জন্য

class ProviderRegistrationView extends StatefulWidget {
  const ProviderRegistrationView({super.key});

  @override
  State<ProviderRegistrationView> createState() => _ProviderRegistrationViewState();
}

class _ProviderRegistrationViewState extends State<ProviderRegistrationView> {
  final _formKey = GlobalKey<FormState>();

  // ✅ TextEditingControllers যোগ করা হয়েছে
  final TextEditingController nameController = TextEditingController();
  final TextEditingController whatsappController = TextEditingController();
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
        Uri.parse("${ApiService.baseUrl}/user/auth/register_provider.php"),
        body: {
          "full_name": nameController.text.trim(),
          "whatsapp_number": whatsappController.text.trim(),
          "category": selectedCategory,
          "experience": expController.text.trim(),
        },
      );

      final result = jsonDecode(response.body);

      if (response.statusCode == 200 && result['status'] == 'success') {
        _showDoneDialog();
      } else {
        Get.snackbar(
          "Error",
          result['message'] ?? "Failed to submit application",
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Connection Error",
        "Please check your internet connection.",
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
    // মেমোরি লিক রোধ করতে কন্ট্রোলারগুলো ডিসপোজ করুন
    nameController.dispose();
    whatsappController.dispose();
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
                "Apply to Join",
                style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              _buildInputLabel("Full Name"),
              _buildTextField(
                  controller: nameController,
                  hint: "Your name as per NID",
                  icon: Icons.person_outline
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

              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submitApplication,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  child: _isSubmitting
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text("Submit Application",
                      style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white)),
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
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(label, style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w500)),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      style: GoogleFonts.poppins(fontSize: 14),
      decoration: _inputDecoration(hint, icon),
      validator: (v) => v!.trim().isEmpty ? "Required" : null,
    );
  }

  InputDecoration _inputDecoration(String? hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon, size: 20, color: Colors.grey),
      hintStyle: const TextStyle(fontSize: 13, color: Colors.grey),
      filled: true,
      fillColor: Colors.grey[50],
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade200)
      ),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade200)
      ),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5)
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 14),
    );
  }

  void _showDoneDialog() {
    Get.defaultDialog(
      title: "Success",
      middleText: "Application submitted. We will review and contact you on WhatsApp soon.",
      textConfirm: "OK",
      confirmTextColor: Colors.white,
      buttonColor: AppColors.primary,
      onConfirm: () {
        Get.back(); // পপআপ বন্ধ
        Get.back(); // রেজিস্ট্রেশন পেজ থেকে ব্যাকে যাওয়া
      },
    );
  }
}