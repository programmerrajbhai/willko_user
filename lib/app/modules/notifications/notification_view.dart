import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../utils/app_colors.dart';
import 'notification_controller.dart';

class NotificationView extends StatelessWidget {
  const NotificationView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NotificationController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Get.back(),
        ),
        title: Text(
          "Notifications",
          style: GoogleFonts.poppins(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          // Clear All / Mark Read Button
          IconButton(
            onPressed: controller.markAllAsRead,
            icon: const Icon(Icons.done_all_rounded, color: AppColors.primary),
            tooltip: "Mark all as read",
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator(color: AppColors.primary));
        }

        if (controller.notifications.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.notifications_off_outlined, size: 60, color: Colors.grey.shade300),
                const SizedBox(height: 15),
                Text(
                  "No notifications yet",
                  style: GoogleFonts.poppins(color: Colors.grey, fontSize: 16),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 10),
          itemCount: controller.notifications.length,
          itemBuilder: (context, index) {
            var item = controller.notifications[index];

            // Swipe to Delete Feature
            return Dismissible(
              key: Key(item.id),
              direction: DismissDirection.endToStart,
              onDismissed: (direction) {
                controller.removeNotification(index);
              },
              background: Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 20),
                color: Colors.redAccent,
                child: const Icon(Icons.delete_outline, color: Colors.white),
              ),
              child: GestureDetector(
                onTap: () => controller.onTapNotification(index),
                child: Container(
                  color: item.isRead ? Colors.white : AppColors.primary.withOpacity(0.05), // Unread কালার হাইলাইট
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Icon based on type
                            Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                color: _getIconColor(item.type).withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(_getIcon(item.type), color: _getIconColor(item.type), size: 20),
                            ),
                            const SizedBox(width: 15),

                            // Texts
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        item.title,
                                        style: GoogleFonts.poppins(
                                          fontWeight: item.isRead ? FontWeight.w600 : FontWeight.bold,
                                          fontSize: 15,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      Text(
                                        item.time,
                                        style: GoogleFonts.poppins(
                                            fontSize: 11,
                                            color: Colors.grey,
                                            fontWeight: FontWeight.w500
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    item.body,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.poppins(
                                      color: item.isRead ? Colors.grey.shade600 : Colors.black54,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Unread Dot Indicator
                            if (!item.isRead)
                              Padding(
                                padding: const EdgeInsets.only(left: 10, top: 5),
                                child: Container(
                                  height: 8,
                                  width: 8,
                                  decoration: const BoxDecoration(
                                    color: AppColors.primary,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      Divider(height: 1, color: Colors.grey.shade100),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }

  // হেল্পার: আইকন টাইপ অনুযায়ী
  IconData _getIcon(String type) {
    switch (type) {
      case 'order': return Icons.local_mall_outlined;
      case 'offer': return Icons.local_offer_outlined;
      default: return Icons.notifications_active_outlined;
    }
  }

  // হেল্পার: কালার টাইপ অনুযায়ী
  Color _getIconColor(String type) {
    switch (type) {
      case 'order': return Colors.blue;
      case 'offer': return Colors.orange;
      default: return AppColors.primary;
    }
  }
}