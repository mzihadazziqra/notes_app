import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../components/custom_text_field.dart';
import '../../components/passwd_text_field.dart';
import '../../components/snack_bar.dart';
import '../../core/utils/screen_utils.dart';
import '../../services/auth_service.dart';
import '../notes_page.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;

  Future<void> _submitLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final authProvider = Provider.of<AuthService>(context, listen: false);
    final success = await authProvider.login(
      _emailController.text,
      _passwordController.text,
    );

    setState(() => _isLoading = false);

    if (success && mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const NotesPage()),
      );
    } else {
      if (!mounted) return;
      showMySnackBar(context, 'Login failed, try again');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(40),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 3,
            children: [
              Text(
                'Login',
                style: GoogleFonts.dmSerifDisplay(
                  fontSize: ScreenUtils.getScreenSize(context).width * 0.2,
                ),
              ),
              CustomTextField(controller: _emailController, label: 'Email'),
              PasswdTextField(
                controller: _passwordController,
                label: 'Password',
              ),

              const SizedBox(height: 10),
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      // side: BorderSide(width: 1),
                    ),
                    onPressed: _submitLogin,
                    child: const Text('Login'),
                  ),

              SizedBox(height: 5),
              Row(
                children: [
                  Text('Dont have an account? '),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RegisterPage(),
                        ),
                      );
                    },
                    child: Text(
                      'Register',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
