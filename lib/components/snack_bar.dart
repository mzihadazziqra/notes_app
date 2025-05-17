// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

void showMySnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 3)),
    );
}
