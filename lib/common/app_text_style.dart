import 'package:flutter/material.dart';
import 'package:localise/common/app_color.dart';

class AppTextStyle {
  AppTextStyle._();
  static const TextStyle title = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 20,
    color: AppColor.black,
  );

  static const TextStyle simple = TextStyle(
    fontSize: 15,
    color: AppColor.black,
  );
}
