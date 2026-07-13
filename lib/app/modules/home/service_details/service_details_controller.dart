// ফাইল: lib/app/modules/home/service_details/service_details_controller.dart

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../data/services/api_service.dart';
import '../../auth/login/login_view.dart';
import '../../booking/checkout/checkout_controller.dart';
import '../../booking/checkout/checkout_view.dart';
import '../../../../utils/pixel_tracker.dart';
import 'widgets/cart_sheets.dart';
import 'widgets/product_detail_sheet.dart';

class ServiceDetailsController extends GetxController {
  ServiceDetailsController({required Map<String, dynamic> service}) {
    serviceData.value = service;
  }

  final isLoading = true.obs;
  final isLoggedIn = false.obs;
  final serviceData = <String, dynamic>{}.obs;

  final selectedItemIndex = (-1).obs;
  final cartItems = <String, Map<String, dynamic>>{}.obs;
  final selectedProductForSheet = Rxn<Map<String, dynamic>>();
  final sheetTempQty = 1.obs;

  @override
  void onInit() {
    super.onInit();

    _checkLoginStatus();
    fetchCategoryServices();

    final String sId = serviceData['id']?.toString() ?? "0";
    final String sName =
    (serviceData["label"] ?? serviceData["name"] ?? "Service").toString();
    final double sPrice =
        double.tryParse((serviceData["priceInt"] ?? 0).toString()) ?? 0.0;

    PixelTracker.trackViewItem(
      serviceId: sId,
      serviceName: sName,
      price: sPrice,
    );
  }

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    isLoggedIn.value = token != null && token.trim().isNotEmpty;
  }

  Future<void> fetchCategoryServices() async {
    try {
      isLoading.value = true;

      final catId = serviceData['id'];

      if (catId == null) {
        debugPrint("Category ID missing.");
        return;
      }

      final url = Uri.parse(
        "${ApiService.baseUrl}/user/home/category_services.php?category_id=$catId",
      );

      final response = await http.get(url).timeout(
        const Duration(seconds: 15),
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);

        if (decoded['status'] == 'success' && decoded['data'] is Map) {
          serviceData.value = Map<String, dynamic>.from(decoded['data']);
          serviceData.refresh();
        } else {
          debugPrint("Invalid category response: ${response.body}");
        }
      } else {
        debugPrint("Category API Error: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("🔴 Category Connection Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  String get title {
    return (serviceData["label"] ?? serviceData["name"] ?? "Service")
        .toString();
  }

  String get bookings {
    return (serviceData["bookings"] ?? "100+").toString();
  }

  double get rating {
    return double.tryParse((serviceData["rating"] ?? 0).toString()) ?? 4.8;
  }

  List<Map<String, dynamic>> get items {
    final raw = serviceData["items"];

    if (raw is List) {
      return raw
          .whereType<Map>()
          .map((e) => Map<String, dynamic>.from(e))
          .toList();
    }

    return <Map<String, dynamic>>[];
  }

  List<Map<String, dynamic>> getPackagesForIndex(int index) {
    final rawData = serviceData["packagesByItem"];

    if (rawData == null) return [];

    final idxStr = index.toString();

    if (rawData is Map) {
      final value = rawData[index] ?? rawData[idxStr];

      if (value is List) {
        return value
            .whereType<Map>()
            .map((e) => Map<String, dynamic>.from(e))
            .toList();
      }
    }

    if (rawData is List && index >= 0 && index < rawData.length) {
      final value = rawData[index];

      if (value is List) {
        return value
            .whereType<Map>()
            .map((e) => Map<String, dynamic>.from(e))
            .toList();
      }
    }

    return [];
  }

  List<Map<String, dynamic>> get packages {
    if (selectedItemIndex.value < 0) return [];
    return getPackagesForIndex(selectedItemIndex.value);
  }

  Map<String, dynamic> get currentBannerData {
    final idx = selectedItemIndex.value;

    final categoryTitle = items.isNotEmpty && idx >= 0 && idx < items.length
        ? (items[idx]["title"] ?? "Service").toString()
        : title;

    final slug = (serviceData["slug"] ?? "").toString().toLowerCase();

    Color bg = const Color(0xFF6C45E5);
    IconData icon = Icons.cleaning_services;

    if (slug.contains("ac")) {
      bg = const Color(0xFFB71C1C);
      icon = Icons.ac_unit;
    } else if (slug.contains("clean")) {
      bg = const Color(0xFF00897B);
      icon = Icons.cleaning_services;
    } else if (slug.contains("plumb")) {
      bg = const Color(0xFF0277BD);
      icon = Icons.plumbing;
    }

    return {
      "title": "$categoryTitle Experts",
      "bullets": ["Verified Pro", "Best Price", "Secure"],
      "icon": icon,
      "color": bg,
    };
  }

  void selectItem(int index) {
    selectedItemIndex.value = index;
  }

  String _productKey(Map<String, dynamic> p) {
    return (p["id"] ?? p["key"] ?? p["title"] ?? p["name"] ?? "")
        .toString();
  }

  int _safeInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();

    final text = value?.toString().trim() ?? "0";
    return int.tryParse(text) ?? 0;
  }

  double _safeDouble(dynamic value) {
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is num) return value.toDouble();

    final text = value?.toString().trim() ?? "0";
    return double.tryParse(text) ?? 0.0;
  }

  int cartQtyOf(Map<String, dynamic> p) {
    final key = _productKey(p);

    if (key.isEmpty) return 0;

    final item = cartItems[key];
    return item == null ? 0 : _safeInt(item["quantity"]);
  }

  int get totalCartPrice {
    int total = 0;

    for (final item in cartItems.values) {
      final price = _safeInt(item["priceInt"] ?? item["price"]);
      final quantity = _safeInt(item["quantity"]);
      total += price * quantity;
    }

    return total;
  }

  void quickAdd(Map<String, dynamic> p) {
    final key = _productKey(p);

    if (key.isEmpty) {
      Get.snackbar(
        "Error",
        "Invalid service item.",
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final current = cartItems[key];
    final price = _safeInt(p["priceInt"] ?? p["price"]);

    if (current == null) {
      cartItems[key] = {
        "key": key,
        "title": p["title"] ?? p["name"] ?? "Service",
        "priceInt": price,
        "quantity": 1,
        "raw": p,
      };
    } else {
      cartItems[key] = {
        ...current,
        "quantity": _safeInt(current["quantity"]) + 1,
      };
    }

    cartItems.refresh();

    PixelTracker.trackAddToCart(
      serviceId: (p["id"] ?? p["key"] ?? key).toString(),
      serviceName: (p["title"] ?? p["name"] ?? "Service").toString(),
      price: _safeDouble(p["priceInt"] ?? p["price"]),
      quantity: 1,
    );

    Get.snackbar(
      "Added",
      "Added to cart",
      backgroundColor: Colors.green,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 1),
    );
  }

  void updateCartQty(String key, int newQty) {
    if (newQty <= 0) {
      cartItems.remove(key);
    } else {
      final item = cartItems[key];

      if (item != null) {
        cartItems[key] = {
          ...item,
          "quantity": newQty,
        };
      }
    }

    cartItems.refresh();
  }

  void openProductDetailsSheet(BuildContext context, Map<String, dynamic> p) {
    selectedProductForSheet.value = p;

    final qty = cartQtyOf(p);
    sheetTempQty.value = qty > 0 ? qty : 1;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return DraggableScrollableSheet(
          initialChildSize: 0.65,
          minChildSize: 0.35,
          maxChildSize: 0.95,
          builder: (_, controller) {
            return ProductDetailSheet(
              scrollController: controller,
            );
          },
        );
      },
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

  void confirmSheetSelection() {
    final p = selectedProductForSheet.value;

    if (p != null) {
      final key = _productKey(p);

      if (key.isEmpty) {
        Get.snackbar(
          "Error",
          "Invalid service item.",
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      final qty = sheetTempQty.value;
      final price = _safeInt(p["priceInt"] ?? p["price"]);

      if (qty <= 0) {
        cartItems.remove(key);
      } else {
        cartItems[key] = {
          "key": key,
          "title": p["title"] ?? p["name"] ?? "Service",
          "priceInt": price,
          "quantity": qty,
          "raw": p,
        };

        PixelTracker.trackAddToCart(
          serviceId: (p["id"] ?? p["key"] ?? key).toString(),
          serviceName: (p["title"] ?? p["name"] ?? "Service").toString(),
          price: price.toDouble(),
          quantity: qty,
        );
      }

      cartItems.refresh();
    }

    if (Get.isBottomSheetOpen == true) {
      Get.back();
    }
  }

  void openCartSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return DraggableScrollableSheet(
          initialChildSize: 0.85,
          minChildSize: 0.45,
          maxChildSize: 0.95,
          builder: (_, controller) {
            return CartBottomSheet(
              scrollController: controller,
            );
          },
        );
      },
    );
  }

  Future<void> checkout() async {
    await _checkLoginStatus();

    // ✅ শুধু bottom sheet open থাকলে close করবে
    if (Get.isBottomSheetOpen == true) {
      Get.back();
      await Future.delayed(const Duration(milliseconds: 250));
    }

    if (cartItems.isEmpty) {
      Get.snackbar(
        "Empty Cart",
        "Please select a service first.",
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    // ✅ Checkout cart snapshot prepare
    final List<Map<String, dynamic>> cartList =
    cartItems.values.map((item) => Map<String, dynamic>.from(item)).toList();

    if (!isLoggedIn.value) {
      // ✅ এবার আর result wait করবো না
      // LoginController নিজেই success হলে CheckoutView open করবে
      Get.to(
            () => const LoginView(),
        arguments: {
          'fromCheckout': true,
          'cart': cartList,
        },
        transition: Transition.cupertino,
      );
      return;
    }

    _navigateToCheckout();
  }




  void _navigateToCheckout() {
    if (cartItems.isEmpty) {
      Get.snackbar(
        "Empty Cart",
        "Please select a service first.",
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final List<Map<String, dynamic>> cartList =
    cartItems.values.map((item) => Map<String, dynamic>.from(item)).toList();

    final List<Map<String, dynamic>> itemsForPixel = cartList.map((item) {
      return {
        "item_id": (item['key'] ?? item['id'] ?? "").toString(),
        "item_name": (item['title'] ?? item['name'] ?? "").toString(),
        "price": _safeDouble(item['priceInt'] ?? item['price']),
        "quantity": _safeInt(item['quantity'] ?? 1),
      };
    }).toList();

    PixelTracker.trackBeginCheckout(
      totalAmount: totalCartPrice.toDouble(),
      items: itemsForPixel,
    );

    Get.to(
          () => const CheckoutView(),
      binding: BindingsBuilder(() {
        Get.put(CheckoutController());
      }),
      arguments: {
        'cart': cartList,
      },
      transition: Transition.cupertino,
    );
  }
}