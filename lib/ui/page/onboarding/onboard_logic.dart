part of onboarding;

class OnboardingLogic extends GetxController {
  final OnboardingState state = OnboardingState();

  // When user go to next page if play button is full no action
  // Else add 0.5 to percent and set page to 1
  onNextPage() {
    if (state.percent.value >= 1) {
      return;
    }
    state.percent.value += 0.5;
    state.current.value = 1;

    state.controller.jumpToPage(state.current.value);
  }

  // When user go to previous page if play button is Empty no action
  // Else substract 0.5 to percent and set page to 0
  onPreviousPage() {
    if (state.percent.value <= 0) {
      return;
    }
    state.percent.value = 0.0;
    state.current.value = 0;

    state.controller.jumpToPage(state.current.value);
  }
}
