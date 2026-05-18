// ফাইল: lib/utils/pixel_tracker_web.dart
import 'dart:js' as js;

class PixelTrackerImpl {
  static void trackViewItem(String serviceName, double price) {
    js.context.callMethod('firePixelEvent', [
      'view_item',
      js.JsObject.jsify({
        'item_name': serviceName,
        'value': price,
        'currency': 'QAR'
      })
    ]);
  }

  static void trackBeginCheckout(double totalAmount) {
    js.context.callMethod('firePixelEvent', [
      'begin_checkout',
      js.JsObject.jsify({
        'value': totalAmount,
        'currency': 'QAR'
      })
    ]);
  }

  static void trackPurchase(String orderId, double amount) {
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