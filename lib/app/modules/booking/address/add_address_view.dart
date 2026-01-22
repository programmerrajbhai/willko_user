import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../utils/app_colors.dart';
import 'address_controller.dart';

class AddAddressView extends GetView<AddressController> {
  const AddAddressView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(color: Colors.grey.shade100, shape: BoxShape.circle),
            child: const Icon(Icons.close, color: Colors.black, size: 18),
          ),
        ),
        title: Text(
          "ADD SERVICE DETAILS",
          style: GoogleFonts.manrope(color: Colors.black, fontWeight: FontWeight.w800, fontSize: 16),
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Form(
            key: controller.formKey,
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // --- GPS Button ---
                        GestureDetector(
                          onTap: () => controller.useCurrentLocation(),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppColors.primary.withOpacity(0.2)),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Obx(() => controller.isMapLoading.value
                                    ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                                    : Icon(Icons.my_location_rounded, color: AppColors.primary, size: 20)),
                                const SizedBox(width: 10),
                                Text("Auto-fill from Current Location", style: GoogleFonts.manrope(fontWeight: FontWeight.w700, color: AppColors.primary)),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 25),
                        _sectionTitle("CONTACT INFO"),
                        
                        // --- Contact Details ---
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: _cardDecoration(),
                          child: Column(
                            children: [
                              _AnimatedTextField(
                                controller: controller.nameController,
                                label: "Customer Name",
                                icon: Icons.person_outline_rounded,
                                hint: "e.g. Raj Ahmad",
                                validator: (v) => (v == null || v.isEmpty) ? "Name is required" : null,
                              ),
                              const SizedBox(height: 16),
                              _AnimatedTextField(
                                controller: controller.phoneController,
                                label: "Contact Number",
                                icon: Icons.phone_android_rounded,
                                hint: "01xxxxxxxxx",
                                inputType: TextInputType.phone,
                                validator: (v) => (v == null || v.length < 11) ? "Valid number required" : null,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 25),
                        _sectionTitle("ADDRESS DETAILS"),

                        // --- Address Details ---
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: _cardDecoration(),
                          child: Column(
                            children: [
                              _AnimatedTextField(
                                controller: controller.locationNameController,
                                label: "Location Name / Area",
                                icon: Icons.map_outlined,
                                hint: "e.g. Road 10, Banani",
                                maxLines: 2,
                                validator: (v) => (v == null || v.isEmpty) ? "Location is required" : null,
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(
                                    child: _AnimatedTextField(
                                      controller: controller.buildingController,
                                      label: "Building No.",
                                      icon: Icons.apartment_rounded,
                                      hint: "e.g. 56",
                                      validator: (v) => (v == null || v.isEmpty) ? "Required" : null,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: _AnimatedTextField(
                                      controller: controller.flatController,
                                      label: "Flat No.",
                                      icon: Icons.door_front_door_outlined,
                                      hint: "e.g. 4-B",
                                      validator: (v) => (v == null || v.isEmpty) ? "Required" : null,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        
                        const SizedBox(height: 25),
                        _sectionTitle("SAVE AS"),
                        
                        // --- Type Selector ---
                        Row(
                          children: [
                            _typeButton("Home", Icons.home_rounded),
                            const SizedBox(width: 12),
                            _typeButton("Office", Icons.work_rounded),
                            const SizedBox(width: 12),
                            _typeButton("Other", Icons.location_on_rounded),
                          ],
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),

                // --- Save Button ---
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(color: Colors.white, border: Border(top: BorderSide(color: Color(0xFFEEEEEE)))),
                  child: SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: Obx(() => ElevatedButton(
                      onPressed: controller.isSaving.value ? null : controller.saveAddress,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        elevation: 0,
                      ),
                      child: controller.isSaving.value 
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text("CONFIRM & SAVE", style: GoogleFonts.manrope(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                    )),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _typeButton(String type, IconData icon) {
    return Expanded(
      child: Obx(() {
        bool isSelected = controller.selectedType.value == type;
        return GestureDetector(
          onTap: () => controller.changeType(type),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: isSelected ? Colors.black : Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: isSelected ? Colors.black : Colors.grey.shade300),
            ),
            child: Column(
              children: [
                Icon(icon, color: isSelected ? Colors.white : Colors.grey, size: 20),
                const SizedBox(height: 4),
                Text(type, style: GoogleFonts.manrope(fontSize: 12, fontWeight: FontWeight.w600, color: isSelected ? Colors.white : Colors.grey)),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 10),
      child: Text(title, style: GoogleFonts.manrope(fontSize: 12, fontWeight: FontWeight.w800, color: Colors.grey.shade500, letterSpacing: 1.2)),
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))],
    );
  }
}

class _AnimatedTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final TextInputType inputType;
  final int maxLines;
  final String? Function(String?)? validator;

  const _AnimatedTextField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    this.inputType = TextInputType.text,
    this.maxLines = 1,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: inputType,
        maxLines: maxLines,
        validator: validator,
        style: GoogleFonts.manrope(fontWeight: FontWeight.w600, color: Colors.black87),
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          hintStyle: GoogleFonts.manrope(color: Colors.grey.shade400, fontSize: 13),
          prefixIcon: Icon(icon, color: Colors.grey.shade500, size: 20),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          labelStyle: GoogleFonts.manrope(color: Colors.grey.shade600, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}