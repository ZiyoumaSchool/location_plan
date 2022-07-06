import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:localise/common/app_dimens.dart';
import 'package:localise/common/app_image.dart';
import 'package:localise/common/app_text_style.dart';
import 'package:localise/router/router.dart';
import 'package:localise/ui/models/location.dart';

void main() async {
  await GetStorage.init();
  await Hive.initFlutter();
  Hive.registerAdapter(LocationMapAdapter());

  await Hive.openBox('location');
  runApp(const MyApp());
}

Map<int, Color> color = {
  50: const Color.fromRGBO(136, 14, 79, .1),
  100: const Color.fromRGBO(136, 14, 79, .2),
  200: const Color.fromRGBO(136, 14, 79, .3),
  300: const Color.fromRGBO(136, 14, 79, .4),
  400: const Color.fromRGBO(136, 14, 79, .5),
  500: const Color.fromRGBO(136, 14, 79, .6),
  600: const Color.fromRGBO(136, 14, 79, .7),
  700: const Color.fromRGBO(136, 14, 79, .8),
  800: const Color.fromRGBO(136, 14, 79, .9),
  900: const Color.fromRGBO(136, 14, 79, 1),
};

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
        debugShowCheckedModeBanner: false,
        title: 'Location plan',
        theme: ThemeData(
          primarySwatch: MaterialColor(0xFF11823b, color),
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

  final box = GetStorage();

  //Wait 3 seconds and redirect user to onboarding page
  @override
  void initState() {
    super.initState();

    var isFirst = box.read('isFirst');

    Timer(
      const Duration(seconds: 3),
      () => Get.offAllNamed(isFirst == null || isFirst == false
          ? RouteConfig.onboard
          : RouteConfig.histoy),
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
            const SizedBox(
              height: AppDimens.mediumPadding * 3,
            ),
            Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(AppImage.logo_svg),
                  const Text.rich(
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
                  const SizedBox(
                    height: AppDimens.mediumPadding,
                  ),
                  const Text(
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
