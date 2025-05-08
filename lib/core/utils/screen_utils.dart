import 'package:flutter/material.dart';

class ScreenUtils {
  static Size getScreenSize(BuildContext context) {
    return MediaQuery.of(context).size;
  }
}
