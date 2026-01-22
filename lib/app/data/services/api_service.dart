import 'dart:convert';
import 'dart:io'; // SocketException এর জন্য
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  // ================= CONFIGURATION =================
  // ⚠️ আপনার পিসির বর্তমান IPv4 Address এখানে বসান (CMD > ipconfig)
  // মোবাইল এবং পিসি একই ওয়াইফাইতে থাকতে হবে।
  static const String _ip = "192.168.1.105"; 
  static const String _root = "http://$_ip/WillkoServiceApi/api";

  // ================= ENDPOINTS =================
  static const String baseUrl = _root;
  
  // Private Endpoints
  static const String _loginUrl = "$_root/user/auth/login.php";
  static const String _homeDataUrl = "$_root/user/home/home_data.php";
  static const String _placeOrderUrl = "$_root/user/order/place_order.php";
  static const String _categoryServicesUrl = "$_root/user/home/category_services.php";

  // ================= 1. HOME DATA API =================
  static Future<Map<String, dynamic>> fetchHomeData() async {
    try {
      final response = await http.get(Uri.parse(_homeDataUrl)).timeout(
        const Duration(seconds: 10),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {"status": "error", "message": "Failed to load home data"};
      }
    } catch (e) {
      print("API Error (Home): $e");
      return {"status": "error", "message": "Connection Error. Check IP."};
    }
  }

  // ================= 2. LOGIN API (Single & Correct) =================
  static Future<Map<String, dynamic>> login(String phone, String password) async {
    try {
      print("🔵 Logging in to: $_loginUrl");
      print("📦 Payload: Phone: $phone, Pass: $password");

      final response = await http.post(
        Uri.parse(_loginUrl),
        body: jsonEncode({
          "login_id": phone, // PHP তে আমরা login_id বা phone দুটোই রিসিভ করছি
          "phone": phone,    // ব্যাকআপ হিসেবে এটাও পাঠালাম
          "password": password
        }),
        headers: {"Content-Type": "application/json"},
      ).timeout(const Duration(seconds: 10));

      print("🟢 Response: ${response.body}");

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {"status": "error", "message": "Server Error: ${response.statusCode}"};
      }
    } catch (e) {
      print("🔴 API Error (Login): $e");
      return {"status": "error", "message": "Connection Error: $e"};
    }
  }

  // ================= 3. PLACE ORDER API =================
  static Future<Map<String, dynamic>> placeOrder(Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token') ?? ""; 

    if (token.isEmpty) {
      return {"status": "unauthorized", "message": "Please login first"};
    }

    try {
      final response = await http.post(
        Uri.parse(_placeOrderUrl),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode(data),
      ).timeout(const Duration(seconds: 15));
      
      print("Order API Response: ${response.body}");

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