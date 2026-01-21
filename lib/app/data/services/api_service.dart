import 'dart:convert';
import 'dart:io'; // SocketException এর জন্য
import 'package:http/http.dart' as http;

class ApiService {
  // ================= CONFIGURATION =================
  // ⚠️ আপনার পিসির বর্তমান IP বসান (CMD > ipconfig)
  static const String _ip = "192.168.1.105"; 
  static const String _root = "http://$_ip/WillkoServiceApi/api";

  // ================= ENDPOINTS =================
  // বেস URL এবং ইমেজ URL (অন্য ফাইল থেকে এক্সেস করার জন্য public রাখা হলো)
  static const String baseUrl = _root;
  static const String imageBaseUrl = "$_root/uploads/";
  
  // Private Endpoints
  static const String _loginUrl = "$_root/user/auth/login.php";
  static const String _homeDataUrl = "http://localhost/WillkoServiceApi/api/user/home/home_data.php";

  // ================= LOGIN API =================
  static Future<Map<String, dynamic>> login(String phone, String password) async {
    try {
      final response = await http.post(
        Uri.parse(_loginUrl),
        body: jsonEncode({"phone": phone, "password": password}),
        headers: {"Content-Type": "application/json"},
      ).timeout(const Duration(seconds: 10)); // ১০ সেকেন্ড টাইমআউট

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {"status": "error", "message": "Server Error: ${response.statusCode}"};
      }
    } catch (e) {
      return {"status": "error", "message": "Connection Failed. Check Internet/IP."};
    }
  }

  // ================= HOME DATA API =================
  static Future<Map<String, dynamic>> fetchHomeData() async {
    try {
      // ✅ ফিক্স: localhost এর বদলে ভেরিয়েবল ব্যবহার করা হলো
      final response = await http.get(Uri.parse(_homeDataUrl)).timeout(
        const Duration(seconds: 5), // ৫ সেকেন্ড টাইমআউট (ফাস্ট রেসপন্সের জন্য)
        onTimeout: () {
          throw const SocketException("Connection Timed Out");
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {"status": "error", "message": "Failed to load home data"};
      }
    } catch (e) {
      print("API Error: $e");
      return {"status": "error", "message": "Connection Error"};
    }
  }
}