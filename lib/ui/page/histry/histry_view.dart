library histry_page;

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:localise/common/app_color.dart';
import 'package:localise/common/app_image.dart';
import 'package:localise/router/router.dart';
import 'package:localise/ui/models/location.dart';
import 'package:share_plus/share_plus.dart';

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

  @override
  Widget build(BuildContext context) {
    state.searchInputController.addListener(() {
      state.search.value = state.searchInputController.text;
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
                    Get.toNamed(
                      RouteConfig.view_plan,
                      arguments: {
                        "file": location.path,
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
