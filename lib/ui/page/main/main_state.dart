part of main_page;

class MainState {
  String API_KEY = "AIzaSyDMvPHsbM0l51gW4shfWTHMUD-8Df-2UKU";
  RxBool mapLoad = false.obs;

  final box = GetStorage();

  late GoogleMapController? gmMapController;

  late Uint8List? imageBytes;

  // generate point
  late GoogleMapPolyline googleMapPolyline;
  // this is list of marker
  late RxList<static_map.Marker> markers;
  // var currentMarker = Rx<static_map.Marker>();
  late Rx<static_map.Marker?> currentMarker;
// final Rx<YourObject?> yourObject = (null as YourObject?).obs;
  final RxString dbName = 'location'.obs;

  late TextEditingController titleController;
  late TextEditingController nameController;
  late TextEditingController surnameController;
  late TextEditingController phoneController;
  late TextEditingController describeController;

  var isVisible = true.obs;
  var key = GlobalKey();

  late PageController pageController;
  late double currentPageValue;

  File? image;

  late TextEditingController searchController;
  // late ScreenshotController screenshotController;

  late pw.Document pdf;

  var kGoogleApiKey = "AIzaSyDMvPHsbM0l51gW4shfWTHMUD-8Df-2UKU";

  late GoogleMapsPlaces places;

  late Completer<GoogleMapController> mapController;
  late locate.Location location;
  late locate.LocationData currentPosition;
  late RxnDouble radius;
  RxDouble percentZone = 100.0.obs;

  Rx<Marker> position = Rx<Marker>(const Marker(
    markerId: MarkerId("current_position"),
    infoWindow: InfoWindow(
      title: 'Zone selectioner',
      snippet: "Le plan va etre generer a partir de ce point",
    ),
  ));

  double maxValue = 25;
  double minValue = 17;

  double maxZoneValue = 100;
  double minZoneValue = 0;
  double initZoneValue = 100;

  double initAnimateMinValue = 5.69;
  double initAnimateMaxValue = 5.69;
  RxDouble initAnimateRadius = RxDouble(5.69);
  RxBool isInitAnimate = RxBool(false);

  Rx<LatLng> currentPos = Rx<LatLng>(
    const LatLng(3.850761, 11.495295),
  );

  RxBool isLoadCurrentPosition = RxBool(false);
  RxBool hasAutoCompleteResult = RxBool(false);
  RxBool isLoadSearch = RxBool(false);

  RxBool isFirstParam = false.obs;
  // late Completer<GoogleMapController> mapController;

  late PageController controller;
  MainState() {
    isFirstParam.value = box.read('isFirstParam') ?? true;

    currentMarker = Rx(null);

    googleMapPolyline = GoogleMapPolyline(apiKey: API_KEY);
    markers = <static_map.Marker>[].obs;

    places = GoogleMapsPlaces(apiKey: kGoogleApiKey);
    mapController = Completer();
    location = locate.Location();
    radius = RxnDouble(null);
    searchController = TextEditingController();
    pageController = PageController();
    currentPageValue = 0.0;
    // screenshotController = ScreenshotController();
    pdf = pw.Document();

    titleController = TextEditingController();
    nameController = TextEditingController();
    surnameController = TextEditingController();
    phoneController = TextEditingController();
    describeController = TextEditingController();
  }
}
