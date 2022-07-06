part of view_pdf;

class ViewPDFLogic extends GetxController {
  final ViewPDFState state = ViewPDFState();

  getDocument() async {
    state.isLoading(true);

// Load from file
    File file = File(Get.arguments["file"] as String);
// PDFDocument doc = await PDFDocument.fromFile(file);
    // PDFDocument.fromFile(file).then((value) {
    //   state.doc = value;
    //   state.isLoading(false);
    // });
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getDocument();
  }
}
