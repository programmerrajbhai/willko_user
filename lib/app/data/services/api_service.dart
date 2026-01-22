import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  // ================= CONFIGURATION =================
  // ⚠️ আপনার পিসির বর্তমান IPv4 Address এখানে বসান
  static const String _ip = "192.168.1.105"; 
  static const String _root = "http://$_ip/WillkoServiceApi/api";

  // ================= ENDPOINTS =================
  static const String baseUrl = _root;
  static const String _loginUrl = "$_root/user/auth/login.php";
  static const String _homeDataUrl = "$_root/user/home/home_data.php";
  static const String _placeOrderUrl = "$_root/user/order/place_order.php";

static const String _myBookingsUrl = "$_root/user/order/my_bookings.php"; // ✅ নতুন এন্ডপয়েন্ট

static const String _getProfileUrl = "$_root/user/profile/get_profile.php"; // ✅ নতুন এন্ডপয়েন্ট


static const String _getOrderDetailsUrl = "$_root/user/order/order_details.php"; // ✅ নতুন এন্ডপয়েন্ট


static const String _cancelOrderUrl = "$_root/user/order/cancel_order.php";

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
  static Future<Map<String, dynamic>> login(String phone, String password) async {
    try {
      final response = await http.post(
        Uri.parse(_loginUrl),
        body: jsonEncode({"login_id": phone, "phone": phone, "password": password}),
        headers: {"Content-Type": "application/json"},
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
}