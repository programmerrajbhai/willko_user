import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../auth/login/login_view.dart';
import '../../auth/signup/signup_view.dart';

class UrbanHeroSection extends StatelessWidget {
  final String selectedCityText;
  final VoidCallback onPickCity;

  const UrbanHeroSection({
    super.key,
    required this.selectedCityText,
    required this.onPickCity,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final bool isMobile = size.width < 700;
    final double heroHeight = isMobile ? 520 : (size.height * 0.90).clamp(620.0, 900.0);
    final double sidePad = (size.width >= 1100) ? 60 : 22;

    return SizedBox(
      height: heroHeight,
      width: double.infinity,
      child: Container(
        color: Colors.black,
        child: Stack(
          children: [
            Positioned.fill(
              child: Align(
                alignment: Alignment.centerLeft,
                child: SizedBox(
                  width: isMobile ? double.infinity : size.width * 0.55,
                  child: Image.asset(
                    "assets/images/service_man.jpg",
                    fit: BoxFit.cover,
                    alignment: Alignment.centerLeft,
                    errorBuilder: (c,o,s) => Container(color: Colors.grey[900]),
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color.fromARGB(0, 0, 0, 0), Color.fromARGB(255, 0, 0, 0)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: sidePad, vertical: 26),
              child: Column(
                children: [
                  Row(
                    children: [
                      const _UcLogo(),
                      const Spacer(),
                      _HoverNavText(text: "Register As A Professional", underlineByDefault: true, onTap: () => Get.to(() => const SignUpView())),
                      const SizedBox(width: 26),
                      _HoverNavText(text: "Login / Sign Up", onTap: () => Get.to(() => const LoginView())),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 520),
                        child: _HeroRightContent(
                          selectedCityText: selectedCityText,
                          onPickCity: onPickCity,
                          isMobile: isMobile,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeroRightContent extends StatelessWidget {
  final String selectedCityText;
  final VoidCallback onPickCity;
  final bool isMobile;

  const _HeroRightContent({required this.selectedCityText, required this.onPickCity, required this.isMobile});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: isMobile ? 6 : 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("Willko Service", style: GoogleFonts.poppins(fontSize: 12, letterSpacing: 4, color: Colors.white.withOpacity(.65), fontWeight: FontWeight.w600)),
          const SizedBox(height: 14),
          Text("Quality home services, on\ndemand", style: GoogleFonts.poppins(fontSize: isMobile ? 30 : 38, height: 1.08, fontWeight: FontWeight.w800, color: Colors.white)),
          const SizedBox(height: 14),
          Text("Experienced, hand-picked Professionals to serve you at your\ndoorstep", style: GoogleFonts.poppins(fontSize: isMobile ? 13.5 : 15, height: 1.45, color: Colors.white.withOpacity(.75), fontWeight: FontWeight.w400)),
          const SizedBox(height: 22),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), boxShadow: [BoxShadow(color: Colors.black.withOpacity(.35), blurRadius: 22, offset: const Offset(0, 12))]),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Where do you need a service?", style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.black)),
                const SizedBox(height: 12),
                InkWell(
                  onTap: onPickCity,
                  borderRadius: BorderRadius.circular(6),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                    decoration: BoxDecoration(border: Border.all(color: Colors.black12), borderRadius: BorderRadius.circular(6)),
                    child: Row(
                      children: [
                        Expanded(child: Text(selectedCityText, style: GoogleFonts.poppins(fontSize: 13.5, fontWeight: FontWeight.w500, color: selectedCityText == "Select your city" ? Colors.black54 : Colors.black87))),
                        const Icon(Icons.keyboard_arrow_down_rounded),
                      ],
                    ),
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

class _UcLogo extends StatelessWidget {
  const _UcLogo();
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(height: 42, width: 42, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(6)), child: const Center(child: Text("WC", style: TextStyle(fontWeight: FontWeight.w900)))),
        const SizedBox(width: 10),
        Text("Willko\nService", style: GoogleFonts.poppins(fontSize: 16, height: 1.0, fontWeight: FontWeight.w700, color: Colors.white)),
      ],
    );
  }
}

class _HoverNavText extends StatefulWidget {
  final String text;
  final VoidCallback onTap;
  final bool underlineByDefault;
  const _HoverNavText({required this.text, required this.onTap, this.underlineByDefault = false});
  @override
  State<_HoverNavText> createState() => _HoverNavTextState();
}

class _HoverNavTextState extends State<_HoverNavText> {
  bool hovering = false;
  @override
  Widget build(BuildContext context) {
    final bool showUnderline = widget.underlineByDefault || hovering;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => hovering = true),
      onExit: (_) => setState(() => hovering = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 140),
          style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600, color: hovering ? Colors.white : Colors.white.withOpacity(.92), decoration: showUnderline ? TextDecoration.underline : TextDecoration.none, decorationColor: Colors.white.withOpacity(.92)),
          child: Text(widget.text),
        ),
      ),
    );
  }
}