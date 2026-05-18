// ফাইল: lib/utils/pixel_tracker_stub.dart

// এটি মোবাইল (Android/iOS) অ্যাপের জন্য ডামি/ফাঁকা ক্লাস
// এর ফলে মোবাইলে অ্যাপ রান করার সময় dart:js এর কোনো এরর আসবে না।
class PixelTrackerImpl {
  static void trackViewItem(String serviceName, double price) {
    // মোবাইলে কোনো কাজ করবে না
  }

  static void trackBeginCheckout(double totalAmount) {
    // মোবাইলে কোনো কাজ করবে না
  }

  static void trackPurchase(String orderId, double amount) {
    // মোবাইলে কোনো কাজ করবে না
  }
}