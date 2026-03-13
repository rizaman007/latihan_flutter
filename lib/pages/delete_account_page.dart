import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../utils/token_storage.dart';
import '../config/api_config.dart';

class DeleteAccountPage extends StatefulWidget {
  const DeleteAccountPage({super.key});

  @override
  State<DeleteAccountPage> createState() => _DeleteAccountPageState();
}

class _DeleteAccountPageState extends State<DeleteAccountPage> {
  bool isLoading = false;

  Future<void> deleteAccount() async {
    setState(() {
      isLoading = true;
    });

    final token = await TokenStorage.getToken();

    final url = Uri.parse("${ApiConfig.baseUrl}/user/account");

    try {
      final response = await http.delete(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      setState(() {
        isLoading = false;
      });

      if (response.statusCode == 200) {
        if (!mounted) return;

        await TokenStorage.clearToken();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Account deleted successfully")),
        );

        Navigator.pushNamedAndRemoveUntil(context, "/", (route) => false);
      } else {
        if (!mounted) return;

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Failed delete account")));
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  void confirmDelete() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Delete Account"),

          content: const Text(
            "Are you sure you want to delete your account? This action cannot be undone.",
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),

            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                deleteAccount();
              },
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Delete Account")),

      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 15,
                  ),
                ),

                onPressed: confirmDelete,

                child: const Text(
                  "Delete My Account",
                  style: TextStyle(fontSize: 16),
                ),
              ),
      ),
    );
  }
}
