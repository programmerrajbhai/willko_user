// ফাইল: lib/utils/pixel_tracker_web.dart

import 'dart:js' as js;

class PixelTrackerImpl {

  // ১. View Item Event (সার্ভিস ডিটেইলস দেখলে)
  static void trackViewItem(String serviceId, String serviceName, double price) {
    var ecommerceData = js.JsObject.jsify({
      'items': [
        {
          'item_id': serviceId,
          'item_name': serviceName,
          'price': price,
          'quantity': 1
        }
      ],
      'currency': 'QR',
      'value': price
    });
    js.context.callMethod('firePixelEvent', ['view_item', ecommerceData]);
  }

  // ২. Add to Cart Event (কার্টে অ্যাড করলে)
  static void trackAddToCart(String serviceId, String serviceName, double price, int quantity) {
    var ecommerceData = js.JsObject.jsify({
      'items': [
        {
          'item_id': serviceId,
          'item_name': serviceName,
          'price': price,
          'quantity': quantity
        }
      ],
      'currency': 'QR',
      'value': price * quantity
    });
    js.context.callMethod('firePixelEvent', ['add_to_cart', ecommerceData]);
  }

  // ৩. Begin Checkout Event (চেকআউট পেজে গেলে)
  static void trackBeginCheckout(double totalAmount, List<Map<String, dynamic>> items) {
    var ecommerceData = js.JsObject.jsify({
      'items': items,
      'currency': 'QR',
      'value': totalAmount
    });
    js.context.callMethod('firePixelEvent', ['begin_checkout', ecommerceData]);
  }

  // ৪. Purchase Event (অর্ডার কমপ্লিট হলে)
  static void trackPurchase(String orderId, double amount, List<Map<String, dynamic>> items) {
    var ecommerceData = js.JsObject.jsify({
      'transaction_id': orderId, // GA4 Purchase ট্র্যাকিংয়ের জন্য এটি বাধ্যতামূলক
      'items': items,
      'currency': 'QR',
      'value': amount
    });
    js.context.callMethod('firePixelEvent', ['purchase', ecommerceData]);
  }
}