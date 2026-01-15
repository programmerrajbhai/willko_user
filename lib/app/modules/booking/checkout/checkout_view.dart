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
    // Controller GetView এর মাধ্যমে আসছে, তাই Get.put দরকার নেই যদি বাইন্ডিং থাকে।
    // না থাকলে: final controller = Get.put(CheckoutController());
    
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        title: const Text("Checkout"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- 1. Section Title Style ---
            _buildSectionTitle("Select Date"),
            
            // --- Date Selector ---
            SizedBox(
              height: 90,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: controller.next7Days.length,
                itemBuilder: (context, index) {
                  DateTime date = controller.next7Days[index];
                  return Obx(() {
                    bool isSelected = controller.selectedDateIndex.value == index;
                    return GestureDetector(
                      onTap: () => controller.selectDate(index),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: 70,
                        margin: const EdgeInsets.only(right: 12),
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.primary : Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected ? AppColors.primary : AppColors.inputBorder,
                            width: 1.5
                          ),
                          boxShadow: isSelected 
                            ? [BoxShadow(color: AppColors.primary.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4))]
                            : [],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(DateFormat('MMM').format(date), 
                              style: TextStyle(fontSize: 12, color: isSelected ? Colors.white70 : AppColors.textGrey)
                            ),
                            Text(date.day.toString(), 
                              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: isSelected ? Colors.white : AppColors.textBlack)
                            ),
                            Text(DateFormat('E').format(date), 
                              style: TextStyle(fontSize: 12, color: isSelected ? Colors.white70 : AppColors.textGrey)
                            ),
                          ],
                        ),
                      ),
                    );
                  });
                },
              ),
            ),
            const SizedBox(height: 30),

            // --- 2. Time Selector ---
            _buildSectionTitle("Select Time"),
            Obx(() => Wrap(
              spacing: 12,
              runSpacing: 12,
              children: controller.timeSlots.map((time) {
                bool isSelected = controller.selectedTimeSlot.value == time;
                return GestureDetector(
                  onTap: () => controller.selectTime(time),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primary : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: isSelected ? AppColors.primary : AppColors.inputBorder),
                    ),
                    child: Text(
                      time,
                      style: TextStyle(
                        color: isSelected ? Colors.white : AppColors.textBlack,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                  ),
                );
              }).toList(),
            )),

            const SizedBox(height: 30),

            // --- 3. Payment Method (Custom Cards) ---
            _buildSectionTitle("Payment Method"),
            Obx(() => Column(
              children: controller.paymentMethods.map((method) {
                bool isSelected = controller.selectedPayment.value == method['name'];
                return GestureDetector(
                  onTap: () => controller.selectPaymentMethod(method['name']),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected ? AppColors.primary : Colors.transparent, 
                        width: 2
                      ),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4)),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.scaffoldBackground,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(method['icon'], color: isSelected ? AppColors.primary : AppColors.textGrey),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Text(method['name'], style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                        ),
                        if (isSelected)
                          const Icon(Icons.check_circle_rounded, color: AppColors.primary),
                      ],
                    ),
                  ),
                );
              }).toList(),
            )),

            const SizedBox(height: 50),
          ],
        ),
      ),

      // --- Bottom Confirm Button ---
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, -5))],
        ),
        child: SizedBox(
          width: double.infinity,
          height: 55, // Taller button
          child: Obx(() => ElevatedButton(
            onPressed: controller.isLoading.value ? null : controller.placeOrder,
            child: controller.isLoading.value
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text("CONFIRM BOOKING"),
          )),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Text(title, style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textBlack)),
    );
  }
}