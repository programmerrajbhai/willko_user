// ফাইল: lib/utils/pixel_tracker_stub.dart

class PixelTrackerImpl {
  static void trackViewItem(String serviceId, String serviceName, double price) {}

  static void trackAddToCart(String serviceId, String serviceName, double price, int quantity) {}

  static void trackBeginCheckout(double totalAmount, List<Map<String, dynamic>> items) {}

  static void trackPurchase(String orderId, double amount, List<Map<String, dynamic>> items) {}
}