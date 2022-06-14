import 'package:get/get.dart';
import 'package:localise/ui/page/main/main_view.dart';
import 'package:localise/ui/page/main_static/main_static_view.dart';
import 'package:localise/ui/page/onboarding/onboard_view.dart';
import 'package:localise/ui/page/view_plan/view_pdf_state_page.dart';

class RouteConfig {
  ///main page
  static const String splash = "/splash";
  static const String onboard = "/onboard";
  static const String main = "/main";
  static const String view_plan = "/view_plan";
  static const String main_static = "/main_static";

  ///Alias ​​mapping page
  static final List<GetPage> getPages = [
    GetPage(
      name: onboard,
      page: () => OnboarddingPage(),
    ),
    GetPage(
      name: main,
      page: () => const MainPage(),
    ),
    GetPage(
      name: view_plan,
      page: () => ViewPDFgPage(),
    ),
    GetPage(
      name: main_static,
      page: () => MainStaticPage(),
    ),
  ];
}
