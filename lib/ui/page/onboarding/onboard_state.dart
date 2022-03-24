part of onboarding;

class OnboardingState {
  late RxDouble percent;
  late RxInt current;

  late PageController controller;
  OnboardingState() {
    controller = PageController();
    percent = 0.0.obs;
    current = 0.obs;
  }
}
