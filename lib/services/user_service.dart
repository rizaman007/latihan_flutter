import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../utils/token_storage.dart';

class UserService {
  Future<Map<String, dynamic>> getProfile() async {
    String? token = await TokenStorage.getToken();

    final response = await http.get(
      Uri.parse("${ApiConfig.baseUrl}/user/profile"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to load profile");
    }
  }

  Future<bool> updateProfile(String name, String phone) async {
    String? token = await TokenStorage.getToken();

    final response = await http.put(
      Uri.parse("${ApiConfig.baseUrl}/user/profile"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: jsonEncode({"customerName": name, "phoneNumber": phone}),
    );

    return response.statusCode == 200;
  }

  Future<bool> changePassword(
    String currentPassword,
    String newPassword,
  ) async {
    String? token = await TokenStorage.getToken();

    final response = await http.put(
      Uri.parse("${ApiConfig.baseUrl}/user/change-password"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "currentPassword": currentPassword,
        "newPassword": newPassword,
      }),
    );

    return response.statusCode == 200;
  }
}
