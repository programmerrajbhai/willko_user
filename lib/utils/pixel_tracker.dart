import 'package:flutter/foundation.dart';
import 'pixel_tracker_web.dart' if (dart.library.io) 'pixel_tracker_stub.dart';

class PixelTracker {
  // View Item
  static void trackViewItem({required String serviceId, required String serviceName, required double price}) {
    if (kIsWeb) PixelTrackerImpl.trackViewItem(serviceId, serviceName, price);
  }

  // Add To Cart
  static void trackAddToCart({required String serviceId, required String serviceName, required double price, required int quantity}) {
    if (kIsWeb) PixelTrackerImpl.trackAddToCart(serviceId, serviceName, price, quantity);
  }

  // Begin Checkout
  static void trackBeginCheckout({required double totalAmount, required List<Map<String, dynamic>> items}) {
    if (kIsWeb) PixelTrackerImpl.trackBeginCheckout(totalAmount, items);
  }

  // Purchase
  static void trackPurchase({required String orderId, required double amount, required List<Map<String, dynamic>> items}) {
    if (kIsWeb) PixelTrackerImpl.trackPurchase(orderId, amount, items);
  }
}