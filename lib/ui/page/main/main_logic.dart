part of main_page;

class MainLogic extends GetxController {
  final MainState state = MainState();

  @override
  onInit() async {
    super.onInit();
    getCurrentPosition();
    // state.place_services
    //     .initialize(apiKey: "AIzaSyDMvPHsbM0l51gW4shfWTHMUD-8Df-2UKU");
  }

  getCurrentPosition() {
    state.isLoadCurrentPosition.value = true;
    state.location.getLocation().then((value) {
      print(value.toString());
      state.currentPos.value =
          LatLng(value.latitude ?? 3.850761, value.longitude ?? 11.495295);

      state.currentMarker.value = static_map.Marker.custom(
        anchor: static_map.MarkerAnchor.center,
        icon: "https://goo.gl/1oTJ9Y",
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
          snippet: "*",
        ),
        position: state.currentPos.value,
      );
      // state.currentPosition = value;
      state.isLoadCurrentPosition.value = false;
    }).catchError((onError) {
      print(onError.toString());
    });
  }

  printMap() async {
    state.mapLoad(true);

    var controller = static_map.StaticMapController(
      center: static_map.Location(
        state.currentPos.value.latitude,
        state.currentPos.value.longitude,
      ),
      googleApiKey: state.API_KEY,
      width: 3508,
      height: 3508,
      // scaleToDevicePixelRatio: true,
      zoom: state.radius.value!.round() ?? state.minValue.round(),
      // paths: state.paths,
      markers: [state.currentMarker.value!],
    );

    String mapUrl = controller.url.toString();
    String urlIcon =
        "https://ziyouma-agency.com/wp-content/uploads/2021/08/logo-site-header.png";

    final mapImage = await networkImage(mapUrl);
    final iconImage = await networkImage(urlIcon);

    var document = pw.Document();
    document.addPage(
      pw.Page(
        pageTheme: pw.PageTheme(
          orientation: pw.PageOrientation.landscape,
          theme: pw.ThemeData.withFont(
            base: await PdfGoogleFonts.openSansRegular(),
            bold: await PdfGoogleFonts.openSansBold(),
          ),
        ),
        build: (context) => pw.Padding(
          padding: const pw.EdgeInsets.all(5),
          child: pw.Column(
            children: [
              pw.Padding(
                padding: const pw.EdgeInsets.only(bottom: 20),
                child: pw.Align(
                  child: pw.Text(
                    "Plan de localisation",
                    style: pw.TextStyle(
                      fontSize: 25,
                      fontWeight: pw.FontWeight.bold,
                      decoration: pw.TextDecoration.underline,
                    ),
                  ),
                  alignment: pw.Alignment.topCenter,
                ),
              ),
              (state.nameController.text.isEmpty &&
                      state.surnameController.text.isEmpty &&
                      state.phoneController.text.isEmpty &&
                      state.describeController.text.isEmpty)
                  ? pw.Expanded(
                      child: pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: pw.CrossAxisAlignment.end,
                          children: [
                          // pw.Column(
                          //     mainAxisAlignment: pw.MainAxisAlignment.end,
                          //     children: [
                          // pw.Text(
                          //   "Scannez le code pour voir sur google map",
                          //   style: pw.TextStyle(
                          //     fontSize: 12,
                          //     // fontWeight: pw.FontWeight.bold,
                          //   ),
                          // ),
                          // pw.Align(
                          //   alignment: pw.Alignment.center,
                          //   child: pw.BarcodeWidget(
                          //     data:
                          //         "http://maps.google.com/maps?q=${state.currentPos.value.latitude},${state.currentPos.value.longitude}",
                          //     barcode: pw.Barcode.qrCode(),
                          //     width: 200,
                          //     height: 100,
                          //   ),
                          // ),
                          // pw.SizedBox(
                          //   height: 50,
                          // ),
                          //   pw.Image(
                          //     iconImage,
                          //     width: 60,
                          //   ),
                          // ]),

                          pw.Image(
                            iconImage,
                            width: 60,
                          ),
                          pw.SizedBox(
                            width: 50,
                          ),
                          pw.Column(children: [
                            pw.Image(
                              mapImage,
                              width: 400,
                            ),
                            pw.SizedBox(
                              height: 100,
                            ),
                          ]),

                          pw.Column(
                              mainAxisAlignment: pw.MainAxisAlignment.end,
                              children: [
                                pw.BarcodeWidget(
                                  data:
                                      "http://maps.google.com/maps?q=${state.currentPos.value.latitude},${state.currentPos.value.longitude}",
                                  barcode: pw.Barcode.qrCode(),
                                  width: 200,
                                  height: 100,
                                ),
                                pw.SizedBox(
                                  height: 5,
                                ),
                                pw.Text(
                                  "voir sur google map",
                                  style: pw.TextStyle(
                                    fontSize: 13,
                                  ),
                                ),
                              ]),
                        ]))
                  : pw.Row(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        if (!(state.nameController.text.isEmpty &&
                            state.surnameController.text.isEmpty &&
                            state.phoneController.text.isEmpty &&
                            state.describeController.text.isEmpty))
                          pw.Expanded(
                            flex: 1,
                            child: pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Text(
                                  "Information",
                                  style: pw.TextStyle(
                                    fontSize: 20,
                                    fontWeight: pw.FontWeight.bold,
                                  ),
                                ),
                                pw.SizedBox(
                                  height: 5,
                                ),
                                if (state.nameController.text.isNotEmpty)
                                  pw.Row(
                                    children: [
                                      pw.Text("Nom: "),
                                      pw.Text(
                                        state.nameController.text,
                                        style: pw.TextStyle(
                                          fontWeight: pw.FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                if (state.surnameController.text.isNotEmpty)
                                  pw.Row(
                                    children: [
                                      pw.Text("Prenom: "),
                                      pw.Text(
                                        state.surnameController.text,
                                        style: pw.TextStyle(
                                          fontWeight: pw.FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                if (state.phoneController.text.isNotEmpty)
                                  pw.Row(
                                    children: [
                                      pw.Text("Telephone: "),
                                      pw.Text(
                                        state.phoneController.text,
                                        style: pw.TextStyle(
                                          fontWeight: pw.FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                if (state.describeController.text.isNotEmpty)
                                  pw.Row(
                                    crossAxisAlignment:
                                        pw.CrossAxisAlignment.start,
                                    children: [
                                      pw.Text("Description: "),
                                      pw.Expanded(
                                        child: pw.Text(
                                          state.describeController.text,
                                          style: pw.TextStyle(
                                            fontWeight: pw.FontWeight.bold,
                                          ),
                                          softWrap: true,
                                        ),
                                      ),
                                    ],
                                  ),
                                pw.SizedBox(
                                  height: 80,
                                ),
                                pw.Align(
                                  alignment: pw.Alignment.center,
                                  child: pw.BarcodeWidget(
                                    data:
                                        "http://maps.google.com/maps?q=${state.currentPos.value.latitude},${state.currentPos.value.longitude}",
                                    barcode: pw.Barcode.qrCode(),
                                    width: 200,
                                    height: 100,
                                  ),
                                ),
                                pw.SizedBox(
                                  height: 100,
                                ),
                                pw.Image(
                                  iconImage,
                                  width: 60,
                                ),
                              ],
                            ),
                          ),
                        pw.Expanded(
                          child: pw.Image(
                            mapImage,
                            width: 350,
                          ),
                        ),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );

    Directory appDocDirectory = await getApplicationDocumentsDirectory();

    Directory(appDocDirectory.path + '/' + 'data').create(recursive: true)
        // The created directory is returned as a Future.
        .then((Directory directory) async {
      print('Path of New Dir: ' + directory.path);

      final file = await File(
              "${directory.path}/${DateTime.now().millisecondsSinceEpoch.toString()}.pdf")
          .create();
      // state.pdf.save().then((value) {
      // print(value);
      await file.writeAsBytes(await document.save()).then((value) {
        state.mapLoad(false);
        Get.toNamed(
          RouteConfig.view_plan,
          arguments: {
            "file": file.path,
          },
        );
      });
    }).catchError((error) {
      print(error.toString());
    });
  }

  String? userNameError(String? value) {
    final text = value;

    if (text!.isEmpty) {
      return "Le champ nom est obligatoire";
    }

    return null;
  }

  String? userSurnameError(String? value) {
    final text = value;

    if (text!.isEmpty) {
      return "Le champ prenom est obligatoire";
    }

    return null;
  }

  String? userTitleError(String? value) {
    final text = value;

    if (text!.isEmpty) {
      return "Le champ titre est obligatoire";
    }

    if (text.length < 5) {
      return "Le champ titre doit avoir plus de 5 caracteres";
    }

    return null;
  }

  String? userPhoneError(String? value) {
    final text = value;

    if (text!.isEmpty) {
      return "Le champ numero est obligatoire";
    }
    final RegExp regExp = RegExp("(6|2)(2|3|[5-9])[0-9]{7}");

    if (!regExp.hasMatch(text)) {
      return "Le numero de telephone est invalide";
    }

    return null;
  }

  void incrementZone() {
    if (state.percentZone.value + 1 < state.maxZoneValue) {
      state.percentZone.value++;
      print(state.percentZone.value);
    }
  }

  void decrementZone() {
    print(state.percentZone.value - 1 > state.minZoneValue);
    if (state.percentZone.value - 1 > state.minZoneValue) {
      state.percentZone.value--;
      print(state.percentZone.value);
    }
  }
}
