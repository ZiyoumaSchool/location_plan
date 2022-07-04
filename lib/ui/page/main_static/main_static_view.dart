library main_static;

import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:custom_marker/marker_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:get/get.dart';
import 'package:google_map_polyline_new/google_map_polyline_new.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gm;
import 'package:google_maps_routes/google_maps_routes.dart';
import 'package:localise/common/app_color.dart';
import 'package:localise/common/app_shadows.dart';
import 'package:localise/router/router.dart';
import 'package:path_provider/path_provider.dart';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import 'package:http/http.dart' as http;

import 'package:google_api_headers/google_api_headers.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';

import 'package:google_static_maps_controller/google_static_maps_controller.dart'
    as static_map;
import 'package:syncfusion_flutter_sliders/sliders.dart';

part 'main_static_logic.dart';
part 'main_static_state.dart';

class MainStaticPage extends StatefulWidget {
  MainStaticPage({Key? key}) : super(key: key);

  @override
  State<MainStaticPage> createState() => _MainStaticPageState();
}

class _MainStaticPageState extends State<MainStaticPage> {
  final logic = Get.put(
    MainStaticLogic(
      originPoint: Get.arguments["origin"] as gm.LatLng,
      zoom: Get.arguments["zoom"] as double,
      // originPoint: gm.LatLng(3.8538009395394046, 11.489106018821056),
    ),
  );

