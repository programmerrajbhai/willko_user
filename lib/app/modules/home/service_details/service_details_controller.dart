import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'service_details_view.dart';

class ServiceDetailsController extends GetxController {
  final Map<String, dynamic> service;

  ServiceDetailsController({required this.service});

  // --- Observables ---
  final selectedItemIndex = 0.obs;

  // ✅ MAIN CART STATE: Key = Product Title, Value = Product Map (with quantity)
  final cartItems = <String, Map<String, dynamic>>{}.obs;

  // ✅ SHEET STATE: Temporary state while sheet is open
  final selectedProductForSheet = Rxn<Map<String, dynamic>>();
  final sheetTempQty = 0.obs;

  // --- Getters from Data ---
  String get title => service["label"] ?? "";
  double get rating => (service["rating"] ?? 0).toDouble();
  String get bookings => service["bookings"] ?? "";

  List<Map<String, dynamic>> get items =>
      (service["items"] as List).cast<Map<String, dynamic>>();

  List<Map<String, dynamic>> get packages {
    final allPackages = service["packagesByItem"] as Map;
    final list = allPackages[selectedItemIndex.value] ??
        allPackages[selectedItemIndex.value.toString()] ?? [];
    return (list as List).cast<Map<String, dynamic>>();
  }

  // Dynamic Banner Data
  Map<String, dynamic> get currentBannerData {
    if(items.isEmpty) return {};
    final itemTitle = items[selectedItemIndex.value]["title"] ?? "";
    final titleLower = itemTitle.toString().toLowerCase();

    if (titleLower.contains("repair")) {
      return {
        "title": "Stay Cool with\nAC Repairing Service",
        "bullets": ["Same day service", "Genuine spare parts", "30 days warranty"],
        "icon": Icons.build_circle_outlined,
        "color": const Color(0xFF2C2C2C)
      };
    } else if (titleLower.contains("install")) {
      return {
        "title": "Flawless Installation\nProficiency",
        "bullets": ["Certified experts", "No wall damage", "Vacuum pump used"],
        "icon": Icons.settings_suggest_outlined,
        "color": const Color(0xFF0F9D58)
      };
    } else {
      return {
        "title": "Deep Cleaning for\nQuick Cooling",
        "bullets": ["Foam-jet technology", "7+ years experience", "30 days guarantee"],
        "icon": Icons.ac_unit,
        "color": const Color(0xFF6C45E5)
      };
    }
  }

  // --- Actions ---
  void selectItem(int idx) => selectedItemIndex.value = idx;

  // --- 🛒 CART LOGIC ---

  // Open Product Details Sheet
  void openProductDetailsSheet(BuildContext context, Map<String, dynamic> product) {
    selectedProductForSheet.value = product;
    String pTitle = product['title'];

    if (cartItems.containsKey(pTitle)) {
      sheetTempQty.value = cartItems[pTitle]!['quantity'];
    } else {
      sheetTempQty.value = 0;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.85,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (_, sc) => ProductDetailSheet(scrollController: sc),
      ),
    );
  }

  // Open Cart Summary Sheet
  void openCartSheet(BuildContext context) {
    if (cartItems.isEmpty) {
      Get.snackbar("Cart is empty", "Add services to proceed",
          snackPosition: SnackPosition.BOTTOM, margin: const EdgeInsets.all(16));
      return;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        builder: (_, sc) => CartBottomSheet(scrollController: sc),
      ),
    );
  }

  void incrementSheetQty() => sheetTempQty.value++;

  void decrementSheetQty() {
    if (sheetTempQty.value > 0) sheetTempQty.value--;
  }

  // ✅ Confirm & Close Sheet
  void confirmSheetSelection() {
    final product = selectedProductForSheet.value;
    if (product != null) {
      String pTitle = product['title'];

      if (sheetTempQty.value > 0) {
        final Map<String, dynamic> cartItem = Map.from(product);
        cartItem['quantity'] = sheetTempQty.value;
        cartItems[pTitle] = cartItem;

        Get.snackbar("Cart Updated", "$pTitle added",
            snackPosition: SnackPosition.BOTTOM,
            margin: const EdgeInsets.all(16),
            backgroundColor: Colors.black87,
            colorText: Colors.white,
            duration: const Duration(seconds: 1));
      } else {
        cartItems.remove(pTitle);
      }
    }
    Get.back();
  }

  // Direct modification from Sidebar/Cart Sheet
  void updateCartQty(String title, int newQty) {
    if (cartItems.containsKey(title)) {
      if (newQty > 0) {
        cartItems[title]!['quantity'] = newQty;
        cartItems.refresh();
      } else {
        cartItems.remove(title);
      }
    }
  }

  // ✅ Checkout Action
  void proceedToCheckout() {
    Get.back(); // Close any open sheet
    Get.snackbar("Processing", "Proceeding to secure checkout...",
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        backgroundColor: const Color(0xFF6C45E5),
        colorText: Colors.white,
        icon: const Icon(Icons.check_circle, color: Colors.white));
  }

  // ✅ Total Price Calculation
  int get totalCartPrice {
    return cartItems.values.fold(0, (sum, item) {
      int price = (item['priceInt'] ?? 0);
      int qty = (item['quantity'] ?? 0);
      return sum + (price * qty);
    });
  }

  int get totalCartItems => cartItems.length;
}