import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:willko_user/app/modules/home/service_details/service_details_view.dart';

class ServiceDetailsController extends GetxController {
  ServiceDetailsController({required this.service});

  final Map<String, dynamic> service;

  // ---------------- UI STATE ----------------
  final selectedItemIndex = 0.obs;

  /// Product details sheet state
  final selectedProductForSheet = Rxn<Map<String, dynamic>>();
  final sheetTempQty = 1.obs;

  /// Cart: key -> item map
  /// item: {key,title,priceInt,quantity,raw}
  final cartItems = <String, Map<String, dynamic>>{}.obs;

  // ---------------- SERVICE DATA ----------------
  String get title => (service["label"] ?? "").toString();
  double get rating => (service["rating"] ?? 0).toDouble();
  String get bookings => (service["bookings"] ?? "").toString();

  List<Map<String, dynamic>> get items =>
      (service["items"] as List? ?? []).cast<Map<String, dynamic>>();

  /// packagesByItem: {0:[...],1:[...],2:[...]}
  Map<int, List<Map<String, dynamic>>> get packagesByItem {
    final raw = service["packagesByItem"];
    if (raw is Map<int, List<Map<String, dynamic>>>) return raw;

    if (raw is Map) {
      final out = <int, List<Map<String, dynamic>>>{};
      raw.forEach((k, v) {
        final key = (k is int) ? k : int.tryParse(k.toString()) ?? 0;
        final list = (v as List? ?? []).cast<Map<String, dynamic>>();
        out[key] = list;
      });
      return out;
    }
    return {};
  }

  List<Map<String, dynamic>> get packages =>
      packagesByItem[selectedItemIndex.value] ?? [];

  // ---------------- ✅ SINGLE DYNAMIC BANNER DATA (UI SAME) ----------------
  /// You are using _DynamicHeroBanner in UI which reads this.
  Map<String, dynamic> get currentBannerData {
    // ✅ This getter must "touch" selectedItemIndex.value so Obx updates
    final idx = selectedItemIndex.value;

    // fallback info
    final categoryTitle = (items.isNotEmpty && idx < items.length)
        ? (items[idx]["title"] ?? "Service").toString()
        : "Service";

    // You can customize based on service slug/label/category index
    final slug = (service["slug"] ?? "").toString();

    // Default values (modern + user friendly)
    Color bg = const Color(0xFF6C45E5); // purple
    IconData icon = Icons.home_repair_service_rounded;
    String t = "We've got you covered!";
    List<String> bullets = const [
      "Verified professionals",
      "Transparent pricing",
      "Hassle-free booking",
    ];

    // Some smart mapping for visuals
    if (slug.contains("ac")) {
      bg = const Color(0xFF7A0B0B); // deep red like your screenshot vibe
      icon = Icons.ac_unit_rounded;
      t = "AC ${categoryTitle.replaceAll('\n', ' ')}";
      bullets = const [
        "30-day service guarantee",
        "Certified technicians",
        "Fast & clean service",
      ];
    } else if (slug.contains("plumbing")) {
      bg = const Color(0xFF0F6CBD);
      icon = Icons.plumbing_rounded;
      t = "Plumbing ${categoryTitle.replaceAll('\n', ' ')}";
      bullets = const [
        "Quick booking",
        "Tools included",
        "Neat finishing",
      ];
    } else if (slug.contains("electric")) {
      bg = const Color(0xFF1E1E1E);
      icon = Icons.electrical_services_rounded;
      t = "Electric ${categoryTitle.replaceAll('\n', ' ')}";
      bullets = const [
        "Safety first",
        "Certified electricians",
        "Warranty on service",
      ];
    } else {
      // generic but still nice
      t = "${title.replaceAll('\n', ' ')}";
      bullets = const [
        "Verified professionals",
        "Tools included",
        "Transparent pricing",
      ];
    }

    return {
      "title": t,
      "bullets": bullets,
      "icon": icon,
      "color": bg,
    };
  }

