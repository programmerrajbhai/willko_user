import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {





  // ================= CONFIGURATION =================
  // ⚠️ আপনার পিসির বর্তমান IPv4 Address এখানে বসান
  static const String _ip = "willkoservices.com";
  static const String _root = "https://$_ip/WillkoServiceApi/api";

  // ================= ENDPOINTS =================
  static const String baseUrl = _root;
  static const String _loginUrl = "$_root/user/auth/login.php";
  static const String _homeDataUrl = "$_root/user/home/home_data.php";
  static const String _placeOrderUrl = "$_root/user/order/place_order.php";

static const String _myBookingsUrl = "$_root/user/order/my_bookings.php"; // ✅ নতুন এন্ডপয়েন্ট

static const String _getProfileUrl = "$_root/user/profile/get_profile.php"; // ✅ নতুন এন্ডপয়েন্ট


static const String _getOrderDetailsUrl = "$_root/user/order/order_details.php"; // ✅ নতুন এন্ডপয়েন্ট


static const String _cancelOrderUrl = "$_root/user/order/cancel_order.php";




// ================= ENDPOINTS ================= এ এটি যুক্ত করুন
  static const String _registerUrl = "$_root/user/auth/register.php";

  // ================= REGISTER API =================
// ================= REGISTER API =================
  // 🔥 FIXED: Added 'String email' in the parameters
  static Future<Map<String, dynamic>> registerUser(String name, String email, String phone, String password) async {
    try {
      final response = await http.post(
        Uri.parse(_registerUrl),
        body: jsonEncode({
          "name": name,
          "email": email, // 🔥 Added email to the API request body
          "phone": phone,
          "password": password
        }),
        headers: {"Content-Type": "application/json"},
      ).timeout(const Duration(seconds: 15));

      // 409 স্ট্যাটাস কোড (Duplicate Phone/Email) এর জন্যও রেসপন্স ডিকোড করতে হবে
      if (response.statusCode == 200 || response.statusCode == 409) {
        return jsonDecode(response.body);
      } else {
        return {"status": "error", "message": "Server Error: ${response.statusCode}"};
      }
    } catch (e) {
      return {"status": "error", "message": "Connection Error: $e"};
    }
  }
  // ================= 7. CANCEL ORDER =================
  static Future<Map<String, dynamic>> cancelOrder(String orderId, String reason) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token') ?? "";

    try {
      final response = await http.post(
        Uri.parse(_cancelOrderUrl),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          "order_id": orderId,
          "reason": reason
        })
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {"status": "error", "message": "Server Error"};
      }
    } catch (e) {
      return {"status": "error", "message": "Connection Error"};
    }
  }

  // ================= 6. GET ORDER DETAILS =================
  static Future<Map<String, dynamic>> fetchOrderDetails(String orderId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token') ?? "";

    if (token.isEmpty) return {"status": "unauthorized"};

    try {
      final response = await http.get(
        // URL এ Query Parameter পাঠানো হচ্ছে
        Uri.parse("$_getOrderDetailsUrl?order_id=$orderId"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {"status": "error", "message": "Server Error: ${response.statusCode}"};
      }
    } catch (e) {
      return {"status": "error", "message": "Connection Error: $e"};
    }
  }


  // ================= 5. GET USER PROFILE =================
  static Future<Map<String, dynamic>> fetchUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token') ?? "";

    if (token.isEmpty) return {"status": "unauthorized"};

    try {
      final response = await http.get(
        Uri.parse(_getProfileUrl),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {"status": "error", "message": "Server Error: ${response.statusCode}"};
      }
    } catch (e) {
      return {"status": "error", "message": "Connection Error: $e"};
    }
  }



// ================= 4. FETCH MY BOOKINGS =================
  static Future<Map<String, dynamic>> fetchMyBookings() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token') ?? "";

    if (token.isEmpty) return {"status": "unauthorized"};

    try {
      final response = await http.get(
        Uri.parse(_myBookingsUrl),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {"status": "error", "message": "Server Error: ${response.statusCode}"};
      }
    } catch (e) {
      return {"status": "error", "message": "Connection Error"};
    }
  }


  // ================= 1. HOME DATA API =================
  static Future<Map<String, dynamic>> fetchHomeData() async {
    try {
      final response = await http.get(Uri.parse(_homeDataUrl)).timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {"status": "error", "message": "Failed to load home data"};
      }
    } catch (e) {
      return {"status": "error", "message": "Connection Error: $e"};
    }
  }

  // ================= 2. LOGIN API =================
