import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../utils/token_storage.dart';

class AuthService {
  Future<bool> register({
    required String email,
    required String password,
    required String name,
    required String phone,
  }) async {
    final response = await http.post(
      Uri.parse("${ApiConfig.baseUrl}/auth/register"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "email": email,
        "password": password,
        "customerName": name,
        "phoneNumber": phone,
      }),
    );

    return response.statusCode == 200;
  }

  Future<bool> login(String email, String password) async {
    final response = await http.post(
      Uri.parse("${ApiConfig.baseUrl}/auth/login"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "password": password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      String token = data["token"];

      await TokenStorage.saveToken(token);

      return true;
    }

    return false;
  }
}
