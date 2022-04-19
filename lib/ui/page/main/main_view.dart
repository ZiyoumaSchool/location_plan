library main_page;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:localise/common/app_color.dart';
import 'package:localise/common/app_image.dart';
import 'package:localise/common/app_shadows.dart';
import 'package:location/location.dart';
import 'package:places_service/places_service.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

part 'main_logic.dart';
part 'main_state.dart';

class MainPage extends StatelessWidget {
  MainPage({Key? key}) : super(key: key);

  final logic = Get.put(MainLogic());
  final state = Get.find<MainLogic>().state;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Obx(() {
        return !state.isLoadCurrentPosition.value
            ? Stack(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
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
                    child: Center(
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
                    return GoogleMap(
                      markers: Set<Marker>.of([state.position.value]),
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
                          markerId: MarkerId("current_position"),
                          infoWindow: InfoWindow(
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
                          markerId: MarkerId("current_position"),
                          infoWindow: InfoWindow(
                            title: 'Zone selectioner',
                            snippet:
                                "Le plan va etre generer a partir de ce point",
                          ),
                          position: state.currentPos.value,
                        );
                      },
                    );
                  }),
                  Padding(
                    padding: const EdgeInsets.only(top: 50, right: 20),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: InkWell(
                        splashColor: AppColor.primary,
                        radius: 5,
                        onTap: () async {},
                        child: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(50),
                            boxShadow: AppShadow.boxShadow,
                          ),
                          child: Icon(
                            Icons.search,
                            color: AppColor.primary,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Obx(() {
                    return Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: 80,
                        padding: EdgeInsets.all(10),
                        margin: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: AppShadow.boxShadow,
                        ),
                        child: Center(
                          child: SfSlider(
                            activeColor: AppColor.primary,
                            inactiveColor: AppColor.primary.withOpacity(0.3),
                            min: state.minValue,
                            max: state.maxValue,
                            value: state.radius.value == null
                                ? state.minValue
                                : state.radius.value,
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
                                    zoom: state.radius.value ?? state.minValue,
                                  ),
                                ),
                              );

                              state.position.value = Marker(
                                markerId: MarkerId("current_position"),
                                infoWindow: InfoWindow(
                                  title: 'Zone selectioner',
                                  snippet:
                                      "Le plan va etre generer a partir de ce point",
                                ),
                                position: state.currentPos.value,
                              );

                              state.radius.value = value as double;
                            },
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              );
      }),
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
}
