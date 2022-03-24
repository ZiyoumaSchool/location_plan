import 'package:flutter/material.dart';
import 'package:localise/common/app_color.dart';
import 'package:localise/common/app_text_style.dart';

class ButtonText extends StatelessWidget {
  const ButtonText({
    Key? key,
    required this.press,
    required this.text,
  }) : super(key: key);
  final VoidCallback press;
  final String text;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: press,
      child: Text(
        text,
        style: AppTextStyle.simple.copyWith(
          fontWeight: FontWeight.w500,
          color: AppColor.primary,
        ),
      ),
    );
  }
}