// ================= LOGIN API =================
  // 🔥 FIXED: Changed 'phone' to 'loginId' to represent both Email and Phone
  static Future<Map<String, dynamic>> login(String loginId, String password) async {
    try {
      final response = await http.post(
        Uri.parse(_loginUrl),
        body: jsonEncode({
          "login_id": loginId, // PHP ব্যাকএন্ড এই 'login_id' রিসিভ করবে
          "password": password
        }),
        headers: {"Content-Type": "application/json"},
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 401 || response.statusCode == 404 || response.statusCode == 403) {
        // PHP থেকে আসা এরর মেসেজগুলো হ্যান্ডেল করার জন্য
        return jsonDecode(response.body);
      } else {
        return {"status": "error", "message": "Server Error: ${response.statusCode}"};
      }
    } catch (e) {
      return {"status": "error", "message": "Connection Error: $e"};
    }
  }
  // ================= 3. PLACE ORDER API (Updated) =================
  static Future<Map<String, dynamic>> placeOrder(Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token') ?? ""; 

    if (token.isEmpty) {
      return {"status": "unauthorized", "message": "Please login first"};
    }

    try {
      print("📤 Placing Order Payload: ${jsonEncode(data)}");

      final response = await http.post(
        Uri.parse(_placeOrderUrl),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode(data),
      ).timeout(const Duration(seconds: 20));
      
      print("📥 Order API Response: ${response.body}");

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 401) {
        return {"status": "unauthorized", "message": "Session expired."};
      } else {
        return {"status": "error", "message": "Server Error: ${response.statusCode}"};
      }
    } catch (e) {
      print("API Error (Order): $e");
      return {"status": "error", "message": "Connection error: $e"};
    }
  }







  ////




// ================= ENDPOINTS (আপডেট করা URL) =================
  // 🔥 এখানে api/user/auth/ পাথটি যুক্ত করা হয়েছে
  static const String _sendOtpUrl = "https://willkoservices.com/WillkoServiceApi/api/user/auth/send_email_otp.php";
  static const String _verifyOtpUrl = "https://willkoservices.com/WillkoServiceApi/api/user/auth/verify_email_otp.php";
  static const String _resetPassUrl = "https://willkoservices.com/WillkoServiceApi/api/user/auth/update_password_email.php";
  // ================= FORGOT PASSWORD API METHODS (এগুলো ফাইলের নিচে অ্যাড করবেন) =================
// ================= FORGOT PASSWORD API METHODS =================
  static Future<Map<String, dynamic>> sendEmailOtp(String email) async {
    try {
      final response = await http.post(
        Uri.parse(_sendOtpUrl), // নিশ্চিত করুন _sendOtpUrl সঠিক
        body: jsonEncode({"email": email}),
        headers: {"Content-Type": "application/json"},
      ).timeout(const Duration(seconds: 15));

      // 🔥 FIXED: যদি সার্ভার থেকে JSON এর বদলে HTML (<!DOCTYPE html>) আসে
      if (response.body.trim().startsWith('<')) {
        debugPrint("Server Error Body: ${response.body}"); // কনসোলে দেখার জন্য
        return {"status": "error", "message": "Server File Not Found (404). Check API URL path!"};
      }

      return jsonDecode(response.body);
    } catch (e) {
      return {"status": "error", "message": "Connection Error: $e"};
    }
  }

  static Future<Map<String, dynamic>> verifyEmailOtp(String email, String otp) async {
    try {
      final response = await http.post(
        Uri.parse(_verifyOtpUrl),
        body: jsonEncode({"email": email, "otp": otp}),
        headers: {"Content-Type": "application/json"},
      ).timeout(const Duration(seconds: 15));

      if (response.body.trim().startsWith('<')) {
        return {"status": "error", "message": "Server File Not Found (404). Check API URL path!"};
      }

      return jsonDecode(response.body);
    } catch (e) {
      return {"status": "error", "message": "Connection Error: $e"};
    }
  }

  static Future<Map<String, dynamic>> resetPasswordEmail(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse(_resetPassUrl),
        body: jsonEncode({"email": email, "password": password}),
        headers: {"Content-Type": "application/json"},
      ).timeout(const Duration(seconds: 15));

      if (response.body.trim().startsWith('<')) {
        return {"status": "error", "message": "Server File Not Found (404). Check API URL path!"};
      }

      return jsonDecode(response.body);
    } catch (e) {
      return {"status": "error", "message": "Connection Error: $e"};
    }
  }





}