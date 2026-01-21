import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ServiceNavbar extends StatelessWidget {
  const ServiceNavbar({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 700;
    return Container(
      height: 60,
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 32),
      color: Colors.white,
      child: Row(
        children: [
          if (isMobile) 
            IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Get.back()),
          Text("Willko Service", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16)),
          const Spacer(),
          const Icon(Icons.search),
        ],
      ),
    );
  }
}