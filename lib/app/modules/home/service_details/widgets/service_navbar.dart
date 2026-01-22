import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:willko_user/utils/app_colors.dart'; // আপনার অ্যাপ কালার
import '../service_details_controller.dart'; // কন্ট্রোলার ইমপোর্ট

class ServiceNavbar extends StatelessWidget {
  const ServiceNavbar({super.key});

  @override

  Widget build(BuildContext context) {
    // ✅ কন্ট্রোলার খুঁজে বের করা (যাতে কার্ট ডাটা পাওয়া যায়)
    final ServiceDetailsController c = Get.find<ServiceDetailsController>();
    
    final isMobile = MediaQuery.of(context).size.width < 700;

    return Container(
      height: 60,
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 32),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05), 
            blurRadius: 10, 
            offset: const Offset(0, 2)
          )
        ],
      ),
      child: Row(
        children: [
          // Back Button
          if (isMobile) 
            IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20, color: Colors.black), 
              onPressed: () => Get.back()
            ),
          
          Text(
            "Willko Service", 
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold, 
              fontSize: 18, 
              color: AppColors.textBlack
            )
          ),
          
          const Spacer(),
          
          // Search Icon
          IconButton(
            icon: const Icon(Icons.search, size: 24, color: Colors.black54),
            onPressed: () {},
          ),

          const SizedBox(width: 8),

          // ✅ Cart Icon with Badge (Dynamic)
          Obx(() {
            // কার্টে কয়টা আইটেম আছে তার হিসাব
            final count = c.cartItems.length;

            return Stack(
              clipBehavior: Clip.none,
              children: [
                IconButton(
                  onPressed: () => c.openCartSheet(context), // ✅ ক্লিক করলে শিট ওপেন হবে
                  icon: const Icon(Icons.shopping_cart_outlined, size: 26, color: AppColors.primary),
                ),
                
                // যদি কার্টে আইটেম থাকে তবেই ব্যাজ দেখাবে
                if (count > 0)
                  Positioned(
                    right: 6,
                    top: 6,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.redAccent, // ব্যাজ কালার
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        '$count',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            );
          }),
        ],
      ),
    );
  }
}