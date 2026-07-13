// ফাইল: lib/app/modules/auth/signup/signup_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:willko_user/app/data/services/api_service.dart';
import 'package:willko_user/app/modules/auth/login/login_view.dart';
import 'package:willko_user/app/modules/booking/checkout/checkout_controller.dart';
import 'package:willko_user/app/modules/booking/checkout/checkout_view.dart';
import 'package:willko_user/app/modules/home/home_controller.dart';
import 'package:willko_user/app/modules/home/home_view.dart';

class SignUpController extends GetxController {
  final isLoading = false.obs;
  final isPasswordHidden = true.obs;

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

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

  Future<void> register() async {
    final String name = nameController.text.trim();
    final String email = emailController.text.trim();
    final String phone = phoneController.text.trim();
    final String pass = passwordController.text.trim();
    final String confirmPass = confirmPasswordController.text.trim();

    if (name.isEmpty ||
        email.isEmpty ||
        phone.isEmpty ||
        pass.isEmpty ||
        confirmPass.isEmpty) {
      Get.snackbar(
        "Error",
        "All fields are required!",
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (!GetUtils.isEmail(email)) {
      Get.snackbar(
        "Error",
        "Enter a valid email address!",
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (pass != confirmPass) {
      Get.snackbar(
        "Error",
        "Passwords do not match!",
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (pass.length < 6) {
      Get.snackbar(
        "Error",
        "Password must be at least 6 characters long!",
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (isLoading.value) return;

    isLoading.value = true;

    try {
      final registerResponse = await ApiService.registerUser(
        name,
        email,
        phone,
        pass,
      );

      debugPrint("REGISTER RESPONSE: $registerResponse");

      if (registerResponse['status'] == 'success') {
        Map<String, dynamic> loginResponse = await ApiService.login(phone, pass);

        if (loginResponse['status'] != 'success') {
          loginResponse = await ApiService.login(email, pass);
        }

        debugPrint("AUTO LOGIN RESPONSE: $loginResponse");

        if (loginResponse['status'] == 'success') {
          final data = loginResponse['data'];

          if (data == null || data is! Map) {
            Get.snackbar(
              "Account Created",
              "Please login manually.",
              backgroundColor: Colors.green,
              colorText: Colors.white,
              snackPosition: SnackPosition.BOTTOM,
            );

            goToLogin();
            return;
          }

          final String token = (data['token'] ?? '').toString();
          final String userId = (data['user_id'] ?? '').toString();
          final String userName = (data['name'] ?? name).toString();
          final String userPhone = (data['phone'] ?? phone).toString();
          final String userEmail = (data['email'] ?? email).toString();

          if (token.isEmpty || token == 'null') {
            Get.snackbar(
              "Account Created",
              "Please login manually.",
              backgroundColor: Colors.green,
              colorText: Colors.white,
              snackPosition: SnackPosition.BOTTOM,
            );

            goToLogin();
            return;
          }

          final prefs = await SharedPreferences.getInstance();

          await prefs.setString('auth_token', token);
          await prefs.setString('user_id', userId);
          await prefs.setString('user_name', userName);
          await prefs.setString('user_phone', userPhone);

          if (userEmail.isNotEmpty && userEmail != 'null') {
            await prefs.setString('user_email', userEmail);
          }

          if (Get.isRegistered<HomeController>()) {
            await Get.find<HomeController>().checkLoginStatus();
          }

          Get.snackbar(
            "Welcome!",
            "Account Created & Logged In Successfully.",
            backgroundColor: Colors.green,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
          );

          await Future.delayed(const Duration(milliseconds: 250));

          // ✅ FINAL FIX:
          // SignUp success হলে result return না করে direct CheckoutView open
          if (_fromCheckout) {
            _goToCheckoutAfterAuth();
          } else {
            Get.offAll(() => const HomeView());
          }
        } else {
          Get.snackbar(
            "Account Created",
            "Please login manually.",
            backgroundColor: Colors.green,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
          );

          goToLogin();
        }
      } else {
        Get.snackbar(
          "Registration Failed",
          registerResponse['message']?.toString() ?? "Try again later.",
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      debugPrint("REGISTER ERROR: $e");

      Get.snackbar(
        "Error",
        "Something went wrong! Check connection.",
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

    // ✅ SignUp screen replace হবে CheckoutView দিয়ে
    // Stack থাকবে: ServiceDetails -> CheckoutView
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

  void goToLogin() {
    // ✅ SignUp screen replace করে Login screen খুলবে
    // Argument same থাকবে, তাই checkout cart হারাবে না
    Get.off(
          () => const LoginView(),
      arguments: _args,
      transition: Transition.cupertino,
    );
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}