import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../../../data/model/cart_item_model.dart';
import '../address/address_view.dart';
import '../coupon/coupon_view.dart'; // কুপন ভিউ ইমপোর্ট করুন

class CartController extends GetxController {
  // ১. কার্ট আইটেম লিস্ট
  var cartItems = <CartItem>[].obs;

  // ২. কুপন ও ডিসকাউন্ট ভেরিয়েবল
  var discount = 0.0.obs;
  var appliedCouponCode = "".obs;

  // ডামি ডাটা দিয়ে ইনিশিয়ালাইজ
  @override
  void onInit() {
    super.onInit();
    cartItems.addAll([
      CartItem(id: 101, name: "AC Service (Split)", price: 800, image: Icons.ac_unit_rounded),
      CartItem(id: 103, name: "Sofa Deep Cleaning", price: 1200, quantity: 2, image: Icons.chair_rounded),
    ]);
  }

  // ৩. ক্যালকুলেশন গেটার (Getters)
  double get itemTotal => cartItems.fold(0, (sum, item) => sum + (item.price * item.quantity));

  double get taxAmount => itemTotal * 0.05; // 5% ভ্যাট বা ট্যাক্স

  // গ্র্যান্ড টোটাল (আইটেম + ট্যাক্স - ডিসকাউন্ট)
  double get grandTotal => itemTotal + taxAmount - discount.value;

  // ৪. কার্ট অ্যাকশন মেথড (Qty Increase/Decrease)
  void incrementQty(int index) {
    cartItems[index].quantity++;
    cartItems.refresh();
    // Qty পাল্টালে যদি মিনিমাম অর্ডারের শর্ত থাকে তবে কুপন রি-ভ্যালিডেট করা উচিত (Optional)
  }

  void decrementQty(int index) {
    if (cartItems[index].quantity > 1) {
      cartItems[index].quantity--;
    } else {
      cartItems.removeAt(index);
    }
    cartItems.refresh();
  }

  void removeItem(int index) {
    cartItems.removeAt(index);
  }

  // ৫. কুপন লজিক (নতুন অ্যাড করা হলো)
  void goToCouponPage() async {
    // CouponView পেজে যাওয়া এবং রেজাল্ট নিয়ে আসা
    var result = await Get.to(() => CouponView(cartTotal: itemTotal));

    if (result != null) {
      appliedCouponCode.value = result['code'];
      // result['amount'] ডাবল বা ইন্টিজার হতে পারে, তাই সেইফ পার্সিং
      discount.value = double.parse(result['amount'].toString());

      Get.snackbar(
          "Applied",
          "Coupon ${result['code']} applied successfully!",
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(20)
      );
    }
  }

  void removeCoupon() {
    discount.value = 0.0;
    appliedCouponCode.value = "";
    Get.snackbar(
        "Removed",
        "Coupon removed successfully",
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(20)
    );
  }

  // ৬. চেকআউট নেভিগেশন
  void proceedToCheckout() {
    if (cartItems.isEmpty) {
      Get.snackbar("Empty Cart", "Please add services first.");
      return;
    }
    // চেকআউটের আগে এড্রেস সিলেক্ট করতে পাঠানো
    Get.to(() => const AddressView());
  }
}