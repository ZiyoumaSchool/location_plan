library main_static;

import 'dart:io';
import 'dart:math';

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
      originPoint: gm.LatLng(3.8567078373302763, 11.49633987211502),
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
              await logic.printMap();
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
                  Expanded(
                    flex: 2,
                    child: Container(
                      // height: 100,
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Align(
                            child: Text("Liste des point de depart"),
                            alignment: Alignment.topLeft,
                          ),
                          Obx(
                            () {
                              return SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: state.destinationPoints
                                      .map(
                                        (element) => Padding(
                                          padding: EdgeInsets.only(right: 5.0),
                                          child: CardCity(
                                            place: element,
                                            press: () {
                                              logic.deletePoint(element);
                                              setState(() {});
                                            },
                                          ),
                                        ),
                                      )
                                      .toList(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  )
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
          Positioned(
            bottom: 40,
            right: 10,
            child: GestureDetector(
              onTap: _handlePressButton,
              child: Container(
                padding: EdgeInsets.all(4),
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  color: Colors.white,
                ),
                child: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    color: AppColor.primary,
                  ),
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
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
