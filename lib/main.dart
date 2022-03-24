import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:localise/common/app_color.dart';
import 'package:localise/common/app_dimens.dart';
import 'package:localise/common/app_image.dart';
import 'package:localise/common/app_text_style.dart';
import 'package:localise/router/router.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: hideKeyboard,
      child: GetMaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: SplashhPage(),
        getPages: RouteConfig.getPages,
      ),
    );
  }

  void hideKeyboard() {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }
}

class SplashhPage extends StatefulWidget {
  @override
  _SplashhPageState createState() => _SplashhPageState();
}

class _SplashhPageState extends State<SplashhPage> {
  // var storage = Get.find<GetStorage>();

  @override
  void initState() {
    super.initState();
    Timer(
      Duration(seconds: 3),
      () => Get.offAllNamed(RouteConfig.onboard),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      child: SizedBox(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: SvgPicture.asset(AppImage.top_left_circle_svg),
            ),
            SizedBox(
              height: AppDimens.mediumPadding * 3,
            ),
            Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(AppImage.logo_svg),
                  Text.rich(
                    TextSpan(
                      text: "GEO",
                      children: [
                        TextSpan(
                          text: "LOCALISE",
                          style: AppTextStyle.splahTextGreenStyle,
                        ),
                      ],
                      style: AppTextStyle.splahTextStyle,
                    ),
                  ),
                  SizedBox(
                    height: AppDimens.mediumPadding,
                  ),
                  Text(
                    "Généré votre plan de localisation.",
                    style: AppTextStyle.simple,
                  )
                ],
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: SvgPicture.asset(AppImage.couronne),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: SvgPicture.asset(AppImage.bottom_right_circle_svg),
            ),
          ],
        ),
      ),
    );
  }

  // String getFirstPage() {
  //   var isFirst = storage.read('isFirst');
  //   var hasToken = storage.read('token');

  //   if (isFirst == null) {
  //     storage.write('isFirst', false);
  //     return Routes.onboard;
  //   } else if (isFirst == false && hasToken == null) {
  //     return Routes.login;
  //   } else if (isFirst == false && hasToken != null) {
  //     return Routes.home;
  //   } else {
  //     return Routes.login;
  //   }
  // }
}
