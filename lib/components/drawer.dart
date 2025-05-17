import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../db/app_database.dart';
import '../db/user_database.dart';
import '../pages/auth/login_page.dart';
import '../services/auth_service.dart';
import '../theme/theme_provider.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  String userName = 'User';
  String email = 'Email';

  @override
  void initState() {
    super.initState();
    _loaduser();
  }

  Future<void> _loaduser() async {
    final userDb = UserDatabase(AppDatabase.isar);
    final user = await userDb.getCurrentUser();
    setState(() {
      userName = user?.name ?? 'User';
      email = user?.email ?? 'Email';
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode =
        Provider.of<ThemeProvider>(context, listen: false).isDarkMode;

    return Drawer(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 50),
        child: Stack(
          children: [
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: () {
                        context.read<ThemeProvider>().toggleTheme();
                      },
                      icon: Icon(
                        isDarkMode ? Icons.light_mode : Icons.dark_mode,
                      ),
                    ),
                  ],
                ),

                // Profile Icon
                const CircleAvatar(
                  radius: 40,
                  child: Icon(Icons.person, size: 40),
                ),

                const SizedBox(height: 10),

                // User Name
                Text(
                  userName,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),

                // User Email
                Text(email),

                const SizedBox(height: 30),

                // Logout Button
                OutlinedButton.icon(
                  onPressed: () async {
                    showDeleteConfirmationDialog();
                  },
                  icon: const Icon(Icons.logout),
                  label: const Text("Log Out"),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 20,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> showDeleteConfirmationDialog() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Logout'),
          content: Text('Are you sure want to logout?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                final authService = context.read<AuthService>();
                await authService.logout();
                Navigator.pushReplacement(
                  // ignore: use_build_context_synchronously
                  context,
                  MaterialPageRoute(builder: (_) => const LoginPage()),
                );
              },
              child: Text('Logout'),
            ),
          ],
        );
      },
    );
  }
}
