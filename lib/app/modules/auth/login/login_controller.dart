// ফাইল: lib/app/modules/auth/login/login_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:willko_user/app/data/services/api_service.dart';
import 'package:willko_user/app/modules/booking/checkout/checkout_controller.dart';
import 'package:willko_user/app/modules/booking/checkout/checkout_view.dart';
import 'package:willko_user/app/modules/home/home_controller.dart';

import '../../home/home_view.dart';
import '../forgot_password/forgot_password_view.dart';
import '../signup/signup_view.dart';

class LoginController extends GetxController {
  final isLoading = false.obs;
  final isPasswordHidden = true.obs;

  final loginIdController = TextEditingController();
  final passwordController = TextEditingController();

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  Map<String, dynamic> get _args {
    final raw = Get.arguments;

    if (raw is Map<String, dynamic>) {
      return raw;
    }

    if (raw is Map) {
      return Map<String, dynamic>.from(raw);
    }

    return {};
  }

  bool get _fromCheckout {
    return _args['fromCheckout'] == true;
  }

  List<Map<String, dynamic>> get _checkoutCart {
    final rawCart = _args['cart'];

    if (rawCart is List) {
      return rawCart
          .whereType<Map>()
          .map((e) => Map<String, dynamic>.from(e))
          .toList();
    }

    return <Map<String, dynamic>>[];
  }

  Future<void> login() async {
    final String loginId = loginIdController.text.trim();
    final String password = passwordController.text.trim();

    if (loginId.isEmpty || password.isEmpty) {
      Get.snackbar(
        "Error",
        "Enter your Email/Phone & Password",
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (isLoading.value) return;

    isLoading.value = true;

    try {
      final response = await ApiService.login(loginId, password);

      debugPrint("LOGIN RESPONSE: $response");

      if (response['status'] == 'success') {
        final data = response['data'];

        if (data == null || data is! Map) {
          Get.snackbar(
            "Login Failed",
            "Invalid server response.",
            backgroundColor: Colors.redAccent,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
          );
          return;
        }

        final String token = (data['token'] ?? '').toString();
        final String userId = (data['user_id'] ?? '').toString();
        final String name = (data['name'] ?? 'User').toString();
        final String phone = (data['phone'] ?? '').toString();
        final String email = (data['email'] ?? '').toString();

        if (token.isEmpty || token == 'null') {
          Get.snackbar(
            "Login Failed",
            "Token missing from server response.",
            backgroundColor: Colors.redAccent,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
          );
          return;
        }

        final prefs = await SharedPreferences.getInstance();

        await prefs.setString('auth_token', token);
        await prefs.setString('user_id', userId);
        await prefs.setString('user_name', name);
        await prefs.setString('user_phone', phone);

        if (email.isNotEmpty && email != 'null') {
          await prefs.setString('user_email', email);
        }

        if (Get.isRegistered<HomeController>()) {
          await Get.find<HomeController>().checkLoginStatus();
        }

        Get.snackbar(
          "Success",
          "Welcome Back!",
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );

        await Future.delayed(const Duration(milliseconds: 250));

        // ✅ FINAL FIX:
        // Checkout থেকে Login এ এলে Get.back(result:true) না করে
        // Login screen replace করে সরাসরি CheckoutView open করবো।
        if (_fromCheckout) {
          _goToCheckoutAfterAuth();
        } else {
          Get.offAll(() => const HomeView());
        }
      } else {
        Get.snackbar(
          "Login Failed",
          response['message']?.toString() ?? "Check your credentials.",
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      debugPrint("LOGIN ERROR: $e");

      Get.snackbar(
        "Error",
        "Something went wrong. Please try again.",
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void _goToCheckoutAfterAuth() {
    final cart = _checkoutCart;

    if (cart.isEmpty) {
      Get.snackbar(
        "Cart Error",
        "Cart data missing. Please select service again.",
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );

      Get.offAll(() => const HomeView());
      return;
    }

    // ✅ Login screen replace হবে CheckoutView দিয়ে
    // Stack থাকবে: ServiceDetails -> CheckoutView
    // Checkout থেকে back দিলে ServiceDetails এ আসবে
    Get.off(
          () => const CheckoutView(),
      binding: BindingsBuilder(() {
        if (Get.isRegistered<CheckoutController>()) {
          Get.delete<CheckoutController>();
        }
        Get.put(CheckoutController());
      }),
      arguments: {
        'cart': cart,
      },
      transition: Transition.cupertino,
    );
  }

  void goToSignUp() {
    // ✅ Important:
    // Login screen replace করে SignUp খুলবো।
    // Stack থাকবে: ServiceDetails -> SignUp
    // SignUp success হলে SignUp replace হয়ে CheckoutView open হবে।
    Get.off(
          () => const SignUpView(),
      arguments: _args,
      transition: Transition.cupertino,
    );
  }

  void goToForgotPassword() {
    Get.to(
          () => const ForgotPasswordView(),
      transition: Transition.cupertino,
    );
  }
}