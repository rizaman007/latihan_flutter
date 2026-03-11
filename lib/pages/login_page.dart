import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../widgets/custom_textfield.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final authService = AuthService();

  void login() async {
    bool success = await authService.login(
      emailController.text,
      passwordController.text,
    );

    if (success) {
      Navigator.pushNamed(context, "/dashboard");
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Login gagal")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [
            CustomTextField(controller: emailController, label: "Email"),

            CustomTextField(
              controller: passwordController,
              label: "Password",
              isPassword: true,
            ),

            const SizedBox(height: 20),

            ElevatedButton(onPressed: login, child: const Text("Login")),

            const SizedBox(height: 10),

            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, "/register");
              },
              child: const Text("Belum punya akun? Register"),
            ),
          ],
        ),
      ),
    );
  }
}
