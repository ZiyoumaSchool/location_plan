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

      state.position.value = Marker(
        markerId: MarkerId("current_position"),
        infoWindow: InfoWindow(
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

  Future<Null> displayPrediction(Prediction p) async {
    print("delano roosvelt");

    if (p != null) {
      PlacesDetailsResponse detail =
          await state.places.getDetailsByPlaceId(p.placeId!);

      var placeId = p.placeId;
      if (detail.result.geometry != null) {
        state.currentPos.value = LatLng(detail.result.geometry!.location.lat,
            detail.result.geometry!.location.lng);
      }

      // var address = await Geocoder.local.findAddressesFromQuery(p.description);
      print(state.currentPos.value);
      update();
    }
  }
}
