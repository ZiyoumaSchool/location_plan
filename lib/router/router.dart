import 'package:get/get.dart';
import 'package:localise/ui/page/homepage/home_page.dart';
import 'package:localise/ui/page/onboarding/onboard_page.dart';

class RouteConfig {
  ///main page
  static final String splash = "/splash";
  static final String onboard = "/onboard";
  static final String home = "/home";

  ///Alias ​​mapping page
  static final List<GetPage> getPages = [
    GetPage(
      name: onboard,
      page: () => OnboarddingPage(),
    ),
    GetPage(
      name: home,
      page: () => HomePage(),
    ),
  ];
}
