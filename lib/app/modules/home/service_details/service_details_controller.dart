import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../data/services/api_service.dart';
import '../../booking/checkout/checkout_view.dart';
import '../../booking/checkout/checkout_controller.dart';
import 'widgets/product_detail_sheet.dart';
import 'widgets/cart_sheets.dart';

class ServiceDetailsController extends GetxController {
  
  ServiceDetailsController({required Map<String, dynamic> service}) {
    serviceData.value = service;
  }

  var isLoading = true.obs;
  var serviceData = <String, dynamic>{}.obs; 
  final selectedItemIndex = 0.obs;
  final cartItems = <String, Map<String, dynamic>>{}.obs;
  final selectedProductForSheet = Rxn<Map<String, dynamic>>();
  final sheetTempQty = 1.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCategoryServices();
  }

  void fetchCategoryServices() async {
    try {
      isLoading.value = true;
      final catId = serviceData['id']; 
      if (catId == null) return;

      final url = Uri.parse("${ApiService.baseUrl}/user/home/category_services.php?category_id=$catId");
      print("🔵 Fetching Services: $url");

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        if (json['status'] == 'success') {
          serviceData.value = json['data'];
          serviceData.refresh();
        } else {
          print("🔴 API Error: ${json['message']}");
        }
      }
    } catch (e) {
      print("🔴 Connection Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // --- Getters ---
  String get title => (serviceData["label"] ?? serviceData["name"] ?? "Service").toString();
  String get bookings => (serviceData["bookings"] ?? "100+").toString();
  double get rating => double.tryParse((serviceData["rating"] ?? 0).toString()) ?? 4.8;

  List<Map<String, dynamic>> get items =>
      (serviceData["items"] as List? ?? []).cast<Map<String, dynamic>>();

  // ✅ Packages Parsing Logic (Map or List handled)
  List<Map<String, dynamic>> get packages {
    if (isLoading.value) return [];

    final rawData = serviceData["packagesByItem"];
    if (rawData == null) return [];

    final idxStr = selectedItemIndex.value.toString();
    final idxInt = selectedItemIndex.value;

    if (rawData is Map) {
      if (rawData.containsKey(idxInt)) return List<Map<String, dynamic>>.from(rawData[idxInt]);
      if (rawData.containsKey(idxStr)) return List<Map<String, dynamic>>.from(rawData[idxStr]);
    } 
    else if (rawData is List && idxInt < rawData.length) {
      return List<Map<String, dynamic>>.from(rawData[idxInt]);
    }
    
    return [];
  }

  // --- Banner Logic ---
  Map<String, dynamic> get currentBannerData {
    final idx = selectedItemIndex.value;
    final categoryTitle = (items.isNotEmpty && idx < items.length)
        ? (items[idx]["title"] ?? "Service").toString()
        : title;
    
    final slug = (serviceData["slug"] ?? "").toString().toLowerCase();
    
    // Default Colors
    Color bg = const Color(0xFF6C45E5);
    IconData icon = Icons.cleaning_services;
    
    if (slug.contains("ac")) { bg = const Color(0xFFB71C1C); icon = Icons.ac_unit; }
    else if (slug.contains("clean")) { bg = const Color(0xFF00897B); icon = Icons.cleaning_services; }
    else if (slug.contains("plumb")) { bg = const Color(0xFF0277BD); icon = Icons.plumbing; }

    return {
      "title": "$categoryTitle Experts",
      "bullets": ["Verified Pro", "Best Price", "Secure"],
      "icon": icon,
      "color": bg,
    };
  }

  // --- Actions ---
  void selectItem(int index) => selectedItemIndex.value = index;

  // --- Cart & Sheet Logic ---
  String _productKey(Map<String, dynamic> p) => (p["id"] ?? p["title"]).toString();

  int cartQtyOf(Map<String, dynamic> p) {
    final item = cartItems[_productKey(p)];
    return item == null ? 0 : (item["quantity"] as int);
  }

  int get totalCartPrice {
    int total = 0;
    for (final e in cartItems.values) {
      total += ((e["priceInt"] ?? 0) as int) * ((e["quantity"] ?? 0) as int);
    }
    return total;
  }

  void quickAdd(Map<String, dynamic> p) {
    final key = _productKey(p);
    final current = cartItems[key];
    final price = (p["priceInt"] ?? 0) as int;

    if (current == null) {
      cartItems[key] = {"key": key, "title": p["title"], "priceInt": price, "quantity": 1, "raw": p};
    } else {
      cartItems[key] = {...current, "quantity": (current["quantity"] as int) + 1};
    }
    cartItems.refresh();
    Get.snackbar("Added", "Added to cart", backgroundColor: Colors.green, colorText: Colors.white, snackPosition: SnackPosition.BOTTOM, duration: const Duration(seconds: 1));
  }

  void updateCartQty(String key, int newQty) {
    if (newQty <= 0) { cartItems.remove(key); } 
    else { final item = cartItems[key]; if (item != null) cartItems[key] = {...item, "quantity": newQty}; }
    cartItems.refresh();
  }

  void openProductDetailsSheet(BuildContext context, Map<String, dynamic> p) {
    selectedProductForSheet.value = p;
    final qty = cartQtyOf(p);
    sheetTempQty.value = qty > 0 ? qty : 1;
    showModalBottomSheet(context: context, isScrollControlled: true, backgroundColor: Colors.transparent, builder: (_) => DraggableScrollableSheet(initialChildSize: 0.65, builder: (_, c) => ProductDetailSheet(scrollController: c)));
  }

  void incrementSheetQty() => sheetTempQty.value++;
  void decrementSheetQty() { if (sheetTempQty.value > 0) sheetTempQty.value--; }

  void confirmSheetSelection() {
    final p = selectedProductForSheet.value;
    if (p != null) {
      final key = _productKey(p);
      final qty = sheetTempQty.value;
      if (qty <= 0) cartItems.remove(key);
      else cartItems[key] = {"key": key, "title": p["title"], "priceInt": p["priceInt"], "quantity": qty, "raw": p};
      cartItems.refresh();
    }
    Get.back();
  }

  void openCartSheet(BuildContext context) {
    showModalBottomSheet(context: context, isScrollControlled: true, backgroundColor: Colors.transparent, builder: (_) => DraggableScrollableSheet(initialChildSize: 0.85, builder: (_, c) => CartBottomSheet(scrollController: c)));
  }

  void checkout() {
    Get.back();
    if (cartItems.isEmpty) return;
    Get.to(() => const CheckoutView(), binding: BindingsBuilder(() => Get.put(CheckoutController())));
  }
}