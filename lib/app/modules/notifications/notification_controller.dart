import 'package:get/get.dart';
import '../../data/model/notification_model.dart';

class NotificationController extends GetxController {
  var notifications = <NotificationModel>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadNotifications();
  }

  void loadNotifications() async {
    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 1)); // ফেক লোডিং

    notifications.assignAll([
      NotificationModel(
        id: "1",
        title: "Booking Confirmed",
        body: "Your AC Service request has been confirmed. Provider will arrive at 10 AM.",
        time: "2 mins ago",
        isRead: false, // এটি Unread থাকবে
        type: "order",
      ),
      NotificationModel(
        id: "2",
        title: "50% Off on Cleaning!",
        body: "Use code CLEAN50 to get flat 50% discount on sofa cleaning.",
        time: "1 hour ago",
        isRead: false,
        type: "offer",
      ),
      NotificationModel(
        id: "3",
        title: "Service Completed",
        body: "Your last service order #ORD-1098 has been marked as completed.",
        time: "Yesterday",
        isRead: true, // এটি Read হয়ে গেছে
        type: "order",
      ),
      NotificationModel(
        id: "4",
        title: "Welcome to Urban Service",
        body: "Thanks for joining us! Setup your profile now.",
        time: "2 days ago",
        isRead: true,
        type: "system",
      ),
    ]);

    isLoading.value = false;
  }

  // সব রিড মার্ক করা
  void markAllAsRead() {
    for (var item in notifications) {
      item.isRead = true;
    }
    notifications.refresh();
    Get.snackbar("Updated", "All notifications marked as read");
  }

  // একটি নোটিফিকেশন রিমুভ করা
  void removeNotification(int index) {
    notifications.removeAt(index);
  }

  // নোটিফিকেশনে ক্লিক করলে রিড মার্ক হবে
  void onTapNotification(int index) {
    notifications[index].isRead = true;
    notifications.refresh();
    // এখানে চাইলে ডিটেইলস পেজে রিডাইরেক্ট করতে পারেন
  }
}