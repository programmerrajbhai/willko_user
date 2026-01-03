import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart'; // DateFormat এর জন্য
import '../../../../utils/app_colors.dart';
import 'checkout_controller.dart';

class CheckoutView extends StatelessWidget {
  const CheckoutView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CheckoutController());

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: Text(
          "Checkout",
          style: GoogleFonts.poppins(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- 1. Date Selection (Horizontal) ---
            Text("Select Date", style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),

            SizedBox(
              height: 80,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: controller.next7Days.length,
                itemBuilder: (context, index) {
                  DateTime date = controller.next7Days[index];
                  bool isSelected = controller.selectedDateIndex.value == index;

                  return Obx(() { // Obx এখানে র‍্যাপ করা হলো রিঅ্যাক্টিভিটির জন্য
                    bool selected = controller.selectedDateIndex.value == index;
                    return GestureDetector(
                      onTap: () => controller.selectDate(index),
                      child: Container(
                        width: 65,
                        margin: const EdgeInsets.only(right: 12),
                        decoration: BoxDecoration(
                          color: selected ? AppColors.primary : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: selected ? AppColors.primary : Colors.grey.shade300),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              DateFormat('MMM').format(date), // Month (Ex: Jan)
                              style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: selected ? Colors.white70 : Colors.grey
                              ),
                            ),
                            Text(
                              date.day.toString(), // Day (Ex: 01)
                              style: GoogleFonts.poppins(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: selected ? Colors.white : Colors.black87
                              ),
                            ),
                            Text(
                              DateFormat('E').format(date), // Weekday (Ex: Mon)
                              style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: selected ? Colors.white70 : Colors.grey
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  });
                },
              ),
            ),
            const SizedBox(height: 25),

            // --- 2. Time Selection (Grid/Chips) ---
            Text("Select Time", style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),

            Obx(() => Wrap(
              spacing: 12,
              runSpacing: 12,
              children: controller.timeSlots.map((time) {
                bool isSelected = controller.selectedTimeSlot.value == time;
                return ChoiceChip(
                  label: Text(time),
                  labelStyle: GoogleFonts.poppins(
                    color: isSelected ? Colors.white : Colors.black87,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                  selected: isSelected,
                  selectedColor: AppColors.primary,
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  onSelected: (bool selected) {
                    controller.selectTime(time);
                  },
                );
              }).toList(),
            )),

            const SizedBox(height: 30),

            // --- 3. Payment Method ---
            Text("Payment Method", style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),

            Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Obx(() => Column(
                children: controller.paymentMethods.map((method) {
                  bool isSelected = controller.selectedPayment.value == method['name'];
                  return RadioListTile(
                    value: method['name'],
                    groupValue: controller.selectedPayment.value,
                    onChanged: (val) => controller.selectPaymentMethod(val.toString()),
                    activeColor: AppColors.primary,
                    title: Text(
                      method['name'],
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 14),
                    ),
                    secondary: Icon(method['icon'], color: isSelected ? AppColors.primary : Colors.grey),
                  );
                }).toList(),
              )),
            ),

            const SizedBox(height: 100), // Bottom space
          ],
        ),
      ),

      // --- Bottom Bar ---
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -4))],
        ),
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: Obx(() => ElevatedButton(
            onPressed: controller.isLoading.value ? null : controller.placeOrder,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: controller.isLoading.value
                ? const CircularProgressIndicator(color: Colors.white)
                : Text(
              "CONFIRM BOOKING",
              style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          )),
        ),
      ),
    );
  }
}