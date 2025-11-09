import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String baseUrl = "http://192.168.43.13:5000";

  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('jwt_token', token);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt_token');
  }

  Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwt_token');
  }

  Future<Map<String, dynamic>> signup(
    String name,
    String email,
    String password,
  ) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/auth/signup"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"name": name, "email": email, "password": password}),
      );

      final data = jsonDecode(response.body);
      // print("🔹 Signup Response (${response.statusCode}): $data");

      if (response.statusCode == 201) {
        // ✅ Save token safely if available
        if (data['token'] != null) {
          await saveToken(data['token']);
        } else {
          print("⚠️ Warning: Token not found in response");
        }

        // ✅ Return user safely as Map
        if (data['user'] != null && data['user'] is Map<String, dynamic>) {
          return Map<String, dynamic>.from(data['user']);
        } else {
          print("⚠️ Warning: 'user' key not found, returning empty map");
          return {};
        }
      } else {
        throw Exception(
          data['message'] ?? "Signup failed with status ${response.statusCode}",
        );
      }
    } catch (e) {
      print("❌ Signup Error: $e");
      throw Exception("Signup failed: $e");
    }
  } 

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/auth/login"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "password": password}),
      );

      // Decode once and print for debugging
      final data = jsonDecode(response.body);
      // print("🔹 Login API Response: ${response.statusCode} - ${response.body}");

      if (response.statusCode == 200) {
        // Check token existence
        if (data['token'] != null) {
          await saveToken(data['token']);
        } else {
          print("⚠️ Warning: Token not found in response");
        }

        // Ensure 'user' key is a Map
        if (data['user'] != null && data['user'] is Map<String, dynamic>) {
          return data['user'];
        } else {
          // Fallback — if backend didn’t include user data
          print("⚠️ Warning: 'user' not found, returning empty map");
          return {};
        }
      } else {
        throw Exception(
          data['message'] ?? "Login failed with status ${response.statusCode}",
        );
      }
    } catch (e) {
      // Catch decoding or network errors
      print("❌ Login Error: $e");
      throw Exception("Login failed: $e");
    }
  }

  Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null;
  }
}
