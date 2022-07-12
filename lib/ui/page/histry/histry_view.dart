library histry_page;

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:localise/common/app_color.dart';
import 'package:localise/common/app_image.dart';
import 'package:localise/router/router.dart';
import 'package:localise/ui/models/location.dart';
import 'package:share_plus/share_plus.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

part 'histry_logic.dart';
part 'histry_state.dart';

class HistryPage extends StatefulWidget {
  const HistryPage({Key? key}) : super(key: key);

  @override
  State<HistryPage> createState() => _HistryPageState();
}

class _HistryPageState extends State<HistryPage> {
  final logic = Get.put(HistryLogic());

  final state = Get.find<HistryLogic>().state;

  late TutorialCoachMark tutorialCoachMark;
  List<TargetFocus> targets = <TargetFocus>[];
  GlobalKey key_add = GlobalKey();
  GlobalKey key_search_button = GlobalKey();

  @override
  void initState() {
    // TODO: implement initState
    initTarget();
    super.initState();
  }

  void initTarget() {
    targets.add(
      TargetFocus(
        identify: "Target 4",
        keyTarget: key_search_button,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            child: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Chercher un plan ",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 20.0),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Text(
                      "Chercher un plan de localisation a partir de sa description, le nom, le prenom, le numero de telephone,...",
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
        shape: ShapeLightFocus.RRect,
      ),
    );

    targets.add(TargetFocus(
      identify: "Target 1",
      keyTarget: key_add,
      contents: [
        TargetContent(
          align: ContentAlign.top,
          child: Container(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: Text(
                    "Ajouter",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0),
                  ),
                ),
                Text(
                  "Cliquez pour créer un nouveau plan de localisation.",
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ],
      radius: 10,
      shape: ShapeLightFocus.Circle,
    ));
  }

  void showTutorial() {
    tutorialCoachMark = TutorialCoachMark(
      context,
      targets: targets,
      colorShadow: AppColor.primary,
      textSkip: "",
      paddingFocus: 10,
      opacityShadow: 0.8,
      onFinish: () {
        print("finish");

        state.storage.write("isFirstListPlan", false);
        state.isFirstListPlan.value = false;
      },
      onClickTarget: (target) {
        print('onClickTarget: $target');
      },
      onSkip: () {
        print("skip");
      },
      onClickOverlay: (target) {
        print('onClickOverlay: $target');
      },
    )..show();
  }

  @override
  Widget build(BuildContext context) {
    if (state.isFirstListPlan.value) {
      showTutorial();
    }
    state.searchInputController.addListener(() {
      state.search.value = state.searchInputController.text;
      setState(() {
        print("delano");
      });
    });
    return Scaffold(
      appBar: AppBar(
        leading: Image.asset(AppImage.logo_png),
        title: const Text("Mes plans"),
        elevation: 0,
      ),
      backgroundColor: Colors.blueGrey[50],
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppImage.maps),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                height: 45,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(32),
                ),
                child: TextFormField(
                  key: key_search_button,
                  controller: state.searchInputController,
                  decoration: const InputDecoration(
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    hintText: 'Cherchez une carte...',
                    prefixIcon: Icon(
                      Icons.search,
                      color: AppColor.primary,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                child: _buildListView(),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.85),
                ),
              ),
            ), // NewContactForm(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        key: key_add,
        backgroundColor: AppColor.primary,
        onPressed: () {
          Get.toNamed(RouteConfig.main);
        },
        child: const Icon(
          Icons.add,
        ),
      ),
    );
  }

  Widget _buildListView() {
    return ValueListenableBuilder(
      valueListenable: Hive.box(state.dbName.string).listenable(),
      builder: (context, Box locationsBox, _) {
        return ListView.builder(
          itemCount: locationsBox.length,
          itemBuilder: (context, index) {
            return Obx(() {
              final location = logic.getLocationByIndex(index);

              String text = state.searchInputController.text;
              String value =
                  location.name! + location.surname! + location.phone!;
              print(
                  "================================================================>");
              if (text.isNotEmpty) {
                if (value.toLowerCase().contains(text.toLowerCase())) {
                  print("Val are solved");
                } else {
                  return Container();
                }
              }
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: GestureDetector(
                  onTap: () {
                    print("===========+>  ${location.path}");
                    FocusScope.of(context).unfocus();

                    Timer(
                      const Duration(milliseconds: 100),
                      () {
                        Get.toNamed(
                          RouteConfig.view_plan,
                          arguments: {
                            "file": location.path,
                          },
                        );
                      },
                    );
                  },
                  child: Container(
                    color: Colors.white.withOpacity(0.99),
                    child: ListTile(
                      title: Text(logic.getTitle(location)),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 7,
                          ),
                          Text(
                            logic.getTitle(location),
                            style: const TextStyle(
                              overflow: TextOverflow.ellipsis,
                            ),
                            textAlign: TextAlign.start,
                            maxLines: 2,
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              const Text(
                                "Chemin: ",
                                style: TextStyle(
                                  overflow: TextOverflow.fade,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  "${location.path}",
                                  style: const TextStyle(
                                    overflow: TextOverflow.fade,
                                  ),
                                  softWrap: false,
                                  maxLines: 1,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          IconButton(
                            icon: const Icon(
                              Icons.share,
                              color: AppColor.primary,
                            ),
                            onPressed: () async {
                              await logic.shareFile(location.path);
                            },
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                            onPressed: () async {
                              await logic.deleteFile(location.path);
                              logic.deleteLocationByIndex(index);
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              );
            });
          },
        );
      },
    );
  }
}
