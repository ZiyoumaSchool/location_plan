library view_pdf;

import 'dart:async';
import 'dart:io';

// import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:get/get.dart';
import 'package:localise/common/app_color.dart';
import 'package:localise/router/router.dart';
import 'package:share_plus/share_plus.dart';
// import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

part 'view_pdf_logic.dart';
part 'view_pdf_state.dart';

class ViewPDFgPage extends StatefulWidget {
  ViewPDFgPage({Key? key}) : super(key: key);

  @override
  State<ViewPDFgPage> createState() => _ViewPDFgPageState();
}

class _ViewPDFgPageState extends State<ViewPDFgPage> {
  final logic = Get.put(ViewPDFLogic());

  final state = Get.find<ViewPDFLogic>().state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            // SfPdfVie
            // SfPdfViewer.asset(Get.arguments["file"] as String),
            //   Obx(() {
            //     return Container(
            //       child: state.isLoading.value
            //           ? Center(child: CircularProgressIndicator())
            //           : PDFViewer(
            //               document: state.doc!,
            //               zoomSteps: 1,
            //             ),
            //     );
            //   }),
            PDFView(
              filePath: Get.arguments["file"] as String,
              enableSwipe: true,
              swipeHorizontal: true,
              autoSpacing: false,
              pageFling: false,
              onRender: (_pages) {
                // setState(() {
                //   pages = _pages;
                //   isReady = true;
                // });
              },
              onError: (error) {
                print(error.toString());
              },
              onPageError: (page, error) {
                print('$page: ${error.toString()}');
              },
              // onViewCreated: (pdfViewController) {
              //   _controller.complete(pdfViewController);
              // },
              onPageChanged: (page, total) {
                print('page change: $page/$total');
              },
            ),

            Positioned(
              bottom: 20,
              right: 10,
              child: GestureDetector(
                onTap: () {
                  Get.offAllNamed(RouteConfig.histoy);
                },
                child: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    // color: AppColor.primary,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.close,
                    color: AppColor.primary,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 20,
              left: 10,
              // bottom: MediaQuery.of(context).size.height / 2,
              child: GestureDetector(
                onTap: () async {
                  await shareFile(Get.arguments["file"] as String);
                },
                child: Container(
                  height: 50,
                  width: 50,
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.share,
                    color: Colors.green,
                    size: 30,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> shareFile(String path) async {
    await Share.shareFiles([path], text: 'Partager le plan de localisation');
  }
}
