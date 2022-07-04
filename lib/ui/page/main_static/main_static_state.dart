part of main_static;

class MainStaticState {
  String API_KEY = "AIzaSyDMvPHsbM0l51gW4shfWTHMUD-8Df-2UKU";
  // generate point
  late GoogleMapPolyline googleMapPolyline;

  // this tab content list of path
  late RxList<static_map.Path> paths;
  // this is list of marker
  late RxList<static_map.Marker> markers;
  // This is origin point
  RxList<PlaceDetails> destinationPoints = <PlaceDetails>[].obs;

  // this is zoom value
  RxInt zoom = 17.obs;
  RxInt minZoom = 17.obs;
  RxInt maxZoom = 30.obs;
  // Radius for point
  RxInt radiusOrigin = 150.obs;
  RxInt radiusDest = 120.obs;

  RxBool mapLoad = false.obs;

  late TextEditingController titleController;
  late TextEditingController nameController;
  late TextEditingController surnameController;
  late TextEditingController phoneController;
  late TextEditingController describeController;

  late pw.Document pdf;

  // This is origin point
  late gm.LatLng originPoint;

  // Verify if generate point is load
  var isLoadingGeneratePoint = false.obs;

  MainStaticState() {
    googleMapPolyline = GoogleMapPolyline(apiKey: API_KEY);
    paths = <static_map.Path>[].obs;
    markers = <static_map.Marker>[].obs;
    pdf = pw.Document();

    titleController = TextEditingController();
    nameController = TextEditingController();
    surnameController = TextEditingController();
    phoneController = TextEditingController();
    describeController = TextEditingController();
  }
}
