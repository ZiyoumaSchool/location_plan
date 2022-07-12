part of histry_page;

class HistryState {
  final RxString dbName = 'location'.obs;
  final RxString search = ''.obs;
  final RxList locations = [].obs;
  final TextEditingController searchInputController = TextEditingController();

  final storage = GetStorage();

  var box = Hive.box('location');

  RxBool isFirstListPlan = false.obs;
  HistryState() {
    isFirstListPlan.value = storage.read('isFirstListPlan') ?? true;
  }
}
