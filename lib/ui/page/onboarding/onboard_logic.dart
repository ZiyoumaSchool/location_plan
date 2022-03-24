part of onboarding;

class OnboardingLogic extends GetxController {
  final OnboardingState state = OnboardingState();

  onNextPage() {
    if (state.percent.value >= 1) {
      return;
    }
    state.percent.value += 0.5;
    state.current.value = 1;

    state.controller.jumpToPage(state.current.value);
  }

  onPreviousPage() {
    if (state.percent.value <= 0) {
      return;
    }
    state.percent.value = 0.0;
    state.current.value = 0;

    state.controller.jumpToPage(state.current.value);
  }
}
