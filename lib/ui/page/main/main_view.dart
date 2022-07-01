library main_page;

import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/rendering.dart';
import 'package:localise/router/router.dart';
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
import 'package:screenshot/screenshot.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

import 'package:pdf/widgets.dart' as pw;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Obx(() {
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
                      return RepaintBoundary(
                        key: state.key,
                        child:
                            // Container(
                            //   color: Colors.red,
                            //   height: 100,
                            //   width: 100,
                            // )
                            GoogleMap(
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
                        ),
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
                              // Align(
                              //   alignment: Alignment.bottomRight,
                              //   child: Container(
                              //     margin: const EdgeInsets.symmetric(
                              //         horizontal: 20),
                              //     // height: 500,
                              //     width: 40,
                              //     child: Column(
                              //       children: [
                              //         IconButton(
                              //           icon: Icons.add,
                              //           onpress: logic.incrementZone,
                              //         ),
                              //         Container(
                              //           decoration: BoxDecoration(
                              //             color: Colors.white,
                              //             borderRadius:
                              //                 BorderRadius.circular(10),
                              //           ),
                              //           height: state.radius.value != null
                              //               ? 330
                              //               : 400,
                              //           child: SfSlider.vertical(
                              //             min: state.minZoneValue,
                              //             max: state.maxZoneValue,
                              //             value: state.percentZone.value,
                              //             interval: 20,
                              //             showTicks: true,
                              //             // showLabels: true,
                              //             //  showTooltip: true,
                              //             minorTicksPerInterval: 1,
                              //             onChanged: (dynamic value) {
                              //               print(value);
                              //               state.percentZone.value = value;
                              //               print("change values");
                              //             },
                              //           ),
                              //         ),
                              //         IconButton(
                              //           icon: Icons.remove,
                              //           onpress: logic.decrementZone,
                              //         ),
                              //       ],
                              //     ),
                              //   ),
                              // ),

                              Container(
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
                                          final GoogleMapController controller =
                                              await state.mapController.future;

                                          controller.animateCamera(
                                            CameraUpdate.newCameraPosition(
                                              CameraPosition(
                                                target: state.currentPos.value,
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

                                          state.radius.value = value as double;
                                        },
                                      ),
                                      const SizedBox(
                                          height: AppDimens.smallPadding),
                                      Align(
                                        alignment: Alignment.bottomRight,
                                        child: state.radius.value != null
                                            ? ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  primary: AppColor.primary,
                                                ),
                                                onPressed: () async {
                                                  Get.toNamed(
                                                    RouteConfig.main_static,
                                                    arguments: {
                                                      "origin": state
                                                          .currentPos.value,
                                                      "zoom":
                                                          state.radius.value ??
                                                              state.minValue,
                                                    },
                                                  );
                                                  //   Get.toNamed(
                                                  //     RouteConfig.view_plan,
                                                  //     arguments: {
                                                  //       "file": file.path,
                                                  //     },
                                                  //   );
                                                  // });
                                                },
                                                child: const Text("continuer"),
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
    )
        // // Obx(() {
        //   return state.isLoadCurrentPosition.value
        //       ? Center(child: CircularProgressIndicator())
        //       : GoogleMap(
        //           mapType: MapType.normal,
        //           initialCameraPosition: CameraPosition(
        //             target: LatLng(
        //               3.850761,
        //               11.495295,
        //               // state.currentPosition.latitude!,
        //               // state.currentPosition.longitude!,
        //             ),
        //             zoom: 16,
        //           ),
        //           onMapCreated: (GoogleMapController controller) {
        //             state.mapController.complete(controller);
        //           },
        //         );
        // }),
        );
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
