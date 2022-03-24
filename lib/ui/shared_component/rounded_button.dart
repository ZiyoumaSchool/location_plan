import 'package:flutter/material.dart';
import 'package:localise/common/app_color.dart';

class RoundedButton extends StatelessWidget {
  const RoundedButton({
    Key? key,
    required this.press,
    required this.icon,
  }) : super(key: key);
  final VoidCallback press;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: Container(
        height: 50,
        width: 50,
        decoration: BoxDecoration(
          color: AppColor.primary,
          borderRadius: BorderRadius.circular(40),
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: 20,
        ),
      ),
    );
  }
}
