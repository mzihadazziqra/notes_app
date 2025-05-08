// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class MySnackBar extends StatelessWidget {
  final String message;
  const MySnackBar({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return SnackBar(content: Text(message), duration: Duration(seconds: 3));
  }
}
