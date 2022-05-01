part of main_page;

class MainState {
  late TextEditingController searchController;

  var kGoogleApiKey = "AIzaSyDMvPHsbM0l51gW4shfWTHMUD-8Df-2UKU";

  late GoogleMapsPlaces places;

  late Completer<GoogleMapController> mapController;
  late locate.Location location;
  late locate.LocationData currentPosition;
  late RxnDouble radius;

  Rx<Marker> position = Rx<Marker>(Marker(
    markerId: MarkerId("current_position"),
    infoWindow: InfoWindow(
      title: 'Zone selectioner',
      snippet: "Le plan va etre generer a partir de ce point",
    ),
  ));

  double maxValue = 25;
  double minValue = 13;

  double initAnimateMinValue = 5.69;
  double initAnimateMaxValue = 5.69;
  RxDouble initAnimateRadius = RxDouble(5.69);
  RxBool isInitAnimate = RxBool(false);

  Rx<LatLng> currentPos = Rx<LatLng>(
    LatLng(3.850761, 11.495295),
  );

  RxBool isLoadCurrentPosition = RxBool(false);
  RxBool hasAutoCompleteResult = RxBool(false);
  RxBool isLoadSearch = RxBool(false);
  // late Completer<GoogleMapController> mapController;

  late PageController controller;
  MainState() {
    places = GoogleMapsPlaces(apiKey: kGoogleApiKey);
    mapController = Completer();
    location = locate.Location();
    radius = RxnDouble(null);
    searchController = TextEditingController();
  }
}
