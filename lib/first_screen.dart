import 'dart:developer';

import 'package:device_apps/device_apps.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:share_app/models/app_model.dart';
import 'package:share_plus/share_plus.dart';
import 'package:animated_search_bar/animated_search_bar.dart';

class FirstScreen extends StatefulWidget {
  const FirstScreen({Key? key}) : super(key: key);

  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  List listApps = [];
  List searchList = [];
  List<String> selectedList = [];
  String deletedItem = '';
  bool loading = true;
  bool select = false;
  int counterOut = 0;
  var searchController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    void getApp() async {
      List _apps = await DeviceApps.getInstalledApplications(
          includeAppIcons: true, includeSystemApps: false);
      for (var app in _apps) {
        var item = AppModel(
          title: app.appName,
          package: app.packageName,
          icon: app.icon,
          apkFilePath: app.apkFilePath,
          isSelected: false,
        );
        listApps.add(item);
      }
      log('yup');
      if (listApps.isNotEmpty) {
        setState(() {
          loading = false;
        });
      }
    }

    getApp();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: () async {
        listApps.forEach((element) {
          element.isSelected = false;
        });
        searchList.forEach((element) {
          element.isSelected = false;
        });
        selectedList.clear();
        log('hi');
        if (select) {
          select = false;
          setState(() {});
          return false;
        }
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          toolbarHeight: height * 0.07,
          actions: [
            select
                ? GestureDetector(
                    onTap: () async {
                      select = false;
                      listApps.forEach((element) {
                        element.isSelected = false;
                      });
                      await Share.shareFiles(selectedList);
                      selectedList.clear();
                      setState(() {});
                    },
                    child: Padding(
                      padding: EdgeInsets.only(right: width * 0.04),
                      child: Icon(Icons.share_outlined),
                    ),
                  )
                : const Center(),
          ],
          title: AnimatedSearchBar(
            controller: searchController,
            label: 'beSharey',
            labelStyle: TextStyle(
              color: Colors.white,
              fontSize: width * 0.05,
              fontFamily: 'WorkSan',
            ),
            cursorColor: Colors.white,
            searchStyle: TextStyle(
                color: Colors.white,
                fontSize: width * 0.05,
                fontFamily: 'WorkSan'),
            searchDecoration: const InputDecoration(
                hintText: 'Search',
                hintStyle: TextStyle(color: Colors.white),
                alignLabelWithHint: true,
                fillColor: Colors.white,
                border: InputBorder.none),
            onChanged: (value) {
              searchList = listApps
                  .where((element) =>
                      element.title.toLowerCase().contains(value.toLowerCase()))
                  .toList();
              setState(() {});
              log(value);
            },
          ),
        ),
        drawer: Drawer(
          child: Column(
            children: [
              DrawerHeader(
                child: CircleAvatar(
                  child: Icon(
                    Icons.app_shortcut_outlined,
                    size: width * 0.2,
                  ),
                  radius: width * 0.3,
                ),
              ),
              SizedBox(
                height: height * 0.02,
              ),
              ListTile(
                onTap: () async {
                  final result = await FilePicker.platform.pickFiles(
                    allowMultiple: true,
                  );

                  final files =
                      result?.files.map((file) => file.path ?? '').toList();
                  if (files == null || files.isEmpty) {
                    return;
                  }
                  await Share.shareFiles(
                    files,
                  );
                  log('file');
                },
                leading: CircleAvatar(
                  child: Icon(
                    Icons.file_copy_outlined,
                    size: width * 0.05,
                    color: Colors.blueGrey,
                  ),
                  radius: width * 0.07,
                  backgroundColor: Colors.white,
                ),
                title: Text(
                  'Share File',
                  style:
                      TextStyle(fontSize: width * 0.04, fontFamily: 'WorkSan'),
                ),
              ),
              SizedBox(
                height: height - 300,
              ),
              Text(
                'dev: ammar345433@gmail.com',
                style: TextStyle(fontSize: width * 0.04, fontFamily: 'WorkSan'),
              ),
            ],
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            loading
                ? const Center(child: CircularProgressIndicator())
                : Expanded(
                    child: ListView.builder(
                      itemCount: searchController.text.isEmpty
                          ? listApps.length
                          : searchList.length,
                      itemBuilder: (context, index) => ListTile(
                        onLongPress: () {
                          select = true;
                          if (searchController.text.isEmpty) {
                            listApps[index].isSelected =
                                !listApps[index].isSelected;
                            if (listApps[index].isSelected) {
                              selectedList.add(listApps[index].apkFilePath);
                            } else {
                              selectedList.forEach((element) {
                                if (element == listApps[index].apkFilePath) {
                                  deletedItem = element;
                                }
                              });
                              selectedList.remove(deletedItem);
                            }
                          } else {
                            searchList[index].isSelected =
                                !searchList[index].isSelected;
                            if (searchList[index].isSelected) {
                              selectedList.add(searchList[index].apkFilePath);
                            } else {
                              selectedList.forEach((element) {
                                if (element == searchList[index].apkFilePath) {
                                  deletedItem = element;
                                }
                              });
                              selectedList.remove(deletedItem);
                            }
                          }
                          setState(() {});
                          log(index.toString() + ' selected');
                        },
                        onTap: () async {
                          if (select) {
                            if (searchController.text.isEmpty) {
                              listApps[index].isSelected =
                                  !listApps[index].isSelected;
                              if (listApps[index].isSelected) {
                                selectedList.add(listApps[index].apkFilePath);
                              } else {
                                selectedList.forEach((element) {
                                  if (element == listApps[index].apkFilePath) {
                                    deletedItem = element;
                                  }
                                });
                                selectedList.remove(deletedItem);
                              }
                            } else {
                              searchList[index].isSelected =
                                  !searchList[index].isSelected;
                              if (searchList[index].isSelected) {
                                selectedList.add(searchList[index].apkFilePath);
                              } else {
                                selectedList.forEach((element) {
                                  if (element ==
                                      searchList[index].apkFilePath) {
                                    deletedItem = element;
                                  }
                                });
                                selectedList.remove(deletedItem);
                              }
                            }
                          } else {
                            await Share.shareFiles(
                              [
                                searchController.text.isEmpty
                                    ? listApps[index].apkFilePath
                                    : searchList[index].apkFilePath
                              ],
                              text: searchController.text.isEmpty
                                  ? listApps[index].title
                                  : searchList[index].title,
                            );
                          }
                          setState(() {});
                          log(index.toString());
                          log(selectedList.toString());
                        },
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: width * 0.05, vertical: height * 0.01),
                        leading: Image.memory(searchController.text.isEmpty
                            ? listApps[index].icon
                            : searchList[index].icon),
                        title: Text(searchController.text.isEmpty
                            ? listApps[index].title
                            : searchList[index].title),
                        subtitle: Text(searchController.text.isEmpty
                            ? listApps[index].package
                            : searchList[index].package),
                        trailing: select
                            ? Icon(
                                listApps[index].isSelected
                                    ? Icons.check_box
                                    : Icons.check_box_outline_blank_rounded,
                                color: listApps[index].isSelected
                                    ? Colors.blue
                                    : Colors.blueGrey,
                              )
                            : null,
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
