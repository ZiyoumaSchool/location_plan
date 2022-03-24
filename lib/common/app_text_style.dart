import 'package:flutter/material.dart';
import 'package:localise/common/app_color.dart';
import 'package:localise/common/app_fonts.dart';

class AppTextStyle {
  AppTextStyle._();
  static const TextStyle title = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 20,
    color: AppColor.black,
  );

  static const TextStyle simple = TextStyle(
    fontSize: 14,
    color: AppColor.black,
    decoration: TextDecoration.none,
    fontWeight: FontWeight.normal,
    fontFamily: AppFont.poppins,
  );

  static const TextStyle splahTextStyle = TextStyle(
    color: AppColor.black,
    fontWeight: FontWeight.w500,
    fontSize: 18,
    letterSpacing: 3,
    decoration: TextDecoration.none,
  );
  static const TextStyle splahTextGreenStyle = TextStyle(
    color: AppColor.primary,
    fontWeight: FontWeight.w900,
    fontSize: 18,
    letterSpacing: 3,
    decoration: TextDecoration.none,
  );
}
