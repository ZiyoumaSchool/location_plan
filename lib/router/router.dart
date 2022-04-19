import 'package:get/get.dart';
import 'package:localise/ui/page/main/main_view.dart';
import 'package:localise/ui/page/onboarding/onboard_view.dart';

class RouteConfig {
  ///main page
  static final String splash = "/splash";
  static final String onboard = "/onboard";
  static final String main = "/main";

  ///Alias ​​mapping page
  static final List<GetPage> getPages = [
    GetPage(
      name: onboard,
      page: () => OnboarddingPage(),
    ),
    GetPage(
      name: main,
      page: () => MainPage(),
    ),
  ];
}
