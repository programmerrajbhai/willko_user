import 'dart:js' as js;
import 'package:flutter/foundation.dart';

class PixelTracker {
  // ১. ভিউ আইটেম (যখন ইউজার কোনো সার্ভিসের ডিটেইলস দেখবে)
  static void trackViewItem({required String serviceName, required double price}) {
    if (kIsWeb) {
      js.context.callMethod('firePixelEvent', [
        'view_item',
        js.JsObject.jsify({
          'item_name': serviceName,
          'value': price,
          'currency': 'QAR'
        })
      ]);
    }
  }

  // ২. বিগিন চেকআউট (যখন ইউজার পেমেন্ট বা কনফার্মেশন পেইজে যাবে)
  static void trackBeginCheckout({required double totalAmount}) {
    if (kIsWeb) {
      js.context.callMethod('firePixelEvent', [
        'begin_checkout',
        js.JsObject.jsify({
          'value': totalAmount,
          'currency': 'QAR'
        })
      ]);
    }
  }

  // ৩. পারচেজ বা অর্ডার সাকসেস (যখন অর্ডার কনফার্ম হবে)
  static void trackPurchase({required String orderId, required double amount}) {
    if (kIsWeb) {
      js.context.callMethod('firePixelEvent', [
        'purchase',
        js.JsObject.jsify({
          'transaction_id': orderId,
          'value': amount,
          'currency': 'QAR'
        })
      ]);
    }
  }
}