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
