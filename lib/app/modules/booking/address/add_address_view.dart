import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../utils/app_colors.dart';
import 'address_controller.dart';

class AddAddressView extends GetView<AddressController> {
  const AddAddressView({super.key});

  @override
  Widget build(BuildContext context) {
    // কন্ট্রোলার যদি ইনিশিয়ালাইজ না থাকে, তবে করে নেবে
    if (!Get.isRegistered<AddressController>()) {
      Get.put(AddressController());
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: _BouncyButton(
          onTap: () => Get.back(),
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: Colors.grey.shade100, shape: BoxShape.circle),
            child: const Icon(Icons.close, color: Colors.black, size: 20),
          ),
        ),
        title: Text("NEW ADDRESS", style: GoogleFonts.oswald(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20, letterSpacing: 1)),
        bottom: PreferredSize(preferredSize: const Size.fromHeight(1), child: Container(color: Colors.grey.shade200, height: 1)),
      ),
      body: Form(
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
                    
                    // --- 1. Smart Map Locator (With Animation) ---
                    _SlideInAnimation(
                      delay: 0,
                      child: Obx(() => GestureDetector(
                        onTap: controller.isMapLoading.value ? null : controller.pickLocationFromMap,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          height: 160,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5F5F5),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: controller.isMapLoading.value ? AppColors.primary : Colors.black12, width: 1.5),
                            image: const DecorationImage(
                              image: NetworkImage("https://i.imgur.com/K3X6qQy.png"), // ডামি ম্যাপ ইমেজ
                              fit: BoxFit.cover,
                              opacity: 0.15
                            ),
                          ),
                          child: controller.isMapLoading.value
                              ? const Center(child: CircularProgressIndicator(color: Colors.black, strokeWidth: 3))
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.location_on_rounded, size: 42, color: Colors.black),
                                    const SizedBox(height: 8),
                                    Text("TAP TO LOCATE ON MAP", style: GoogleFonts.manrope(color: Colors.black, fontWeight: FontWeight.w800, fontSize: 13, letterSpacing: 1)),
                                  ],
                                ),
                        ),
                      )),
                    ),
                    const SizedBox(height: 30),

                    // --- 2. Form Fields with Animation ---
                    _SlideInAnimation(delay: 100, child: _sectionTitle("CONTACT INFO")),
                    _SlideInAnimation(
                      delay: 150,
                      child: Column(
                        children: [
                          _AnimatedTextField(controller: controller.nameController, label: "Full Name", icon: Icons.person_outline, hint: "Your Name"),
                          const SizedBox(height: 16),
                          _AnimatedTextField(controller: controller.phoneController, label: "Phone", icon: Icons.phone_outlined, hint: "017xxxxxxxx", inputType: TextInputType.phone),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),

                    _SlideInAnimation(delay: 200, child: _sectionTitle("ADDRESS DETAILS")),
                    _SlideInAnimation(
                      delay: 250,
                      child: Column(
                        children: [
                          _AnimatedTextField(controller: controller.addressController, label: "Address Line", icon: Icons.home_outlined, hint: "House, Road, Area", maxLines: 2),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(child: _AnimatedTextField(controller: controller.cityController, label: "City", icon: Icons.location_city_outlined, hint: "Dhaka")),
                              const SizedBox(width: 16),
                              Expanded(child: _AnimatedTextField(controller: controller.zipController, label: "Zip Code", icon: Icons.numbers, hint: "1200", inputType: TextInputType.number)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),

                    // --- 3. Save As Chips ---
                    _SlideInAnimation(delay: 300, child: _sectionTitle("SAVE AS")),
                    _SlideInAnimation(
                      delay: 350,
                      child: Obx(() => Row(
                        children: [
                          _TypeChip("Home", Icons.home_filled, controller),
                          const SizedBox(width: 12),
                          _TypeChip("Office", Icons.work, controller),
                          const SizedBox(width: 12),
                          _TypeChip("Other", Icons.location_on, controller),
                        ],
                      )),
                    ),
                    const SizedBox(height: 50),
                  ],
                ),
              ),
            ),

            // --- 4. Floating Save Button ---
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, -5))],
              ),
              child: SafeArea(
                child: SizedBox(
                  height: 56,
                  child: Obx(() => _BouncyButton(
                    onTap: controller.isSaving.value ? null : controller.saveAddress,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(16), 
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 12, offset: const Offset(0, 6))],
                      ),
                      alignment: Alignment.center,
                      child: controller.isSaving.value
                          ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                          : Text("SAVE & CONTINUE", style: GoogleFonts.manrope(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: 1)),
                    ),
                  )),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(title, style: GoogleFonts.oswald(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey.shade600, letterSpacing: 1.2)),
    );
  }
}

