import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../utils/app_colors.dart'; // কালার ইমপোর্ট
import '../../../data/model/cart_item_model.dart';
import '../address/address_view.dart';
import '../coupon/coupon_view.dart';

class CartController extends GetxController {
  // ১. স্টেট ভেরিয়েবল
  var cartItems = <CartItem>[].obs;
  var discount = 0.0.obs;
  var appliedCouponCode = "".obs;

  // ২. ইনিশিয়ালাইজেশন (ডামি ডাটা)
  @override
  void onInit() {
    super.onInit();
    loadDummyData();
  }

  void loadDummyData() {
    cartItems.addAll([
      CartItem(id: 101, name: "AC Service (Split)", price: 800, image: Icons.ac_unit_rounded),
      CartItem(id: 103, name: "Sofa Deep Cleaning", price: 1200, quantity: 2, image: Icons.chair_rounded),
    ]);
  }

  // ৩. ক্যালকুলেশন (Getters)
  double get itemTotal => cartItems.fold(0, (sum, item) => sum + (item.price * item.quantity));
  
  double get taxAmount => itemTotal * 0.05; // 5% ভ্যাট

  double get grandTotal {
    double total = itemTotal + taxAmount - discount.value;
    return total < 0 ? 0 : total; // টোটাল যেন নেগেটিভ না হয়
  }

  // ৪. কার্ট অ্যাকশন (Qty Control)
  void incrementQty(int index) {
    cartItems[index].quantity++;
    cartItems.refresh();
  }

  void decrementQty(int index) {
    if (cartItems[index].quantity > 1) {
      cartItems[index].quantity--;
    } else {
      cartItems.removeAt(index);
      // আইটেম মুছে ফেললে কুপন লজিক চেক করা উচিত (এখানে সিম্পল রাখা হলো)
    }
    cartItems.refresh();
  }

  void removeItem(int index) {
    cartItems.removeAt(index);
  }

  void clearCart() {
    cartItems.clear();
    discount.value = 0.0;
    appliedCouponCode.value = "";
  }

  // ৫. কুপন ম্যানেজমেন্ট
  void goToCouponPage() async {
    // কুপন পেজ থেকে ডাটা নিয়ে আসা
    var result = await Get.to(() => CouponView(cartTotal: itemTotal));

    if (result != null) {
      appliedCouponCode.value = result['code'];
      discount.value = double.parse(result['amount'].toString());

      Get.snackbar(
          "Success",
          "Coupon '${result['code']}' applied successfully!",
          backgroundColor: AppColors.secondary, // Greenish color
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(20),
          borderRadius: 10
      );
    }
  }

  void removeCoupon() {
    discount.value = 0.0;
    appliedCouponCode.value = "";
    Get.snackbar(
        "Removed",
        "Coupon has been removed.",
        backgroundColor: Colors.black87,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(20),
        borderRadius: 10
    );
  }

  // ৬. নেভিগেশন
  void proceedToCheckout() {
    if (cartItems.isEmpty) {
      Get.snackbar(
        "Cart is Empty", 
        "Please add services to proceed.",
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(20)
      );
      return;
    }
    // কার্ট ঠিক থাকলে এড্রেস পেজে পাঠানো
    Get.to(() => const AddressView());
  }
}