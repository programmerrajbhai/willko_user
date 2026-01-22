import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:willko_user/utils/app_colors.dart';
import '../../review/rate_review_view.dart';
import 'order_details_controller.dart';

class OrderDetailsView extends StatelessWidget {
  const OrderDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OrderDetailsController());

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20, color: Colors.black87),
          onPressed: () => Get.back(),
        ),
        title: Text("Booking Details", style: GoogleFonts.poppins(color: Colors.black87, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator(color: AppColors.primary));
        }

        if (controller.orderDetails.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 48, color: Colors.redAccent),
                const SizedBox(height: 10),
                Text("Failed to load details", style: GoogleFonts.poppins(color: Colors.grey)),
                TextButton(
                  onPressed: () => controller.fetchOrderDetails(Get.arguments.toString()), 
                  child: const Text("Retry")
                )
              ],
            ),
          );
        }

        var data = controller.orderDetails;
        var provider = data['provider'];
        String status = data['status'];
        bool isCancelled = status == "Cancelled";
        bool isCompleted = status == "Completed";
        bool isActive = !isCancelled && !isCompleted && status != "Completed"; // Extra check

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildStatusBanner(status, data['id'], isCancelled, isCompleted),
              const SizedBox(height: 25),

              if (provider != null) 
                _buildProviderCard(provider, isCancelled, controller),
              
              if (provider != null) 
                const SizedBox(height: 25),

              if (!isCancelled) ...[
                Text("Track Status", style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 15),
                _buildTimeline(data['timeline']),
                const SizedBox(height: 25),
              ],

              Text("Booking Details", style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 15),
              _buildInfoCard(data),

              const SizedBox(height: 40),

              if (isActive)
                SizedBox(
                  width: double.infinity, height: 50,
                  child: OutlinedButton(
                    onPressed: controller.cancelOrder,
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.redAccent), 
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
                    ),
                    child: Text("Cancel Booking", style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.redAccent)),
                  ),
                ),

              if (isCompleted)
                SizedBox(
                  width: double.infinity, height: 50,
                  child: ElevatedButton(
                    onPressed: () => Get.to(() => const RateReviewView()),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary, 
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
                    ),
                    child: Text("Rate Service", style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                ),
              const SizedBox(height: 20),
            ],
          ),
        );
      }),
    );
  }

  // --- Widgets ---
  Widget _buildStatusBanner(String status, String id, bool isCancelled, bool isCompleted) {
    Color color = isCancelled ? Colors.red : (isCompleted ? Colors.green : AppColors.primary);
    IconData icon = isCancelled ? Icons.cancel : (isCompleted ? Icons.check_circle : Icons.hourglass_top_rounded);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 30),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(status, style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
                Text("Order ID: $id", style: GoogleFonts.poppins(color: Colors.black54, fontSize: 13)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProviderCard(Map provider, bool isCancelled, OrderDetailsController controller) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white, 
        borderRadius: BorderRadius.circular(16), 
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.05), blurRadius: 10)]
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: Colors.grey.shade100,
            backgroundImage: (provider['image'] != null && provider['image'].isNotEmpty)
                ? NetworkImage(provider['image']) 
                : const AssetImage("assets/images/service_man.jpg") as ImageProvider,
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(provider['name'], style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16)),
                Row(children: [
                  const Icon(Icons.star, size: 16, color: Colors.amber), 
                  Text(" ${provider['rating']}", style: GoogleFonts.poppins(fontSize: 12))
                ]),
              ],
            ),
          ),
          if (!isCancelled)
            IconButton(
              onPressed: () => controller.callProvider(provider['phone']),
              style: IconButton.styleFrom(backgroundColor: Colors.green.shade50),
              icon: const Icon(Icons.call, color: Colors.green),
            ),
        ],
      ),
    );
  }

  Widget _buildTimeline(List timeline) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: List.generate(timeline.length, (index) {
          var step = timeline[index];
          bool isLast = index == timeline.length - 1;
          return IntrinsicHeight(
            child: Row(
              children: [
                Column(children: [
                  Icon(step['isCompleted'] ? Icons.check_circle : Icons.radio_button_unchecked, color: step['isCompleted'] ? AppColors.primary : Colors.grey.shade300, size: 20),
                  if (!isLast) Expanded(child: Container(width: 2, color: step['isCompleted'] ? AppColors.primary.withOpacity(0.3) : Colors.grey.shade200)),
                ]),
                const SizedBox(width: 15),
                Expanded(child: Padding(padding: const EdgeInsets.only(bottom: 25.0), child: Text(step['title'], style: GoogleFonts.poppins(fontWeight: step['isCompleted'] ? FontWeight.w600 : FontWeight.normal)))),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildInfoCard(Map data) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          _infoRow(Icons.cleaning_services_outlined, "Service", data['service_name']),
          const Divider(height: 25),
          _infoRow(Icons.calendar_today_outlined, "Schedule", "${data['date']} | ${data['time']}"),
          const Divider(height: 25),
          _infoRow(Icons.location_on_outlined, "Address", data['address']),
          const Divider(height: 25),
          _infoRow(Icons.payment_outlined, "Price", data['price']),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String title, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: Colors.grey.shade400),
        const SizedBox(width: 15),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey)),
            Text(value, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500)),
          ]),
        ),
      ],
    );
  }
}