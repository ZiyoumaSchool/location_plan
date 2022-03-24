import 'package:flutter/material.dart';
import 'package:localise/common/app_dimens.dart';
import 'package:localise/common/app_fonts.dart';
import 'package:localise/common/app_text_style.dart';
import 'package:lottie/lottie.dart';

class PageViewComponent extends StatelessWidget {
  const PageViewComponent({
    Key? key,
    required this.animation,
    required this.title,
    required this.describe,
  }) : super(key: key);

  final String animation;
  final String title;
  final String describe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppDimens.mediumPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: AppDimens.extraPadding,
          ),
          Lottie.asset(
            animation,
          ),
          SizedBox(
            height: AppDimens.extraPadding,
          ),
          Text(
            title,
            style: AppTextStyle.title.copyWith(
              fontSize: 25,
              fontFamily: AppFont.poppins,
            ),
          ),
          SizedBox(
            height: AppDimens.smallPadding,
          ),
          Text(
            describe,
            style: AppTextStyle.simple,
          ),
        ],
      ),
    );
  }
}
