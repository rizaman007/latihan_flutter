import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../widgets/custom_textfield.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();

  final authService = AuthService();

  void register() async {
    bool success = await authService.register(
      email: emailController.text,
      password: passwordController.text,
      name: nameController.text,
      phone: phoneController.text,
    );

    if (success) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Register berhasil")));

      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Register gagal")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Register")),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [
            CustomTextField(controller: nameController, label: "Name"),

            CustomTextField(controller: emailController, label: "Email"),

            CustomTextField(controller: phoneController, label: "Phone"),

            CustomTextField(
              controller: passwordController,
              label: "Password",
              isPassword: true,
            ),

            const SizedBox(height: 20),

            ElevatedButton(onPressed: register, child: const Text("Register")),
          ],
        ),
      ),
    );
  }
}
