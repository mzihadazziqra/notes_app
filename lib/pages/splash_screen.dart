import 'package:flutter/material.dart';
import 'package:notes_app/pages/auth/login_page.dart';
import 'package:notes_app/pages/notes_page.dart';
import 'package:notes_app/services/auth_service.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _chechLoginStatus();
  }

  Future<void> _chechLoginStatus() async {
    final authProvider = Provider.of<AuthService>(context, listen: false);
    await authProvider.tryAutoLogin();

    if (!mounted) return;

    if (authProvider.isLoggedIn) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const NotesPage()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
