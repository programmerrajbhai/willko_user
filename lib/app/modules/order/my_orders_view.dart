import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:willko_user/app/modules/home/home_view.dart'; // হোম ভিউ ইমপোর্ট করুন
import 'package:willko_user/app/modules/order/order_details/order_details_view.dart';
import '../../../../utils/app_colors.dart';
import 'my_orders_controller.dart';

class MyOrdersView extends StatelessWidget {
  const MyOrdersView({super.key});

  @override
  Widget build(BuildContext context) {
    // কন্ট্রোলার চেক করে পুট করা (যাতে ডুপ্লিকেট না হয়)
    final controller = Get.isRegistered<MyOrdersController>()
        ? Get.find<MyOrdersController>()
        : Get.put(MyOrdersController());

    // PopScope ব্যবহার করা হয়েছে যাতে সিস্টেম ব্যাক বাটন চাপলেও হোমে যায়
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        Get.offAll(() => const HomeView());
      },
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: const Color(0xFFF8F9FB),
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0.5,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black87, size: 20),
              onPressed: () => Get.offAll(() => const HomeView()), // 🚀 সরাসরি হোমে ব্যাক করবে
            ),
            title: Text(
              "My Bookings",
              style: GoogleFonts.poppins(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 18),
            ),
            centerTitle: true,
            bottom: TabBar(
              labelColor: AppColors.primary,
              unselectedLabelColor: Colors.grey.shade500,
              labelStyle: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 14),
              unselectedLabelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w500, fontSize: 14),
              indicatorColor: AppColors.primary,
              indicatorWeight: 3,
              indicatorSize: TabBarIndicatorSize.label,
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
                _buildRefreshableList(controller, controller.activeOrders, isHistory: false),
                _buildRefreshableList(controller, controller.pastOrders, isHistory: true),
              ],
            );
          }),
        ),
      ),
    );
  }

  // রিফ্রেশ লজিক সহ লিস্ট বিল্ডার
  Widget _buildRefreshableList(MyOrdersController controller, List<Map<String, dynamic>> orders, {required bool isHistory}) {
    return RefreshIndicator(
      onRefresh: () async => await controller.loadOrders(),
      color: AppColors.primary,
      child: _buildOrderList(orders, isHistory: isHistory),
    );
  }

  Widget _buildOrderList(List<Map<String, dynamic>> orders, {required bool isHistory}) {
    if (orders.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(height: Get.height * 0.25),
          Center(
            child: Column(
              children: [
                Opacity(
                  opacity: 0.5,
                  child: Icon(Icons.receipt_long_rounded, size: 80, color: Colors.grey.shade400),
                ),
                const SizedBox(height: 16),
                Text(
                  "No ${isHistory ? 'history' : 'active'} bookings found",
                  style: GoogleFonts.poppins(color: Colors.grey.shade600, fontSize: 15, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ],
      );
    }

    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        var item = orders[index];
        return _buildOrderCard(item, isHistory);
      },
    );
  }

  Widget _buildOrderCard(Map<String, dynamic> item, bool isHistory) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))
        ],
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => _goToDetails(item['id']),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    height: 45, width: 45,
                    decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(12)),
                    child: Icon(item['image'] ?? Icons.miscellaneous_services, color: AppColors.primary, size: 24),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['service'] ?? "Service",
                          style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 15),
                          maxLines: 1, overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          "ID: ${item['display_id']}",
                          style: GoogleFonts.poppins(color: Colors.grey.shade500, fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                  _buildStatusChip(item['status'], item['color']),
                ],
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Divider(height: 1, thickness: 0.5),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.calendar_today_outlined, size: 12, color: Colors.grey.shade600),
                          const SizedBox(width: 4),
                          Text(
                            "${item['date']} • ${item['time']}",
                            style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey.shade700, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Text(
                    item['price'] ?? "QR 0",
                    style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.primary),
                  ),
                ],
              ),
              if (!isHistory) ...[
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 38,
                  child: ElevatedButton(
                    onPressed: () => _goToDetails(item['id']),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppColors.primary,
                      elevation: 0,
                      side: const BorderSide(color: AppColors.primary, width: 1),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Text("Track Booking", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 13)),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withOpacity(0.2), width: 0.5)
      ),
      child: Text(
        status,
        style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.bold, color: color),
      ),
    );
  }

  void _goToDetails(dynamic id) {
    Get.to(() => const OrderDetailsView(), arguments: id)?.then((_) {
      if (Get.isRegistered<MyOrdersController>()) {
        Get.find<MyOrdersController>().loadOrders();
      }
    });
  }
}