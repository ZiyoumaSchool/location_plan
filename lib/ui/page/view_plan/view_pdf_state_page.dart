library view_pdf;

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

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
            Container(
              child: PDFView(
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
            ),
            Positioned(
              left: 10,
              bottom: MediaQuery.of(context).size.height / 2,
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
