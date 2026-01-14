import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'service_details_view.dart'; // Import View file to access the Sheet widget

class ServiceDetailsController extends GetxController {
  final Map<String, dynamic> service;
  ServiceDetailsController({required this.service});

  // --- Observables ---
  final selectedItemIndex = 0.obs;

  // ✅ MAIN CART STATE: Stores { "Product Title": Quantity }
  final cart = <String, int>{}.obs;

  // ✅ SHEET STATE: Temporary quantity while the sheet is open
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
    final list = allPackages[selectedItemIndex.value] ?? allPackages[selectedItemIndex.value.toString()] ?? [];
    return (list as List).cast<Map<String, dynamic>>();
  }

  // Banner Logic (Keep existing)
  Map<String, dynamic> get currentBannerData {
    final itemTitle = items[selectedItemIndex.value]["title"] ?? "";
    if (itemTitle.toString().toLowerCase().contains("repair")) {
      return {"title": "Stay Cool with\nAC Repairing Service", "bullets": ["Same day service", "Genuine spare parts", "30 days warranty"], "icon": Icons.build_circle_outlined, "color": const Color(0xFF2C2C2C)};
    } else if (itemTitle.toString().toLowerCase().contains("install")) {
      return {"title": "Flawless Installation\nProficiency", "bullets": ["Certified experts", "No wall damage", "Vacuum pump used"], "icon": Icons.settings_suggest_outlined, "color": const Color(0xFF0F9D58)};
    } else {
      return {"title": "Deep Cleaning for\nQuick Cooling", "bullets": ["Foam-jet technology", "7+ years experience", "30 days guarantee"], "icon": Icons.ac_unit, "color": const Color(0xFF6C45E5)};
    }
  }

  // --- Actions ---
  void selectItem(int idx) => selectedItemIndex.value = idx;

  // --- 🛒 CART & SHEET LOGIC ---

  void openProductDetailsSheet(BuildContext context, Map<String, dynamic> product) {
    selectedProductForSheet.value = product;
    String pTitle = product['title'];

    // If item is already in cart, show that quantity. Otherwise start at 0.
    if (cart.containsKey(pTitle)) {
      sheetTempQty.value = cart[pTitle]!;
    } else {
      sheetTempQty.value = 0; // Start at 0, user has to add
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

  void incrementSheetQty() {
    sheetTempQty.value++;
  }

  void decrementSheetQty() {
    if (sheetTempQty.value > 0) {
      sheetTempQty.value--;
    }
  }

  // Save changes when "Done" is clicked
  void confirmSheetSelection() {
    final product = selectedProductForSheet.value;
    if (product != null) {
      String pTitle = product['title'];
      if (sheetTempQty.value > 0) {
        cart[pTitle] = sheetTempQty.value;
        Get.snackbar("Success", "$pTitle updated in cart",
            snackPosition: SnackPosition.BOTTOM, margin: const EdgeInsets.all(16), backgroundColor: Colors.black87, colorText: Colors.white, duration: const Duration(seconds: 1));
      } else {
        cart.remove(pTitle);
      }
    }
    Get.back();
  }

  int get totalCartItems => cart.values.fold(0, (sum, item) => sum + item);
}