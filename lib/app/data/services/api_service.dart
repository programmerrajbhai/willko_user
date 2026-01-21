import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  // ⚠️ আপনার কম্পিউটারের IP বসান (CMD > ipconfig)
  // যদি এমুলেটর ব্যবহার করেন: 10.0.2.2
  // যদি রিয়েল ডিভাইস ব্যবহার করেন: 192.168.x.x (আপনার পিসির IP)
  static const String baseUrl = "http://192.168.0.105/WillkoServiceApi/api"; 
  static const String imageBaseUrl = "http://192.168.0.105/WillkoServiceApi/api/uploads/";

  // ================= LOGIN API =================
  static Future<Map<String, dynamic>> login(String phone, String password) async {
    try {
      final url = Uri.parse('$baseUrl/user/auth/login.php');
      final response = await http.post(
        url,
        body: jsonEncode({"phone": phone, "password": password}),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {"status": "error", "message": "Server Error: ${response.statusCode}"};
      }
    } catch (e) {
      return {"status": "error", "message": "Connection Failed: $e"};
    }
  }

  // ================= HOME DATA API =================
  static Future<Map<String, dynamic>> fetchHomeData() async {
    try {
      final url = Uri.parse('http://localhost/WillkoServiceApi/api/user/home/home_data.php');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {"status": "error", "message": "Failed to load home data"};
      }
    } catch (e) {
      return {"status": "error", "message": "Connection Error: $e"};
    }
  }
}