// --- Premium Widgets & Animations ---

class _AnimatedTextField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final TextInputType inputType;
  final int maxLines;

  const _AnimatedTextField({required this.controller, required this.label, required this.hint, required this.icon, this.inputType = TextInputType.text, this.maxLines = 1});

  @override
  State<_AnimatedTextField> createState() => _AnimatedTextFieldState();
}

class _AnimatedTextFieldState extends State<_AnimatedTextField> {
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: (hasFocus) => setState(() => _isFocused = hasFocus),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        decoration: BoxDecoration(
          color: _isFocused ? Colors.white : const Color(0xFFFAFAFA),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: _isFocused ? Colors.black : Colors.black12, width: _isFocused ? 1.5 : 1),
          boxShadow: _isFocused ? [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 4))] : [],
        ),
        child: TextFormField(
          controller: widget.controller,
          keyboardType: widget.inputType,
          maxLines: widget.maxLines,
          style: GoogleFonts.manrope(fontWeight: FontWeight.w600, color: Colors.black87),
          decoration: InputDecoration(
            labelText: widget.label,
            hintText: widget.hint,
            hintStyle: GoogleFonts.manrope(color: Colors.black26),
            prefixIcon: Icon(widget.icon, color: _isFocused ? Colors.black : Colors.black45, size: 22),
            border: InputBorder.none,
            labelStyle: GoogleFonts.manrope(color: _isFocused ? Colors.black : Colors.grey),
          ),
        ),
      ),
    );
  }
}

class _TypeChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final AddressController controller;

  const _TypeChip(this.label, this.icon, this.controller);

  @override
  Widget build(BuildContext context) {
    bool isSelected = controller.selectedType.value == label;
    return GestureDetector(
      onTap: () => controller.changeType(label),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.black : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isSelected ? Colors.black : Colors.grey.shade300),
          boxShadow: isSelected ? [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 8, offset: const Offset(0, 4))] : [],
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: isSelected ? Colors.white : Colors.grey),
            const SizedBox(width: 8),
            Text(label.toUpperCase(), style: GoogleFonts.manrope(fontSize: 12, fontWeight: FontWeight.bold, color: isSelected ? Colors.white : Colors.black87, letterSpacing: 0.5)),
          ],
        ),
      ),
    );
  }
}

class _BouncyButton extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  const _BouncyButton({required this.child, this.onTap});
  @override
  State<_BouncyButton> createState() => _BouncyButtonState();
}

class _BouncyButtonState extends State<_BouncyButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;
  @override
  void initState() {
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 100));
    _scale = Tween<double>(begin: 1.0, end: 0.95).animate(_controller);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) { _controller.reverse(); widget.onTap?.call(); },
      onTapCancel: () => _controller.reverse(),
      child: ScaleTransition(scale: _scale, child: widget.child),
    );
  }
}

class _SlideInAnimation extends StatefulWidget {
  final Widget child;
  final int delay;
  const _SlideInAnimation({required this.child, required this.delay});
  @override
  State<_SlideInAnimation> createState() => _SlideInAnimationState();
}

class _SlideInAnimationState extends State<_SlideInAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offset;
  late Animation<double> _opacity;
  @override
  void initState() {
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _offset = Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _opacity = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    Future.delayed(Duration(milliseconds: widget.delay), () { if(mounted) _controller.forward(); });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return FadeTransition(opacity: _opacity, child: SlideTransition(position: _offset, child: widget.child));
  }
  @override
  void dispose() { _controller.dispose(); super.dispose(); }
}