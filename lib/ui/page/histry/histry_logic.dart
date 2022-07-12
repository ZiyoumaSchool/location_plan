part of histry_page;

class HistryLogic extends GetxController {
  final HistryState state = HistryState();

  @override
  void onClose() {
    // TODO: implement onClose
    state.storage.write("isFirstListPlan", false);
    state.isFirstListPlan.value = false;
    super.onClose();
  }

  Future getLocation() async {
    Box box;

    try {
      box = Hive.box(state.dbName.value);
    } catch (error) {
      box = await Hive.openBox(state.dbName.value);
      // ignore: avoid_print
      print(error);
    }

    var allLocations = box.get(state.dbName.value);
    if (allLocations != null) state.locations.value = allLocations;
  }

  deleteLocationByIndex(int index) {
    final locationsBox = Hive.box(state.dbName.value);
    locationsBox.deleteAt(index);
  }

  getLocationByIndex(int index) {
    final locationsBox = Hive.box(state.dbName.value);
    return locationsBox.getAt(index) as LocationMap;
  }

  String getTitle(LocationMap location) {
    if (location.name! + location.surname! + location.phone! == "") {
      return "Plan de localisation";
    } else {
      return location.name! + " " + location.surname! + " " + location.phone!;
    }
  }

  Future<void> shareFile(String path) async {
    await Share.shareFiles([path], text: 'Partager le plan de localisation');
  }

  Future<Object> deleteFile(String path) async {
    var file = File(path);
    try {
      return await file.delete();
    } catch (e) {
      return 0;
    }
  }
}
