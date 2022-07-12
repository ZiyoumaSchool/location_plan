library main_page;

import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:get_storage/get_storage.dart';
import 'package:google_map_polyline_new/google_map_polyline_new.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:localise/router/router.dart';
import 'package:localise/ui/models/location.dart';
import 'package:location/location.dart' as locate;
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:google_api_headers/google_api_headers.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:localise/common/app_color.dart';
import 'package:localise/common/app_dimens.dart';
import 'package:localise/common/app_image.dart';
import 'package:localise/common/app_shadows.dart';
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';
// import 'package:screenshot/screenshot.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

import 'package:google_static_maps_controller/google_static_maps_controller.dart'
    as static_map;
import 'package:pdf/widgets.dart' as pw;
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

part 'main_logic.dart';
part 'main_state.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final logic = Get.put(MainLogic());

  final state = Get.find<MainLogic>().state;

  late TutorialCoachMark tutorialCoachMark;
  List<TargetFocus> targets = <TargetFocus>[];
  GlobalKey key_slide = GlobalKey();
  GlobalKey key_search_button = GlobalKey();

  @override
  void initState() {
    // TODO: implement initState
    initTarget();
    super.initState();
  }

  void initTarget() {
    targets.add(
      TargetFocus(
        identify: "Target 0",
        keyTarget: key_search_button,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            child: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Chercher une zone ",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 20.0),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Text(
                      "Cliquez sur ce bouton rechercher une zone apartir de la quel le pla va etres generer.",
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );

    targets.add(TargetFocus(
      identify: "Target 1",
      keyTarget: key_slide,
      contents: [
        TargetContent(
          align: ContentAlign.top,
          child: Container(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: Text(
                    "Definir le rayon",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0),
                  ),
                ),
                Text(
                  "Definir la surface a prendre sur la map. Celle ci vous permet de definir les zone visible sur la carte.",
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ],
      shape: ShapeLightFocus.RRect,
    ));
  }

  void showTutorial() {
    tutorialCoachMark = TutorialCoachMark(
      context,
      targets: targets,
      colorShadow: AppColor.primary,
      textSkip: "Sauter",
      paddingFocus: 10,
      opacityShadow: 0.8,
      onFinish: () {
        print("finish");

        state.box.write("isFirstParam", false);
        state.isFirstParam.value = false;
      },
      onClickTarget: (target) {
        print('onClickTarget: $target');
      },
      onSkip: () {
        print("skip");
      },
      onClickOverlay: (target) {
        print('onClickOverlay: $target');
      },
    )..show();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Obx(() {
            if (state.isLoadCurrentPosition.value && state.isFirstParam.value) {
              showTutorial();
            }

            return !state.isLoadCurrentPosition.value
                ? Stack(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        decoration: const BoxDecoration(
                          // color: Colors.grey.shade900.withOpacity(0.3),
                          image: DecorationImage(
                            fit: BoxFit.fitHeight,
                            image: AssetImage(AppImage.maps),
                          ),
                        ),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade900.withOpacity(0.3),
                        ),
                        child: const Center(
                          child: CircularProgressIndicator(
                            color: AppColor.primary,
                          ),
                        ),
                      ),
                    ],
                  )
                :
                // return
                Stack(
                    children: [
                      Obx(() {
                        if (state.isVisible.value) {
                          print("say hello");
                        }
                        return GoogleMap(
                          markers: <Marker>{state.position.value},
                          zoomControlsEnabled: false,
                          zoomGesturesEnabled: true,
                          mapType: MapType.normal,
                          initialCameraPosition: CameraPosition(
                            target: state.currentPos.value,
                            // zoom: state.radius.value ?? state.minValue,
                          ),
                          onMapCreated:
                              (GoogleMapController controllerCurrent) async {
                            state.gmMapController = controllerCurrent;
                            state.mapController.complete(controllerCurrent);

                            final GoogleMapController controller =
                                await state.mapController.future;

                            controller.animateCamera(
                              CameraUpdate.newCameraPosition(
                                CameraPosition(
                                  target: state.currentPos.value,
                                  zoom: 15,
                                ),
                              ),
                            );

                            state.currentMarker.value =
                                static_map.Marker.custom(
                              anchor: static_map.MarkerAnchor.center,
                              icon: "https://goo.gl/1oTJ9Y0",
                              locations: [
                                static_map.Location(
                                  state.currentPos.value.latitude,
                                  state.currentPos.value.longitude,
                                ),
                              ],
                            );

                            state.position.value = Marker(
                              markerId: const MarkerId("current_position"),
                              infoWindow: const InfoWindow(
                                title: 'Zone selectioner',
                                snippet:
                                    "Le plan va etre generer a partir de ce point",
                              ),
                              position: state.currentPos.value,
                            );
                          },
                          onTap: (position) async {
                            state.currentPos.value = position;
                            print(position.toString());

                            final GoogleMapController controller =
                                await state.mapController.future;

                            controller.animateCamera(
                              CameraUpdate.newCameraPosition(
                                CameraPosition(
                                  target: state.currentPos.value,
                                  zoom: state.radius.value ?? state.minValue,
                                ),
                              ),
                            );

                            state.currentMarker.value =
                                static_map.Marker.custom(
                              anchor: static_map.MarkerAnchor.center,
                              icon: "https://goo.gl/1oTJ9Y0",
                              locations: [
                                static_map.Location(
                                  state.currentPos.value.latitude,
                                  state.currentPos.value.longitude,
                                ),
                              ],
                            );

                            state.position.value = Marker(
                              markerId: const MarkerId("current_position"),
                              infoWindow: const InfoWindow(
                                title: 'Zone selectioner',
                                snippet:
                                    "Le plan va etre generer a partir de ce point",
                              ),
                              position: state.currentPos.value,
                            );
                          },
                        );
                      }),
                      Obx(() {
                        return Visibility(
                          visible: state.isVisible.value,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 50, right: 20),
                            child: Align(
                              alignment: Alignment.topRight,
                              child: InkWell(
                                key: key_search_button,
                                splashColor: AppColor.primary,
                                radius: 5,

                                // onTap: _showMyDialog
                                onTap: _handlePressButton,
                                child: Container(
                                  height: 50,
                                  width: 50,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(50),
                                    boxShadow: AppShadow.boxShadow,
                                  ),
                                  child: const Icon(
                                    Icons.search,
                                    color: AppColor.primary,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                      Obx(() {
                        return Visibility(
                          visible: state.isVisible.value,
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  key: key_slide,
                                  height: state.radius.value == null ? 90 : 140,
                                  padding: const EdgeInsets.all(10),
                                  margin: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: AppShadow.boxShadow,
                                  ),
                                  child: Center(
                                    child: Column(
                                      children: [
                                        SfSlider(
                                          activeColor: AppColor.primary,
                                          inactiveColor:
                                              AppColor.primary.withOpacity(0.3),
                                          min: state.minValue,
                                          max: state.maxValue,
                                          value: state.radius.value ??
                                              state.minValue,
                                          interval: 2,
                                          showTicks: true,
                                          showLabels: true,
                                          enableTooltip: true,
                                          minorTicksPerInterval: 1,
                                          onChanged: (dynamic value) async {
                                            final GoogleMapController
                                                controller = await state
                                                    .mapController.future;

                                            controller.animateCamera(
                                              CameraUpdate.newCameraPosition(
                                                CameraPosition(
                                                  target:
                                                      state.currentPos.value,
                                                  zoom: state.radius.value ??
                                                      state.minValue,
                                                ),
                                              ),
                                            );

                                            state.position.value = Marker(
                                              markerId: const MarkerId(
                                                  "current_position"),
                                              infoWindow: const InfoWindow(
                                                title: 'Zone selectioner',
                                                snippet:
                                                    "Le plan va etre generer a partir de ce point",
                                              ),
                                              position: state.currentPos.value,
                                            );

                                            state.currentMarker.value =
                                                static_map.Marker.custom(
                                              anchor: static_map
                                                  .MarkerAnchor.center,
                                              icon: "https://goo.gl/1oTJ9Y0",
                                              locations: [
                                                static_map.Location(
                                                  state.currentPos.value
                                                      .latitude,
                                                  state.currentPos.value
                                                      .longitude,
                                                ),
                                              ],
                                            );
                                            state.radius.value =
                                                value as double;
                                          },
                                        ),
                                        const SizedBox(
                                            height: AppDimens.smallPadding),
                                        Align(
                                          alignment: Alignment.bottomRight,
                                          child: state.radius.value != null
                                              ? ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    primary: AppColor.primary,
                                                  ),
                                                  onPressed: () async {
                                                    showDialog(
                                                        context: context,
                                                        builder: (context) {
                                                          return AlertDialog(
                                                            scrollable: true,
                                                            // resizeToAvoidBottomInset: true,
                                                            title: const Text(
                                                                'Information'), // To display the title it is optional
                                                            content:
                                                                getContent(), // Message which will be pop up on the screen
                                                            // Action widget which will provide the user to acknowledge the choice
                                                            actions: [
                                                              cancelBtn(),
                                                              confirmBtn(),
                                                            ],
                                                          );
                                                        });
                                                    // Get.defaultDialog(
                                                    //   title: "Informations",
                                                    //   middleText: "",
                                                    //   content: getContent(),
                                                    //   barrierDismissible: false,
                                                    //   radius: 10.0,
                                                    //   confirm: confirmBtn(),
                                                    //   cancel: cancelBtn(),
                                                    // );
                                                  },
                                                  child:
                                                      const Text("continuer"),
                                                )
                                              : Container(),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ],
                  );
          }),
        ),
      ),
    );
  }

  Widget buildName() {
    return ValueListenableBuilder(
      // Note: pass _controller to the animation argument
      valueListenable: state.nameController,
      builder: (context, TextEditingValue value, __) {
        // this entire widget tree will rebuild every time
        // the controller value changes
        return TextFormField(
          controller: state.nameController,
          // autovalidateMode: AutovalidateMode.onUserInteraction,
          // validator: logic.userNameError,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Entrez votre nom',
            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          ),
        );
      },
    );
  }

  Widget buildPhone() {
    return ValueListenableBuilder(
      // Note: pass _controller to the animation argument
      valueListenable: state.phoneController,
      builder: (context, TextEditingValue value, __) {
        // this entire widget tree will rebuild every time
        // the controller value changes
        return TextFormField(
          controller: state.phoneController,
          keyboardType: TextInputType.phone,
          // validator: logic.userPhoneError,
          // autovalidateMode: AutovalidateMode.onUserInteraction,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Entrez le numero de telephone',
            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          ),
        );
      },
    );
  }

  Widget _floatingCollapsed() {
    return Container(
      height: 10,
      decoration: const BoxDecoration(
        color: Colors.blueGrey,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24.0), topRight: Radius.circular(24.0)),
      ),
      child: const Center(
        child: Text(
          "This is the collapsed Widget",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget _floatingPanel() {
    return Container(
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24.0), topRight: Radius.circular(24.0)),
          boxShadow: [
            BoxShadow(
              blurRadius: 20.0,
              color: Colors.grey,
            ),
          ]),
      // margin: const EdgeInsets.all(24.0),
      child: const Center(
        child: Text("This is the SlidingUpPanel when open"),
      ),
    );
  }

  Widget buildSurname() {
    return ValueListenableBuilder(
      // Note: pass _controller to the animation argument
      valueListenable: state.surnameController,
      builder: (context, TextEditingValue value, __) {
        // this entire widget tree will rebuild every time
        // the controller value changes
        return TextFormField(
          controller: state.surnameController,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          // validator: logic.userSurnameError,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Entrez votre prenom',

            // errorText: logic.userSurnameError,
            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          ),
        );
      },
    );
  }

  Widget confirmBtn() {
    return Obx(
      () {
        return ElevatedButton(
            onPressed: () async {
              // if (!state.mapLoad.value) {
              //   if (logic.userPhoneError(state.phoneController.text) == null &&
              //       logic.userNameError(state.nameController.text) == null &&
              //       logic.userSurnameError(state.surnameController.text) ==
              //           null &&
              //       logic.userTitleError(state.titleController.text) == null) {
              //     await logic.printMap();
              //   }
              //   Get.back();

              // }
              await logic.printMap();
              Get.back();
            },
            child: state.mapLoad.value
                ? const Padding(
                    padding: EdgeInsets.all(5),
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  )
                : const Text("Imprimer"));
      },
    );
  }

  Widget getContent() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        buildName(),
        const SizedBox(
          height: 10,
        ),
        buildSurname(),
        const SizedBox(
          height: 10,
        ),
        buildPhone(),
        const SizedBox(
          height: 10,
        ),
        TextFormField(
          controller: state.describeController,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Entrez une description de la carte',
          ),
          maxLines: 5,
        ),
      ],
    );
  }

  Widget cancelBtn() {
    return ElevatedButton(
        onPressed: () {
          Get.back();
        },
        child: const Text("Annuler"));
  }

  Future<void> displayPrediction(Prediction? p, BuildContext context) async {
    if (p != null) {
      // get detail (lat/lng)
      GoogleMapsPlaces _places = GoogleMapsPlaces(
        apiKey: MainState().kGoogleApiKey,
        apiHeaders: await const GoogleApiHeaders().getHeaders(),
      );
      PlacesDetailsResponse detail =
          await _places.getDetailsByPlaceId(p.placeId!);
      final lat = detail.result.geometry!.location.lat;
      final lng = detail.result.geometry!.location.lng;

      state.currentPos.value = LatLng(lat, lng);
      // print(position.toString());

      final GoogleMapController controller = await state.mapController.future;

      controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: state.currentPos.value,
            zoom: state.radius.value ?? state.minValue,
          ),
        ),
      );
      state.position.value = Marker(
        markerId: const MarkerId("current_position"),
        infoWindow: const InfoWindow(
          title: 'Zone selectioner',
          snippet: "Le plan va etre generer a partir de ce point",
        ),
        position: state.currentPos.value,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("${p.description} - $lat/$lng")),
      );
    }
  }

  void onError(PlacesAutocompleteResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(response.errorMessage!)),
    );
  }

  Future<void> _handlePressButton() async {
    Prediction? p = await PlacesAutocomplete.show(
      context: context,
      apiKey: state.kGoogleApiKey,
      onError: onError,
      strictbounds: false,
      mode: Mode.overlay,
      types: [
        // "(cities)"
      ],
      language: "fr",
      decoration: InputDecoration(
        hintText: 'Selectionez un lieu',
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(
            color: Colors.white,
          ),
        ),
      ),
      components: [Component(Component.country, "cm")],
    );
    displayPrediction(p, context);
  }
}

class IconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onpress;

  const IconButton({
    Key? key,
    required this.icon,
    required this.onpress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 10,
      ),
      child: InkWell(
        onTap: onpress,
        child: Container(
          height: 30,
          width: 30,
          decoration: BoxDecoration(
            color: AppColor.primary,
            borderRadius: BorderRadius.circular(50),
            boxShadow: AppShadow.boxShadow,
          ),
          child: Icon(
            icon,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
