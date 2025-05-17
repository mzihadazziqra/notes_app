import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/custom_text_field.dart';
import '../../components/passwd_text_field.dart';
import '../../components/snack_bar.dart';
import '../../core/utils/screen_utils.dart';
import '../../services/auth_service.dart';
import '../notes_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwdController = TextEditingController();
  final _confirmPasswdController = TextEditingController();

  bool _isLoading = false;

  Future<void> _submitRegister() async {
    if (!_formKey.currentState!.validate()) return;

    if (_passwdController.text != _confirmPasswdController.text) {
      showMySnackBar(context, 'Password not match');
      return;
    }

    setState(() => _isLoading = true);

    final authProvider = Provider.of<AuthService>(context, listen: false);
    final success = await authProvider.register(
      _nameController.text,
      _emailController.text,
      _passwdController.text,
    );

    setState(() => _isLoading = false);

    if (success && mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const NotesPage()),
      );
    } else {
      if (!mounted) return;
      showMySnackBar(context, 'Register failed, try again');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = ScreenUtils.getScreenSize(context).width;
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
                'Register',
                style: TextStyle(
                  fontFamily: "DmSerifText",
                  fontSize: screenWidth * 0.15,
                ),
              ),
              CustomTextField(controller: _nameController, label: 'Name'),
              CustomTextField(controller: _emailController, label: 'Email'),
              PasswdTextField(controller: _passwdController, label: 'Password'),
              PasswdTextField(
                controller: _confirmPasswdController,
                label: 'Confirm Password',
              ),
              const SizedBox(height: 10),
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                    onPressed: _submitRegister,
                    style: ElevatedButton.styleFrom(elevation: 0),
                    child: const Text('Register'),
                  ),
              const SizedBox(height: 5),
              Row(
                children: [
                  const Text('Already have an account? '),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Login',
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
