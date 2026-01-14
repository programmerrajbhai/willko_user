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

  // ✅ Get Packages based on selected index
  List<Map<String, dynamic>> get packages {
    final allPackages = service["packagesByItem"];
    if (allPackages == null) return [];

    // Handle both int keys (from local map) and string keys (from JSON)
    final list = (allPackages as Map)[selectedItemIndex.value] ??
        allPackages[selectedItemIndex.value.toString()] ?? [];

    return (list as List).cast<Map<String, dynamic>>();
  }

  // ✅ Dynamic Banner Data Generation
  Map<String, dynamic> get currentBannerData {
    if (items.isEmpty) return {};

    final itemTitle = items[selectedItemIndex.value]["title"] ?? "";
    final titleLower = itemTitle.toString().toLowerCase();

    if (titleLower.contains("repair") || titleLower.contains("fix")) {
      return {
        "title": "Stay Cool with\nAC Repairing Service",
        "bullets": ["Same day service", "Genuine spare parts", "30 days warranty"],
        "icon": Icons.build_circle_outlined,
        "color": const Color(0xFF2C2C2C) // Dark Theme
      };
    } else if (titleLower.contains("install") || titleLower.contains("wiring") || titleLower.contains("setup")) {
      return {
        "title": "Flawless Installation\nProficiency",
        "bullets": ["Certified experts", "No wall damage", "Vacuum pump used"],
        "icon": Icons.settings_suggest_outlined,
        "color": const Color(0xFF0F9D58) // Green Theme
      };
    } else {
      return {
        "title": "Deep Cleaning for\nQuick Cooling",
        "bullets": ["Foam-jet technology", "7+ years experience", "30 days guarantee"],
        "icon": Icons.ac_unit,
        "color": const Color(0xFF6C45E5) // Purple Theme
      };
    }
  }

  // --- Actions ---
  void selectItem(int idx) => selectedItemIndex.value = idx;

  // --- 🛒 CART & SHEET LOGIC ---

  void openProductDetailsSheet(BuildContext context, Map<String, dynamic> product) {
    selectedProductForSheet.value = product;
    String pTitle = product['title'];

    // If item exists in cart, sync quantity.
    // If NOT in cart, start at 0 (user must click + to add).
    if (cartItems.containsKey(pTitle)) {
      sheetTempQty.value = cartItems[pTitle]!['quantity'];
    } else {
      sheetTempQty.value = 0;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      transitionAnimationController: AnimationController(
        vsync: Navigator.of(context),
        duration: const Duration(milliseconds: 350),
      ),
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.85,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (_, sc) => ProductDetailSheet(scrollController: sc),
      ),
    );
  }

  void incrementSheetQty() => sheetTempQty.value++;

  void decrementSheetQty() {
    if (sheetTempQty.value > 0) sheetTempQty.value--;
  }

  // ✅ Confirm Selection & Close Sheet (The Magic Function)
  void confirmSheetSelection() {
    final product = selectedProductForSheet.value;
    if (product != null) {
      String pTitle = product['title'];

      if (sheetTempQty.value > 0) {
        final Map<String, dynamic> cartItem = Map.from(product);
        cartItem['quantity'] = sheetTempQty.value;
        cartItems[pTitle] = cartItem; // Update Main Cart

        Get.snackbar(
          "Cart Updated",
          "$pTitle added",
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(16),
          backgroundColor: Colors.black87,
          colorText: Colors.white,
          duration: const Duration(milliseconds: 1500),
        );
      } else {
        cartItems.remove(pTitle); // Remove if 0
      }
    }
    Get.back(); // Close Sheet
  }

  // Direct modification from Sidebar (Plus/Minus buttons)
  void updateCartQty(String title, int newQty) {
    if (cartItems.containsKey(title)) {
      if (newQty > 0) {
        cartItems[title]!['quantity'] = newQty;
        cartItems.refresh(); // Force update UI
      } else {
        cartItems.remove(title);
      }
    }
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