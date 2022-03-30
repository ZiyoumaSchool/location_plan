part of home;

class HomeState {
  late RxDouble rayon;
  late RxBool isReduceBoxRayon;
  late FocusNode searchFocus;
  late TextEditingController controller;

  HomeState() {
    controller = TextEditingController();
    searchFocus = FocusNode();
    rayon = 0.0.obs;
    isReduceBoxRayon = false.obs;
  }
}
