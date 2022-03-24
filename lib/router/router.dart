import 'package:get/get.dart';
import 'package:localise/ui/page/onboarding/onboard_view.dart';

class RouteConfig {
  ///main page
  static final String splash = "/splash";
  static final String onboard = "/onboard";

  ///Alias ​​mapping page
  static final List<GetPage> getPages = [
    GetPage(
      name: onboard,
      page: () => OnboarddingPage(),
    ),
  ];
}