  final state = Get.find<MainStaticLogic>().state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () async {
              Get.defaultDialog(
                title: "Informations",
                middleText: "",
                content: getContent(),
                barrierDismissible: false,
                radius: 10.0,
                confirm: confirmBtn(),
                cancel: cancelBtn(),
              );
              // await logic.printMap();
              // await printMap();
            },
            icon: Icon(Icons.print),
          ),
        ],
      ),
      body: Stack(
        children: [
          Obx(
            () {
              if (state.isLoadingGeneratePoint.value) {
                print("generate point en cour");
              }
              return Column(
                children: [
                  Expanded(
                    flex: 18,
                    child: Obx(() {
                      return static_map.StaticMap(
                        center: static_map.Location(state.originPoint.latitude,
                            state.originPoint.longitude),
                        googleApiKey: state.API_KEY,
                        width: MediaQuery.of(context).size.width,
                        // height: MediaQuery.of(context).size.height - 200,
                        scaleToDevicePixelRatio: true,
                        zoom: state.zoom.value,
                        paths: state.paths,
                        markers: state.markers,
                      );
                    }),
                  ),
                  // Expanded(
                  //   flex: 2,
                  //   child: Container(
                  //     // height: 100,
                  //     padding: EdgeInsets.all(8),
                  //     decoration: BoxDecoration(
                  //       color: Colors.white,
                  //       borderRadius: BorderRadius.only(
                  //         topLeft: Radius.circular(10),
                  //         topRight: Radius.circular(10),
                  //       ),
                  //     ),
                  //     child: Column(
                  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //       children: [
                  //         Align(
                  //           child: Text("Liste des point de depart"),
                  //           alignment: Alignment.topLeft,
                  //         ),
                  //         Obx(
                  //           () {
                  //             return SingleChildScrollView(
                  //               scrollDirection: Axis.horizontal,
                  //               child: Row(
                  //                 children: state.destinationPoints
                  //                     .map(
                  //                       (element) => Padding(
                  //                         padding: EdgeInsets.only(right: 5.0),
                  //                         child: CardCity(
                  //                           place: element,
                  //                           press: () {
                  //                             logic.deletePoint(element);
                  //                             setState(() {});
                  //                           },
                  //                         ),
                  //                       ),
                  //                     )
                  //                     .toList(),
                  //               ),
                  //             );
                  //           },
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // )
                ],
              );
            },
          ),
          Positioned(
            right: 10,
            bottom: 100,
            child: Container(
              width: 30,
              height: 500,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Obx(() {
                return SfSlider.vertical(
                  min: state.minZoom.value,
                  max: state.maxZoom.value,
                  value: state.zoom.value,
                  interval: 5,
                  showTicks: true,
                  // showLabels: true,
                  //  showTooltip: true,
                  minorTicksPerInterval: 1,
                  onChanged: (dynamic value) {
                    print(value);
                    state.zoom.value = value.round();
                    print("change values");
                  },
                );
              }),
            ),
          ),
          // Positioned(
          //   bottom: 40,
          //   right: 10,
          //   child: GestureDetector(
          //     onTap: _handlePressButton,
          //     child: Container(
          //       padding: EdgeInsets.all(4),
          //       height: 50,
          //       width: 50,
          //       decoration: BoxDecoration(
          //         borderRadius: BorderRadius.circular(40),
          //         color: Colors.white,
          //       ),
          //       child: Container(
          //         height: 40,
          //         width: 40,
          //         decoration: BoxDecoration(
          //           borderRadius: BorderRadius.circular(40),
          //           color: AppColor.primary,
          //         ),
          //         child: Icon(
          //           Icons.add,
          //           color: Colors.white,
          //         ),
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget getContent() {
    return Expanded(
      flex: 18,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            buildTitle(),
            SizedBox(
              height: 10,
            ),
            buildName(),
            SizedBox(
              height: 10,
            ),
            buildSurname(),
            SizedBox(
              height: 10,
            ),
            buildPhone(),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: state.describeController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Entrez une description de la carte',
              ),
              maxLines: 5,
            ),
          ],
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
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: logic.userNameError,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Entrez votre nom',
            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          ),
        );
      },
    );
  }

  Widget buildTitle() {
    return ValueListenableBuilder(
      // Note: pass _controller to the animation argument
      valueListenable: state.titleController,
      builder: (context, TextEditingValue value, __) {
        // this entire widget tree will rebuild every time
        // the controller value changes
        return TextFormField(
          controller: state.titleController,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: logic.userTitleError,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Entrez le titre de la map. Ex: Plan de localsation',
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
          validator: logic.userPhoneError,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Entrez le numero de telephone',
            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          ),
        );
      },
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
          validator: logic.userSurnameError,
          decoration: InputDecoration(
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
    return Obx(() {
      return ElevatedButton(
          onPressed: () async {
            if (!state.mapLoad.value) {
              if (logic.userPhoneError(state.phoneController.text) == null &&
                  logic.userNameError(state.nameController.text) == null &&
                  logic.userSurnameError(state.surnameController.text) ==
                      null &&
                  logic.userTitleError(state.titleController.text) == null) {
                await logic.printMap();
              }
              Get.back();
            }
          },
          child: state.mapLoad.value
              ? Padding(
                  padding: EdgeInsets.all(5),
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                )
              : Text("Imprimer"));
    });
  }

  Widget cancelBtn() {
    return ElevatedButton(
        onPressed: () {
          Get.back();
        },
        child: Text("Annuler"));
  }

  Future<void> displayPrediction(Prediction? p, BuildContext context) async {
    if (p != null) {
      // get detail (lat/lng)
      GoogleMapsPlaces _places = GoogleMapsPlaces(
        apiKey: state.API_KEY,
        apiHeaders: await const GoogleApiHeaders().getHeaders(),
      );
      PlacesDetailsResponse detail =
          await _places.getDetailsByPlaceId(p.placeId!);
      final lat = detail.result.geometry!.location.lat;
      final lng = detail.result.geometry!.location.lng;

      logic.generatePoint(detail.result);

      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text("${p.description} - $lat/$lng")),
      // );
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
      apiKey: state.API_KEY,
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

class CardCity extends StatelessWidget {
  const CardCity({
    Key? key,
    required this.place,
    required this.press,
  }) : super(key: key);
  final PlaceDetails place;
  final Function()? press;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.green),
        borderRadius: BorderRadius.circular(10),
        boxShadow: AppShadow.boxShadow,
      ),
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: 2,
          horizontal: 5,
        ),
        decoration: BoxDecoration(
          color: Colors.green.withOpacity(0.01),
        ),
        child: Row(
          children: [
            Text(
              place.name,
              style: TextStyle(color: Colors.green),
            ),
            SizedBox(
              width: 5,
            ),
            GestureDetector(
              onTap: press,
              child: Icon(
                Icons.close,
                color: Colors.green,
                size: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
