import 'package:flutter/material.dart';
import '../services/user_service.dart';
import '../utils/token_storage.dart';
import 'edit_profile_page.dart';
import 'change_password_page.dart';
import 'delete_account_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final UserService userService = UserService();

  Map<String, dynamic>? userData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  Future<void> loadProfile() async {
    setState(() {
      isLoading = true;
    });

    final data = await userService.getProfile();

    setState(() {
      userData = data;
      isLoading = false;
    });
  }

  void logout() async {
    await TokenStorage.clearToken();

    if (!mounted) return;

    Navigator.pushNamedAndRemoveUntil(context, "/", (route) => false);
  }

  void openEditProfile() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfilePage(userData: userData!),
      ),
    );

    if (result == true) {
      loadProfile();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: loadProfile),

          IconButton(icon: const Icon(Icons.logout), onPressed: logout),
        ],
      ),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : userData == null
          ? const Center(child: Text("Failed to load profile"))
          : Padding(
              padding: const EdgeInsets.all(20),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Welcome",
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    userData!["customerName"] ?? "",
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 30),

                  Card(
                    elevation: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(20),

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Account Information",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 20),

                          Row(
                            children: [
                              const Icon(Icons.email),
                              const SizedBox(width: 10),
                              Text(userData!["email"] ?? ""),
                            ],
                          ),

                          const SizedBox(height: 15),

                          Row(
                            children: [
                              const Icon(Icons.phone),
                              const SizedBox(width: 10),
                              Text(userData!["phoneNumber"] ?? ""),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  SizedBox(
                    width: double.infinity,

                    child: ElevatedButton.icon(
                      onPressed: openEditProfile,
                      icon: const Icon(Icons.edit),
                      label: const Text("Edit Profile"),
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,

                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ChangePasswordPage(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.lock),
                      label: const Text("Change Password"),
                    ),
                  ),
                  const SizedBox(height: 10),

                  SizedBox(
                    width: double.infinity,

                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const DeleteAccountPage(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.delete),
                      label: const Text("Delete Account"),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
