import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../utils/app_colors.dart';
import 'address_controller.dart';

class AddressView extends StatelessWidget {
  const AddressView({super.key});

  @override
  Widget build(BuildContext context) {
    // কন্ট্রোলার নিশ্চিত করা
    final controller = Get.put(AddressController());

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black87, size: 20),
          onPressed: () => Get.back(),
        ),
        title: Text(
          "Select Address",
          style: GoogleFonts.manrope(color: Colors.black87, fontWeight: FontWeight.w800, fontSize: 17),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Obx(() {
            // লোডিং স্টেট
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator(color: AppColors.primary));
            }

            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        // --- Add New Button ---
                        InkWell(
                          onTap: controller.goToAddAddress,
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: AppColors.primary.withOpacity(0.5)),
                              boxShadow: [BoxShadow(color: AppColors.primary.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.add_location_alt_rounded, color: AppColors.primary),
                                const SizedBox(width: 8),
                                Text("Add New Address", style: GoogleFonts.manrope(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.primary)),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 25),

                        // --- Address List ---
                        if (controller.addressList.isEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 40),
                            child: Column(
                              children: [
                                Icon(Icons.location_off_rounded, size: 60, color: Colors.grey.shade300),
                                const SizedBox(height: 10),
                                Text("No address saved yet.", style: GoogleFonts.manrope(color: Colors.grey, fontSize: 14)),
                              ],
                            ),
                          )
                        else
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: controller.addressList.length,
                            itemBuilder: (context, index) {
                              var item = controller.addressList[index];
                              return GestureDetector(
                                onTap: () => controller.selectAddress(index),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  margin: const EdgeInsets.only(bottom: 15),
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: item.isSelected ? AppColors.primary : Colors.transparent,
                                      width: item.isSelected ? 2 : 0,
                                    ),
                                    boxShadow: [
                                      BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))
                                    ],
                                  ),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // Icon Box
                                      Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: item.isSelected ? AppColors.primary.withOpacity(0.1) : Colors.grey.shade50,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          item.type == "Home" ? Icons.home_rounded : item.type == "Office" ? Icons.business_rounded : Icons.location_on_rounded,
                                          color: item.isSelected ? AppColors.primary : Colors.grey,
                                          size: 22,
                                        ),
                                      ),
                                      const SizedBox(width: 15),
                                      
                                      // Address Info
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    "${item.type} • ${item.fullName}", 
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: GoogleFonts.manrope(fontWeight: FontWeight.w800, fontSize: 16, color: Colors.black87),
                                                  ),
                                                ),
                                                if (item.isSelected)
                                                  Container(
                                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                                    decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(20)),
                                                    child: const Text("DEFAULT", style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                                                  )
                                                else
                                                  InkWell(
                                                    onTap: () => controller.deleteAddress(index),
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(4.0),
                                                      child: Icon(Icons.delete_outline_rounded, color: Colors.redAccent.withOpacity(0.7), size: 20),
                                                    ),
                                                  )
                                              ],
                                            ),
                                            const SizedBox(height: 6),
                                            Text(
                                              item.addressLine, 
                                              style: GoogleFonts.manrope(color: Colors.grey.shade600, fontSize: 13, height: 1.4),
                                            ),
                                            const SizedBox(height: 6),
                                            Row(
                                              children: [
                                                Icon(Icons.phone_android_rounded, size: 14, color: Colors.grey.shade500),
                                                const SizedBox(width: 4),
                                                Text(item.phone, style: GoogleFonts.manrope(color: Colors.black87, fontSize: 12, fontWeight: FontWeight.w600)),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        const SizedBox(height: 80),
                      ],
                    ),
                  ),
                ),

                // --- Bottom Bar ---
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 15, offset: const Offset(0, -4))],
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: controller.addressList.isNotEmpty ? controller.goToCheckout : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        disabledBackgroundColor: Colors.grey.shade300,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      child: Text("Confirm Selection", style: GoogleFonts.manrope(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.white)),
                    ),
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}