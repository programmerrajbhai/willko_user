import 'package:flutter/foundation.dart';
// 🔥 Conditional Import: শুধুমাত্র ওয়েব হলেই js প্যাকেজটি ইমপোর্ট হবে
import 'pixel_tracker_web.dart' if (dart.library.io) 'pixel_tracker_stub.dart';

class PixelTracker {
  // ১. ভিউ আইটেম (যখন ইউজার কোনো সার্ভিসের ডিটেইলস দেখবে)
  static void trackViewItem({required String serviceName, required double price}) {
    if (kIsWeb) {
      PixelTrackerImpl.trackViewItem(serviceName, price);
    }
  }

  // ২. বিগিন চেকআউট (যখন ইউজার পেমেন্ট বা কনফার্মেশন পেইজে যাবে)
  static void trackBeginCheckout({required double totalAmount}) {
    if (kIsWeb) {
      PixelTrackerImpl.trackBeginCheckout(totalAmount);
    }
  }

  // ৩. পারচেজ বা অর্ডার সাকসেস (যখন অর্ডার কনফার্ম হবে)
  static void trackPurchase({required String orderId, required double amount}) {
    if (kIsWeb) {
      PixelTrackerImpl.trackPurchase(orderId, amount);
    }
  }
}