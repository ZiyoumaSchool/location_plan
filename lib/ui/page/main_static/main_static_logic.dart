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

    String url = controller.url.toString();
    final netImage = await networkImage(url);

    print(url);

    var document = pw.Document();
    document.addPage(
      pw.Page(
        pageTheme: pw.PageTheme(
          orientation: pw.PageOrientation.landscape,
          theme: pw.ThemeData.withFont(
            base: await PdfGoogleFonts.openSansRegular(),
            bold: await PdfGoogleFonts.openSansBold(),
          ),
          // buildForeground: bg == null
          //     ? null
          //     : (context) =>
          //         pw.FullPage(ignoreMargins: true, child: pw.SvgImage(svg: bg!)),
        ),
        build: (context) => pw.Padding(
          padding: const pw.EdgeInsets.only(right: 20),
          child: pw.Container(
            height: 1000,
            width: 700,
            child: pw.Column(
              children: [
                pw.Align(
                    child: pw.Text("delano Roosvelt"),
                    alignment: pw.Alignment.topCenter),
                pw.Row(
                  children: [
                    pw.Column(
                      children: [
                        pw.Text("delano Roosvelt"),
                        pw.Text("delano Roosvelt"),
                        pw.Text("delano Roosvelt"),
                        pw.Text("delano Roosvelt"),
                        pw.Text("delano Roosvelt"),
                      ],
                    ),
                    pw.Image(netImage),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );

    // state.pdf.addPage(
    //   pw.Page(
    //     build: (pw.Context context) {
    //       return pw.Center(
    //         child: pw.Image(netImage),
    //       ); // Center
    //     },
    //   ),
    // ); // Page

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
    // });
  }
}
