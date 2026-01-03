import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../utils/app_colors.dart';
import '../../review/rate_review_view.dart';
import 'order_details_controller.dart';

class OrderDetailsView extends StatelessWidget {
  const OrderDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    // কন্ট্রোলার ইনিশিয়ালাইজ
    final controller = Get.put(OrderDetailsController());

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC), // প্রিমিয়াম ব্যাকগ্রাউন্ড কালার
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20, color: Colors.black87),
          onPressed: () => Get.back(),
        ),
        title: Text(
          "Booking Details",
          style: GoogleFonts.poppins(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        // লোডিং স্টেট
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator(color: AppColors.primary));
        }

        var data = controller.orderDetails;
        var provider = data['provider'];

        // স্ট্যাটাস চেক
        bool isCancelled = data['status'] == "Cancelled";
        bool isCompleted = data['status'] == "Completed";

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- 1. Top Status Banner ---
              // অর্ডারের অবস্থা অনুযায়ী কালার এবং মেসেজ দেখাবে
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isCancelled ? Colors.redAccent.withOpacity(0.1) : AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                      color: isCancelled ? Colors.redAccent.withOpacity(0.3) : AppColors.primary.withOpacity(0.3)
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      isCancelled ? "Booking Cancelled" : data['status'],
                      style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isCancelled ? Colors.redAccent : AppColors.primary
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      "Order ID: ${data['id']}",
                      style: GoogleFonts.poppins(color: Colors.black54, fontSize: 13),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25),

              // --- 2. Service Provider Card ---
              Text("Service Provider", style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 15),

              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5))],
                ),
                child: Row(
                  children: [
                    // Provider Avatar
                    Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: const Icon(Icons.person, color: Colors.grey, size: 30),
                    ),
                    const SizedBox(width: 15),

                    // Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            provider['name'],
                            style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.star_rounded, size: 16, color: Colors.amber),
                              Text(
                                " ${provider['rating']} (${provider['jobs_done']} jobs)",
                                style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey.shade600),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Call Button (Cancelled হলে দেখাবে না)
                    if (!isCancelled)
                      IconButton(
                        onPressed: controller.callProvider,
                        style: IconButton.styleFrom(backgroundColor: Colors.green.shade50),
                        icon: const Icon(Icons.phone_rounded, color: Colors.green),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 25),

              // --- 3. Order Timeline (Tracking) ---
              if (!isCancelled) ...[
                Text("Track Order", style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 15),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.05), blurRadius: 10)],
                  ),
                  child: Column(
                    children: List.generate((data['timeline'] as List).length, (index) {
                      var step = data['timeline'][index];
                      bool isLast = index == (data['timeline'] as List).length - 1;

                      // IntrinsicHeight ব্যবহার করা হয়েছে যাতে লাইনটি টেক্সটের হাইট অনুযায়ী বড় হয়
                      return IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              children: [
                                Icon(
                                  step['isCompleted'] ? Icons.check_circle : Icons.radio_button_unchecked,
                                  color: step['isCompleted'] ? AppColors.primary : Colors.grey.shade300,
                                  size: 20,
                                ),
                                if (!isLast)
                                  Expanded(
                                    child: Container(
                                      width: 2,
                                      color: step['isCompleted'] ? AppColors.primary.withOpacity(0.5) : Colors.grey.shade200,
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 25.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      step['title'],
                                      style: GoogleFonts.poppins(
                                        fontWeight: step['isCompleted'] ? FontWeight.w600 : FontWeight.normal,
                                        color: step['isCompleted'] ? Colors.black87 : Colors.grey,
                                      ),
                                    ),
                                    if (step['time'] != "-")
                                      Text(
                                        step['time'],
                                        style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey),
                                      ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      );
                    }),
                  ),
                ),
                const SizedBox(height: 25),
              ],

              // --- 4. Detailed Info ---
              Text("Booking Information", style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 15),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.05), blurRadius: 10)],
                ),
                child: Column(
                  children: [
                    _buildInfoRow(Icons.cleaning_services_outlined, "Service", data['service_name']),
                    const Divider(height: 25),
                    _buildInfoRow(Icons.calendar_today_outlined, "Date & Time", "${data['date']} | ${data['time']}"),
                    const Divider(height: 25),
                    _buildInfoRow(Icons.location_on_outlined, "Address", data['address']),
                    const Divider(height: 25),
                    _buildInfoRow(Icons.payment_outlined, "Payment", "${data['payment_method']} (${data['price']})"),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // --- 5. Cancel Button ---
              // শুধুমাত্র যদি অর্ডার Active থাকে তখনই দেখাবে
              // যদি কমপ্লিট হয়ে থাকে তবে রিভিউ বাটন দেখান
              if (data['status'] == "Completed")
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () => Get.to(() => const RateReviewView()), // রিভিউ পেজে যাবে
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text(
                      "Rate Service",
                      style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ),
              const SizedBox(height: 20),
            ],
          ),
        );
      }),
    );
  }

  // হেল্পার মেথড: ইনফো রো তৈরি করার জন্য
  Widget _buildInfoRow(IconData icon, String title, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: Colors.grey.shade400),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey)),
              const SizedBox(height: 2),
              Text(value, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500, height: 1.4)),
            ],
          ),
        ),
      ],
    );
  }
}