  // ---------------- ACTIONS ----------------
  void selectItem(int index) {
    if (index < 0 || index >= items.length) return;
    selectedItemIndex.value = index;
  }

  // ---------------- CART HELPERS ----------------
  String _productKey(Map<String, dynamic> p) {
    // prefer id, fallback to title
    final id = p["id"];
    if (id != null) return id.toString();
    return (p["title"] ?? "unknown").toString();
  }

  int cartQtyOf(Map<String, dynamic> product) {
    final key = _productKey(product);
    final item = cartItems[key];
    if (item == null) return 0;
    return (item["quantity"] ?? 0) as int;
  }

  int get totalCartItems {
    int total = 0;
    for (final e in cartItems.values) {
      total += (e["quantity"] ?? 0) as int;
    }
    return total;
  }

  int get totalCartPrice {
    int total = 0;
    for (final e in cartItems.values) {
      final price = (e["priceInt"] ?? 0) as int;
      final qty = (e["quantity"] ?? 0) as int;
      total += price * qty;
    }
    return total;
  }

  /// ✅ “Add” button tap (no sheet)
  void quickAdd(Map<String, dynamic> product) {
    final key = _productKey(product);
    final current = cartItems[key];
    final priceInt = (product["priceInt"] ?? 0) as int;

    if (current == null) {
      cartItems[key] = {
        "key": key,
        "title": (product["title"] ?? "").toString(),
        "priceInt": priceInt,
        "quantity": 1,
        "raw": product,
      };
    } else {
      cartItems[key] = {
        ...current,
        "quantity": ((current["quantity"] ?? 0) as int) + 1,
      };
    }
    cartItems.refresh();
    Get.snackbar("Added", "Added to cart");
  }

  void updateCartQty(String key, int newQty) {
    final item = cartItems[key];
    if (item == null) return;

    if (newQty <= 0) {
      cartItems.remove(key);
    } else {
      cartItems[key] = {...item, "quantity": newQty};
    }
    cartItems.refresh();
  }

  // ---------------- PRODUCT DETAILS SHEET ----------------
  void openProductDetailsSheet(BuildContext context, Map<String, dynamic> product) {
    selectedProductForSheet.value = product;

    // start qty from cart if exists, else 1
    final existingQty = cartQtyOf(product);
    sheetTempQty.value = existingQty > 0 ? existingQty : 1;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.88,
        minChildSize: 0.55,
        maxChildSize: 0.95,
        builder: (_, scrollController) {
          return ProductDetailSheet(scrollController: scrollController);
        },
      ),
    );
  }

  void incrementSheetQty() => sheetTempQty.value++;

  void decrementSheetQty() {
    if (sheetTempQty.value > 0) sheetTempQty.value--;
  }

  void confirmSheetSelection() {
    final prod = selectedProductForSheet.value;
    if (prod == null) return;

    final key = _productKey(prod);
    final qty = sheetTempQty.value;
    final priceInt = (prod["priceInt"] ?? 0) as int;

    if (qty <= 0) {
      cartItems.remove(key);
      cartItems.refresh();
      Get.back();
      Get.snackbar("Removed", "Removed from cart");
      return;
    }

    cartItems[key] = {
      "key": key,
      "title": (prod["title"] ?? "").toString(),
      "priceInt": priceInt,
      "quantity": qty,
      "raw": prod,
    };
    cartItems.refresh();

    Get.back();
    Get.snackbar("Updated", "Cart updated");
  }

  // ---------------- CART SHEET ----------------
  void openCartSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.85,
        minChildSize: 0.55,
        maxChildSize: 0.95,
        builder: (_, scrollController) {
          return CartBottomSheet(scrollController: scrollController);
        },
      ),
    );
  }

  void checkout() {
    Get.back(); // close sheet
    Get.snackbar("Checkout", "Proceeding to checkout...");
  }
}
