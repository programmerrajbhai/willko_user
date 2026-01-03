import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../utils/app_colors.dart';
import 'address_controller.dart';

class AddressView extends StatelessWidget {
  const AddressView({super.key});

  @override
  Widget build(BuildContext context) {
    // কন্ট্রোলার ইনজেক্ট
    final controller = Get.put(AddressController());

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9), // খুব হালকা ব্যাকগ্রাউন্ড
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Get.back(),
        ),
        title: Text(
          "Select Address",
          style: GoogleFonts.poppins(color: Colors.black87, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        // ১. লোডিং স্টেট
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator(color: AppColors.primary));
        }

        return Column(
          children: [
            // --- Scrollable Area (List + Add Button) ---
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // ২. এম্পটি স্টেট চেক (যদি কোনো এড্রেস না থাকে)
                    if (controller.addressList.isEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 40),
                        child: Column(
                          children: [
                            Icon(Icons.location_off_rounded, size: 60, color: Colors.grey.shade300),
                            const SizedBox(height: 10),
                            Text(
                              "No address saved yet.",
                              style: GoogleFonts.poppins(color: Colors.grey, fontSize: 14),
                            ),
                          ],
                        ),
                      ),

                    // ৩. এড্রেস লিস্ট
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
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: item.isSelected ? AppColors.primary : Colors.grey.shade200,
                                width: item.isSelected ? 2 : 1,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: item.isSelected
                                      ? AppColors.primary.withOpacity(0.05)
                                      : Colors.grey.withOpacity(0.02),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                )
                              ],
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // আইকন (Home/Office)
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: item.isSelected
                                        ? AppColors.primary.withOpacity(0.1)
                                        : Colors.grey.shade50,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    item.type == "Home" ? Icons.home_rounded :
                                    item.type == "Office" ? Icons.business_rounded : Icons.location_on_rounded,
                                    color: item.isSelected ? AppColors.primary : Colors.grey,
                                    size: 22,
                                  ),
                                ),
                                const SizedBox(width: 15),

                                // বিস্তারিত তথ্য
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            item.type,
                                            style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              color: item.isSelected ? Colors.black87 : Colors.black54,
                                            ),
                                          ),
                                          // ডিলিট বাটন (শুধুমাত্র যদি সিলেক্ট করা না থাকে)
                                          if (!item.isSelected)
                                            InkWell(
                                              onTap: () => controller.deleteAddress(index),
                                              borderRadius: BorderRadius.circular(20),
                                              child: const Padding(
                                                padding: EdgeInsets.all(4.0),
                                                child: Icon(Icons.delete_outline_rounded, color: Colors.redAccent, size: 20),
                                              ),
                                            ),
                                        ],
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        item.address,
                                        style: GoogleFonts.poppins(color: Colors.grey.shade700, fontSize: 13, height: 1.4),
                                      ),
                                      const SizedBox(height: 6),
                                      Row(
                                        children: [
                                          const Icon(Icons.phone_rounded, size: 12, color: Colors.grey),
                                          const SizedBox(width: 5),
                                          Text(
                                            item.phone,
                                            style: GoogleFonts.poppins(color: Colors.grey.shade600, fontSize: 12),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),

                                // সিলেকশন টিক চিহ্ন
                                if (item.isSelected)
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10, top: 10),
                                    child: const Icon(Icons.check_circle_rounded, color: AppColors.primary, size: 24),
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 10),

                    // ৪. Add New Address Button (Dotted Border Style)
                    InkWell(
                      onTap: controller.goToAddAddress,
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.primary, style: BorderStyle.solid), // অথবা ড্যাশড বর্ডার প্যাকেজ ইউজ করতে পারো
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.add_rounded, color: AppColors.primary),
                            const SizedBox(width: 8),
                            Text(
                              "Add New Address",
                              style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primary
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 80), // বটম স্পেস যাতে ফিক্সড বাটনের নিচে কন্টেন্ট ঢাকা না পড়ে
                  ],
                ),
              ),
            ),

            // --- Fixed Bottom Bar ---
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 15,
                      offset: const Offset(0, -4)
                  )
                ],
              ),
              child: SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: controller.addressList.isNotEmpty
                      ? controller.goToCheckout
                      : null, // এড্রেস না থাকলে ডিজেবল থাকবে
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    disabledBackgroundColor: Colors.grey.shade300,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Proceed to Checkout",
                        style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 20),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}