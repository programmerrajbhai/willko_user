import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:willko_user/app/modules/order/order_details/order_details_view.dart'; // পাথ চেক করুন
import '../../../../utils/app_colors.dart';
import 'my_orders_controller.dart';

class MyOrdersView extends StatelessWidget {
  const MyOrdersView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MyOrdersController());

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xFFF9F9F9),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black87),
            onPressed: () => Get.back(),
          ),
          title: Text(
            "My Bookings",
            style: GoogleFonts.poppins(color: Colors.black87, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          bottom: TabBar(
            labelColor: AppColors.primary,
            unselectedLabelColor: Colors.grey,
            labelStyle: GoogleFonts.poppins(fontWeight: FontWeight.bold),
            indicatorColor: AppColors.primary,
            indicatorWeight: 3,
            tabs: const [
              Tab(text: "Active"),
              Tab(text: "History"),
            ],
          ),
        ),
        body: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator(color: AppColors.primary));
          }
          return TabBarView(
            children: [
              // ✅ RefreshIndicator যোগ করা হয়েছে
              RefreshIndicator(
                onRefresh: () async => await controller.loadOrders(),
                color: AppColors.primary,
                child: _buildOrderList(controller.activeOrders, isHistory: false),
              ),

              RefreshIndicator(
                onRefresh: () async => await controller.loadOrders(),
                color: AppColors.primary,
                child: _buildOrderList(controller.pastOrders, isHistory: true),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildOrderList(List<Map<String, dynamic>> orders, {required bool isHistory}) {
    // ✅ AlwaysScrollableScrollPhysics দেওয়া হয়েছে যাতে ডাটা কম থাকলেও টান দেওয়া যায়
    if (orders.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(height: Get.height * 0.3),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.receipt_long_rounded, size: 60, color: Colors.grey.shade300),
                const SizedBox(height: 10),
                Text("No orders found", style: GoogleFonts.poppins(color: Colors.grey)),
              ],
            ),
          ),
        ],
      );
    }

    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(), // Pull-to-refresh এর জন্য জরুরি
      padding: const EdgeInsets.all(20),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        var item = orders[index];

        return GestureDetector(
          onTap: () {
            // ✅ আপডেট লজিক: ডিটেইলস পেজ থেকে ব্যাক করলে লিস্ট রিফ্রেশ হবে
            Get.to(() => const OrderDetailsView(), arguments: item['id'])?.then((_) {
              final controller = Get.find<MyOrdersController>();
              controller.loadOrders();
            });
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 15),
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4)
                )
              ],
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(item['image'], color: Colors.grey.shade600),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['service'],
                            style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Booking ID: ${item['display_id']}", 
                            style: GoogleFonts.poppins(color: Colors.grey, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    // Status Chip
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: (item['color'] as Color).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        item['status'],
                        style: GoogleFonts.poppins(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: item['color']
                        ),
                      ),
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Divider(),
                ),

                // Details
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.calendar_today_rounded, size: 14, color: Colors.grey),
                        const SizedBox(width: 5),
                        Text(
                          "${item['date']} • ${item['time']}",
                          style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey.shade700),
                        ),
                      ],
                    ),
                    Text(
                      item['price'],
                      style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                  ],
                ),

                // Track Button
                if (!isHistory) ...[
                  const SizedBox(height: 15),
                  SizedBox(
                    width: double.infinity,
                    height: 40,
                    child: OutlinedButton(
                      onPressed: () {
                         Get.to(() => const OrderDetailsView(), arguments: item['id'])?.then((_) {
                           final controller = Get.find<MyOrdersController>();
                           controller.loadOrders();
                         });
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.primary),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: Text(
                        "Track Booking",
                        style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: AppColors.primary),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}