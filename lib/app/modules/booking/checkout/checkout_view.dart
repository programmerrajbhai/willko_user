import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../../utils/app_colors.dart';
import 'checkout_controller.dart';

class CheckoutView extends GetView<CheckoutController> {
  const CheckoutView({super.key});

  @override
  Widget build(BuildContext context) {
    // কন্ট্রোলার ইনিশিয়ালাইজেশন (যদি আগে না থাকে)
    Get.put(CheckoutController());

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        title: Text("Checkout", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20, color: Colors.black),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            // ✅ 1. Urban Company Style Address Section
            _buildSectionHeader("Service Location"),
            Obx(() {
              final addr = controller.selectedAddress.value;
              
              if (addr == null) {
                // --- Empty State (Add Address Button) ---
                return InkWell(
                  onTap: controller.pickAddress,
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.primary, style: BorderStyle.solid),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.add_location_alt_rounded, color: AppColors.primary),
                        const SizedBox(width: 10),
                        Text("Add Service Address", 
                          style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.primary)
                        ),
                      ],
                    ),
                  ),
                );
              }

              // --- Address Card (Selected) ---
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4))],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Icon
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.scaffoldBackground,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        addr.type == "Home" ? Icons.home_rounded : 
                        addr.type == "Office" ? Icons.business_rounded : Icons.location_on_rounded,
                        color: Colors.black87, size: 24
                      ),
                    ),
                    const SizedBox(width: 14),
                    
                    // Text Details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(addr.type, style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16)),
                              
                              // Change Button
                              InkWell(
                                onTap: controller.pickAddress,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary.withOpacity(0.08),
                                    borderRadius: BorderRadius.circular(6)
                                  ),
                                  child: Text("CHANGE", style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primary)),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(addr.address, 
                            maxLines: 2, 
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.poppins(color: Colors.grey.shade600, fontSize: 13, height: 1.4)
                          ),
                          const SizedBox(height: 6),
                          Text(addr.phone, style: GoogleFonts.poppins(color: Colors.black87, fontSize: 13, fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
            
            const SizedBox(height: 25),

            // ✅ 2. Slot Selection
            _buildSectionHeader("Preferred Slot"),
            _buildDateSelector(),
            const SizedBox(height: 20),
            _buildTimeSelector(),
            
            const SizedBox(height: 25),

            // ✅ 3. Payment Method
            _buildSectionHeader("Payment Method"),
            _buildPaymentMethods(),

            const SizedBox(height: 100), // Bottom padding
          ],
        ),
      ),

      // ✅ 4. Bottom Action Bar
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, -5))],
        ),
        child: SizedBox(
          height: 55,
          child: Obx(() => ElevatedButton(
            onPressed: controller.isLoading.value ? null : controller.placeOrder,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 2,
            ),
            child: controller.isLoading.value 
              ? const CircularProgressIndicator(color: Colors.white)
              : Text("Place Order", style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
          )),
        ),
      ),
    );
  }

  // --- Helper Widgets ---

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(title, style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textBlack)),
    );
  }

  Widget _buildDateSelector() {
    return SizedBox(
      height: 85,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: controller.next7Days.length,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          DateTime date = controller.next7Days[index];
          return Obx(() {
            bool isSelected = controller.selectedDateIndex.value == index;
            return GestureDetector(
              onTap: () => controller.selectDate(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 65,
                margin: const EdgeInsets.only(right: 12),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: isSelected ? AppColors.primary : Colors.grey.shade200),
                  boxShadow: isSelected ? [BoxShadow(color: AppColors.primary.withOpacity(0.3), blurRadius: 6, offset: const Offset(0, 3))] : [],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(DateFormat('MMM').format(date), style: TextStyle(fontSize: 12, color: isSelected ? Colors.white70 : Colors.grey)),
                    Text(date.day.toString(), style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: isSelected ? Colors.white : Colors.black87)),
                    Text(DateFormat('E').format(date), style: TextStyle(fontSize: 12, color: isSelected ? Colors.white70 : Colors.grey)),
                  ],
                ),
              ),
            );
          });
        },
      ),
    );
  }

  Widget _buildTimeSelector() {
    return Obx(() => Wrap(
      spacing: 10,
      runSpacing: 10,
      children: controller.timeSlots.map((time) {
        bool isSelected = controller.selectedTimeSlot.value == time;
        return InkWell(
          onTap: () => controller.selectTime(time),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary : Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: isSelected ? AppColors.primary : Colors.grey.shade200),
            ),
            child: Text(time, style: TextStyle(color: isSelected ? Colors.white : Colors.black87, fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal)),
          ),
        );
      }).toList(),
    ));
  }

  Widget _buildPaymentMethods() {
    return Obx(() => Column(
      children: controller.paymentMethods.map((method) {
        bool isSelected = controller.selectedPayment.value == method['name'];
        return GestureDetector(
          onTap: () => controller.selectPaymentMethod(method['name']),
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: isSelected ? AppColors.primary : Colors.transparent, width: 1.5),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8, offset: const Offset(0, 2))],
            ),
            child: Row(
              children: [
                Icon(method['icon'], color: isSelected ? AppColors.primary : Colors.grey),
                const SizedBox(width: 15),
                Expanded(child: Text(method['name'], style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14))),
                if (isSelected) const Icon(Icons.check_circle, color: AppColors.primary, size: 20),
              ],
            ),
          ),
        );
      }).toList(),
    ));
  }
}