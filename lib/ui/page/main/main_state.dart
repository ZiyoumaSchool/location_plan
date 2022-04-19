part of main_page;

class MainState {
  PlacesService place_services = PlacesService();
  var listAutoComplete =
      List<PlacesAutoCompleteResult>.empty(growable: true).obs;

  late Completer<GoogleMapController> mapController;
  late Location location;
  late LocationData currentPosition;
  late RxnDouble radius;

  Rx<Marker> position = Rx<Marker>(Marker(
    markerId: MarkerId("current_position"),
    infoWindow: InfoWindow(
      title: 'Zone selectioner',
      snippet: "Le plan va etre generer a partir de ce point",
    ),
  ));

  double maxValue = 25;
  double minValue = 15;

  double initAnimateMinValue = 5.69;
  double initAnimateMaxValue = 5.69;
  RxDouble initAnimateRadius = RxDouble(5.69);
  RxBool isInitAnimate = RxBool(false);

  Rx<LatLng> currentPos = Rx<LatLng>(
    LatLng(3.850761, 11.495295),
  );

  RxBool isLoadCurrentPosition = RxBool(false);
  RxBool hasAutoCompleteResult = RxBool(false);
  // late Completer<GoogleMapController> mapController;

  late PageController controller;
  MainState() {
    mapController = Completer();
    location = Location();
    radius = RxnDouble(null);
  }
}
