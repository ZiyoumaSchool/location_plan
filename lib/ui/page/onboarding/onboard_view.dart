library onboarding;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:localise/common/app_color.dart';
import 'package:localise/common/app_dimens.dart';
import 'package:localise/common/app_fonts.dart';
import 'package:localise/common/app_image.dart';
import 'package:localise/common/app_text_style.dart';
import 'package:localise/ui/page/onboarding/widgets/page_component.dart';
import 'package:localise/ui/page/onboarding/widgets/play_and_stop.dart';
import 'package:localise/ui/shared_component/button_text.dart';
import 'package:localise/ui/shared_component/rounded_button.dart';
import 'package:lottie/lottie.dart';

part 'onboard_logic.dart';
part 'onboard_state.dart';

class OnboarddingPage extends StatelessWidget {
  OnboarddingPage({Key? key}) : super(key: key);

  final logic = Get.put(OnboardingLogic());
  final state = Get.find<OnboardingLogic>().state;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          // fit: StackFit.expand,
          children: [
            PageView(
              controller: state.controller,
              children: <Widget>[
                PageViewComponent(
                  animation: AppImage.onboard_1_json,
                  describe:
                      'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nec, suscipit arcu euismod nulla euismod felis nec. ',
                  title: 'Describe',
                ),
                PageViewComponent(
                  animation: AppImage.splash,
                  describe:
                      'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nec, suscipit arcu euismod nulla euismod felis nec. ',
                  title: 'Describe',
                ),
              ],
            ),
            _buildBottomBar(context),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return Positioned(
      bottom: 0,
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.all(AppDimens.mediumPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildStopAndPlayButton(),
              SizedBox(
                height: 70,
              ),
              _buildButtonBar(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStopAndPlayButton() {
    return Obx(
      () {
        return PlayAndStop(
          isStop: state.percent.value == 1.0,
          value: state.percent.value,
        );
      },
    );
  }

  Widget _buildButtonBar() {
    return Obx(
      () {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (state.current.value == 1)
              RoundedButton(
                icon: Icons.arrow_back_ios_new_rounded,
                press: logic.onPreviousPage,
              ),
            ButtonText(
              text: state.percent.value == 1.0 ? "Terminer" : "Passer",
              press: () {},
            ),
            if (state.percent.value != 1.0)
              RoundedButton(
                icon: CupertinoIcons.chevron_forward,
                press: logic.onNextPage,
              ),
          ],
        );
      },
    );
  }
}
