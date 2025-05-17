import 'package:flutter/material.dart';

class PasswdTextField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  const PasswdTextField({
    super.key,
    required this.controller,
    required this.label,
  });

  @override
  State<PasswdTextField> createState() => _PasswdTextFieldState();
}

class _PasswdTextFieldState extends State<PasswdTextField> {
  bool obscureText = true;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: obscureText,
      validator:
          (value) =>
              value == null || value.isEmpty
                  ? '${widget.label} is required'
                  : null,
      decoration: InputDecoration(
        labelText: widget.label,
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              obscureText = !obscureText;
            });
          },
          icon: Icon(
            obscureText == true ? Icons.visibility_off : Icons.visibility,
          ),
        ),
      ),
    );
  }
}
