part of histry_page;

class HistryState {
  final RxString dbName = 'location'.obs;
  final RxString search = ''.obs;
  final RxList locations = [].obs;
  final TextEditingController searchInputController = TextEditingController();

  var box = Hive.box('location');

  HistryState();
}
