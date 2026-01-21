import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../home_controller.dart';

class WhySectionUC extends StatelessWidget {
  final HomeController controller;
  const WhySectionUC({required this.controller, super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, c) {
        final isWide = c.maxWidth >= 900;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Why Willko Service?", style: GoogleFonts.poppins(fontSize: isWide ? 40 : 28, fontWeight: FontWeight.w800, color: Colors.black)),
            const SizedBox(height: 26),
            isWide
                ? Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Expanded(child: _WhyItemsUC(controller: controller, isWide: true)), const SizedBox(width: 28), Expanded(child: const _QualityCardUC(isWide: true))])
                : Column(children: [_WhyItemsUC(controller: controller, isWide: false), const SizedBox(height: 18), const _QualityCardUC(isWide: false)]),
          ],
        );
      },
    );
  }
}

class _WhyItemsUC extends StatelessWidget {
  final HomeController controller;
  final bool isWide;
  const _WhyItemsUC({required this.controller, required this.isWide});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(controller.whyItems.length, (i) {
        final it = controller.whyItems[i];
        return Padding(
          padding: EdgeInsets.only(bottom: i == controller.whyItems.length - 1 ? 0 : 34),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: isWide ? 68 : 58, width: isWide ? 68 : 58,
                decoration: BoxDecoration(color: const Color(0xFFFFF3D6), borderRadius: BorderRadius.circular(14)),
                child: Stack(children: [Center(child: Icon(it["icon"] as IconData, size: isWide ? 34 : 30, color: const Color(0xFFB46A00))), Positioned(right: 10, bottom: 10, child: Container(height: 6, width: 6, decoration: BoxDecoration(color: const Color(0xFFFF8A00), borderRadius: BorderRadius.circular(99))))]),
              ),
              const SizedBox(width: 22),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(it["title"] as String, style: GoogleFonts.poppins(fontSize: isWide ? 18 : 16, fontWeight: FontWeight.w700, color: Colors.black)),
                    const SizedBox(height: 6),
                    Text(it["subtitle"] as String, style: GoogleFonts.poppins(fontSize: isWide ? 15 : 13.5, height: 1.45, color: Colors.black54, fontWeight: FontWeight.w400)),
                  ]),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

class _QualityCardUC extends StatelessWidget {
  final bool isWide;
  const _QualityCardUC({required this.isWide});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(isWide ? 44 : 26),
      decoration: BoxDecoration(color: const Color(0xFFF2F6FF), borderRadius: BorderRadius.circular(18), border: Border.all(color: const Color(0xFFE5EDFF))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Container(height: isWide ? 92 : 72, width: isWide ? 92 : 72, decoration: BoxDecoration(color: Colors.white.withOpacity(.7), borderRadius: BorderRadius.circular(20)), child: const Center(child: Icon(Icons.shield_rounded, size: 54, color: Color(0xFF4A7DFF)))),
        SizedBox(height: isWide ? 26 : 18),
        Text("100% Quality Assured", textAlign: TextAlign.center, style: GoogleFonts.poppins(fontSize: isWide ? 34 : 24, fontWeight: FontWeight.w800, color: Colors.black)),
        const SizedBox(height: 12),
        Text("If you don’t love our service, we will make it right.", textAlign: TextAlign.center, style: GoogleFonts.poppins(fontSize: isWide ? 16 : 13.5, height: 1.45, color: Colors.black54)),
      ]),
    );
  }
}