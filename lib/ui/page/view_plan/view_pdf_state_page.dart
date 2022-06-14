library view_pdf;

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:get/get.dart';

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
    );
  }
}
