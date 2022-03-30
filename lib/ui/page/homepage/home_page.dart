library home;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:localise/common/app_color.dart';
import 'package:localise/common/app_dimens.dart';
import 'package:localise/common/app_fonts.dart';
import 'package:localise/common/app_text_style.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

part 'home_logic.dart';
part 'home_state.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final logic = Get.put(HomeLogic());
    final state = Get.find<HomeLogic>().state;
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                color: AppColor.primary,
              ),
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.all(AppDimens.mediumPadding),
                child: GestureDetector(
                  onTap: () {
                    state.isReduceBoxRayon.value =
                        !state.isReduceBoxRayon.value;
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: TextFormField(
                          focusNode: state.searchFocus,
                          controller: state.controller,
                          style: TextStyle(
                            fontFamily: AppFont.poppins,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: AppColor.primary,
                          ),
                          cursorColor: AppColor.primary,
                          decoration: InputDecoration(
                            hintText: "Quel est le point de depart ?",
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                AppDimens.smallBorderRadius,
                              ),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                AppDimens.smallBorderRadius,
                              ),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 0,
                              horizontal: AppDimens.smallPadding,
                            ),
                            suffixIcon: state.searchFocus.hasFocus
                                ? GestureDetector(
                                    onTap: () {
                                      state.controller.clear();
                                      // state.searchFocus.unfocus();
                                    },
                                    child: Icon(
                                      Icons.close,
                                      color: AppColor.primary,
                                    ),
                                  )
                                : Icon(Icons.search),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                        ),
                      ),
                      builSelectionRayonCard(state),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Obx builSelectionRayonCard(HomeState state) {
    return Obx(
      () {
        return AnimatedContainer(
          duration: Duration(milliseconds: 1000),
          padding: EdgeInsets.symmetric(vertical: AppDimens.mediumPadding / 2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppDimens.smallBorderRadius),
            color: Colors.white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimens.smallPadding,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Rayon",
                      style: !state.isReduceBoxRayon.value
                          ? AppTextStyle.title.copyWith(fontSize: 15)
                          : AppTextStyle.title,
                    ),
                    GestureDetector(
                      onTap: () {
                        state.isReduceBoxRayon.value =
                            !state.isReduceBoxRayon.value;
                      },
                      child: Icon(
                        state.isReduceBoxRayon.value
                            ? Icons.arrow_drop_up_rounded
                            : Icons.arrow_drop_down_rounded,
                        color: AppColor.primary,
                      ),
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: state.isReduceBoxRayon.value,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimens.smallPadding,
                    vertical: AppDimens.smallPadding / 2,
                  ),
                  child: Text(
                    "S'il vous plait veillez specifier la distance couvert par votre plan de localisation.",
                    style: AppTextStyle.simple,
                  ),
                ),
              ),
              Visibility(
                visible: state.isReduceBoxRayon.value,
                child: Padding(
                  padding:
                      const EdgeInsets.only(bottom: AppDimens.mediumPadding),
                  child: SfSlider(
                    activeColor: AppColor.primary,
                    inactiveColor: AppColor.primary.withOpacity(0.5),
                    min: 0.0,
                    max: 50.0,
                    value: state.rayon.value,
                    interval: 10,
                    showTicks: true,
                    showLabels: true,
                    enableTooltip: true,
                    minorTicksPerInterval: 1,
                    onChanged: (dynamic value) {
                      if (state.rayon != null) {
                        state.rayon.value = value;
                      }
                    },
                  ),
                ),
              ),
              Visibility(
                visible: state.rayon.value != 0 && state.isReduceBoxRayon.value,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppDimens.smallPadding,
                      ),
                      child: Text.rich(
                        TextSpan(
                          text: "Prendre tous les carrefours a  ",
                          style: AppTextStyle.simple,
                          children: [
                            TextSpan(
                              text:
                                  "${state.rayon.ceilToDouble().toString()} km",
                              style: AppTextStyle.simple.copyWith(
                                decoration: TextDecoration.underline,
                                color: AppColor.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: " autour de ",
                            ),
                            TextSpan(
                              text: "moi",
                              style: AppTextStyle.simple.copyWith(
                                decoration: TextDecoration.underline,
                                fontWeight: FontWeight.bold,
                                color: AppColor.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: AppDimens.smallPadding,
                            horizontal: AppDimens.smallPadding,
                          ),
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              primary: AppColor.primary,
                              minimumSize: Size(40, 40),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40),
                                // side: BorderSide(color: Colors.red),
                              ),
                            ),
                            child: Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 15,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
