part of main_static;

class MainStaticLogic extends GetxController {
  final MainStaticState state = MainStaticState();

  MainStaticLogic({required gm.LatLng originPoint}) {
    state.originPoint = originPoint;
  }

  @override
  onInit() {
    //Make green circle for origin place
    state.paths.add(
      static_map.Path.circle(
        center: static_map.Location(
            state.originPoint.latitude, state.originPoint.longitude),
        color: Colors.green.withOpacity(0.8),
        fillColor: Colors.green.withOpacity(0.4),
        encoded: true, // encode using encoded polyline algorithm
        radius: 150, // meters
      ),
    );

    // configure origin marker
    state.markers.value.add(
      static_map.Marker(
        locations: [
          static_map.Location(
              state.originPoint.latitude, state.originPoint.longitude),
        ],
        color: Colors.green,
        label: "A",
      ),
    );
  }

  generatePoint(PlaceDetails destinationDetail) async {
    // load generate point is true
    state.isLoadingGeneratePoint(true);
    if (destinationDetail.geometry == null) return;

    gm.LatLng destinationPoint = gm.LatLng(
        destinationDetail.geometry!.location.lat,
        destinationDetail.geometry!.location.lng);

    await state.googleMapPolyline
        .getCoordinatesWithLocation(
      origin: state.originPoint,
      destination: destinationPoint,
      mode: RouteMode.driving,
    )
        .then((value) {
      // load generate point is false
      state.isLoadingGeneratePoint(false);

      // Configure path color type and origin point
      var path = static_map.Path(
        color: Colors.blue,
        points: [
          static_map.Location(
              state.originPoint.latitude, state.originPoint.longitude),
        ],
      );

      // add all point for this distance in location
      for (var i = 1; i < value!.length - 1; i++) {
        print(value[i]);
        path.points
            .add(static_map.Location(value[i].latitude, value[i].longitude));
      }

      // add destinantion point
      path.points.add(
        static_map.Location(
          destinationDetail.geometry!.location.lat,
          destinationDetail.geometry!.location.lng,
        ),
      );
      print("L'index est =====> ${path.points.indexOf(static_map.Location(
        destinationDetail.geometry!.location.lat,
        destinationDetail.geometry!.location.lng,
      ))}");

      // configure destination marker
      state.markers.value.add(
        static_map.Marker(
          locations: [
            static_map.Location(
              destinationPoint.latitude,
              destinationPoint.longitude,
            ),
          ],
          color: Colors.cyan,
          label: "D",
        ),
      );

      //Make cyan circle for destination place
      state.paths.add(
        static_map.Path.circle(
          center: static_map.Location(
              destinationPoint.latitude, destinationPoint.longitude),
          color: Colors.blue.withOpacity(0.8),
          fillColor: Colors.blue.withOpacity(0.4),
          encoded: true, // encode using encoded polyline algorithm
          radius: 120, // meters
        ),
      );

      // // add destination points
      // var location = Location(
      //   lat: destinationPoint.latitude,
      //   lng: destinationPoint.longitude,
      // );
      // var destinationDetails = PlaceDetails(
      //   name: destinationDetail.name,
      //   placeId: destinationDetail.placeId,
      //   geometry: Geometry(
      //     location: location,
      //   ),
      // );

      state.destinationPoints.add(destinationDetail);

      // Add path on list of path
      state.paths.add(path);
    }).catchError((error) {
      // load generate point is false
      state.isLoadingGeneratePoint(false);
      print(error.toString());
    });
    ;
  }

  deletePoint(PlaceDetails destinationDetail) async {
    var destinationDetailLocation = static_map.Location(
        destinationDetail.geometry!.location.lat,
        destinationDetail.geometry!.location.lng);
    // loop all path

    // state.paths.forEach((path) {
    //   var current_location = path.points.last as static_map.Location;
    //   if (current_location == destinationDetailLocation) {
    //     print("salut");
    //     state.paths.remove(path);
    //   }

    //   if (path.runtimeType == "CirclePath") {
    //     static_map.CirclePath path_round = path as static_map.CirclePath;
    //     print("Point de rancontre");
    //     if (path_round.center == destinationDetailLocation) {
    //       state.paths.remove(path_round);
    //     }
    //   }
    // });

    // Remove route
    state.paths.removeWhere((path) {
      var current_location = path.points.last as static_map.Location;
      return current_location == destinationDetailLocation;
    });

    // Remove radius
    state.paths.removeWhere((path) {
      try {
        static_map.CirclePath path_round = path as static_map.CirclePath;
        return path_round.center == destinationDetailLocation;
      } catch (e) {
        return false;
      }
    });

    // Remove marker
    state.markers.removeWhere((mark) {
      static_map.Location location =
          mark.locations.first as static_map.Location;
      return location == destinationDetailLocation;
    });

    // Remove in destination point
    state.destinationPoints
        .removeWhere((location) => location == destinationDetail);
  }

  printMap() async {
    var controller = static_map.StaticMapController(
      center: static_map.Location(
          state.originPoint.latitude, state.originPoint.longitude),
      googleApiKey: state.API_KEY,
      width: 3508,
      height: 3508,
      // scaleToDevicePixelRatio: true,
      zoom: state.zoom.value,
      paths: state.paths,
      markers: state.markers,
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
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
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
                        pw.Row(
                          children: [
                            pw.Text("Nom: "),
                            pw.Text(
                              "delano Roosvelt",
                              style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        pw.Row(
                          children: [
                            pw.Text("Prenom: "),
                            pw.Text(
                              "delano Roosvelt",
                              style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        pw.Row(
                          children: [
                            pw.Text("Telephone: "),
                            pw.Text(
                              "6 76 19 87 45",
                              style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        pw.Row(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text("Description: "),
                            pw.Expanded(
                              child: pw.Text(
                                "delano Roosvelt daskbl da sjds a;lkcalbv fl ;svfskjv ldabkjbvs dfjklsbvlkf jdsb lvkflsdjv bfd;sv f dl;svdf sd;s lfdblfds;lbk",
                                style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold,
                                ),
                                softWrap: true,
                              ),
                            ),
                          ],
                        ),
                        pw.CustomPaint(
                          size: const PdfPoint(10, 10),
                          painter: (PdfGraphics canvas, PdfPoint size) {
                            canvas
                              ..moveTo(0, 0)
                              ..lineTo(350, 0)
                              ..setColor(PdfColors.grey200)
                              ..strokePath();
                          },
                        ),
                        pw.SizedBox(
                          height: 10,
                        ),
                        pw.Text(
                          "Legende",
                          style: pw.TextStyle(
                            fontSize: 20,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                        pw.SizedBox(
                          height: 10,
                        ),
                        pw.Row(
                          crossAxisAlignment: pw.CrossAxisAlignment.center,
                          children: [
                            pw.Container(
                              color: PdfColors.green,
                              height: 10,
                              width: 10,
                            ),
                            pw.Expanded(
                              child: pw.Text(
                                "  Point d'arrivé (A)",
                                style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold,
                                ),
                                softWrap: true,
                              ),
                            ),
                          ],
                        ),
                        pw.Row(
                          crossAxisAlignment: pw.CrossAxisAlignment.center,
                          children: [
                            pw.Container(
                              color: PdfColors.blue,
                              height: 10,
                              width: 10,
                            ),
                            pw.Expanded(
                              child: pw.Text(
                                "  Point de départ (D)",
                                style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold,
                                ),
                                softWrap: true,
                              ),
                            ),
                          ],
                        ),
                        pw.Row(
                          crossAxisAlignment: pw.CrossAxisAlignment.center,
                          children: [
                            pw.Padding(
                              padding: pw.EdgeInsets.only(
                                bottom: 20,
                              ),
                            ),
                            pw.CustomPaint(
                              size: const PdfPoint(10, 10),
                              painter: (PdfGraphics canvas, PdfPoint size) {
                                canvas
                                  ..moveTo(0, 0)
                                  ..lineTo(10, 0)
                                  ..setColor(PdfColors.blue)
                                  ..strokePath();
                              },
                            ),
                            pw.Expanded(
                              child: pw.Text(
                                "  Chemin a suivre",
                                style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold,
                                ),
                                softWrap: true,
                              ),
                            ),
                          ],
                        ),
                        pw.CustomPaint(
                          size: const PdfPoint(10, 10),
                          painter: (PdfGraphics canvas, PdfPoint size) {
                            canvas
                              ..moveTo(0, 0)
                              ..lineTo(350, 0)
                              ..setColor(PdfColors.grey200)
                              ..strokePath();
                          },
                        ),
                        pw.SizedBox(
                          height: 20,
                        ),
                        pw.Align(
                          alignment: pw.Alignment.center,
                          child: pw.BarcodeWidget(
                            data:
                                "{'lat': ${state.originPoint.latitude}, 'lng': ${state.originPoint.longitude}}",
                            barcode: pw.Barcode.qrCode(),
                            width: 200,
                            height: 100,
                          ),
                        ),
                        pw.SizedBox(
                          height: 20,
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
      file.writeAsBytes(await document.save()).then((value) {
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
}
