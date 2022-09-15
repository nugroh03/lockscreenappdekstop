import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lockscreenapp/home.dart';
import 'package:lockscreenapp/models/setting_models.dart';
import 'package:lockscreenapp/themes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:window_manager/window_manager.dart';

class SettingPage extends StatefulWidget {
  SettingPage({Key? key}) : super(key: key);

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  TextEditingController text1Controller = TextEditingController(text: "");
  TextEditingController text2Controller = TextEditingController(text: "");
  TextEditingController text3Controller = TextEditingController(text: "");
  TextEditingController imageController = TextEditingController(text: "");

  Future<SharedPreferences> _settingPrefs = SharedPreferences.getInstance();

  bool isEdit = false;

  String image = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getView();
    getSetting();
  }

  getView() async {
    await windowManager.setAlwaysOnTop(false);
    await windowManager.setSkipTaskbar(false);
  }

  getSetting() async {
    final SharedPreferences prefs = await _settingPrefs;

    final String? dataSetting = prefs.getString('setting');
    print(dataSetting.toString());
    if (dataSetting != null && dataSetting != "") {
      SettingModel data = SettingModel.fromJson(jsonDecode(dataSetting));

      setState(() {
        text1Controller.text = data.text1;
        text2Controller.text = data.text2;
        text3Controller.text = data.text3;
        image = data.image;
      });
    } else {
      print("data kosong");
      // SettingModel settingdata = SettingModel(
      //     text1: defaulttext1,
      //     text2: defaulttext2,
      //     text3: defaulttext3,
      //     image: defaultimage);

      // await prefs.setString('setting', jsonEncode(settingdata));

      // setState(() {
      //   setting = settingdata;
      //   isInitial = false;
      // });
    }
  }

  void handleSave() async {
    final SharedPreferences prefs = await _settingPrefs;

    await prefs
        .setString(
            'setting',
            jsonEncode(SettingModel(
                text1: text1Controller.text,
                text2: text2Controller.text,
                text3: text3Controller.text,
                image: image)))
        .then((value) {
      setState(() {
        isEdit = !isEdit;
      });
    });
  }

  pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      File file = File(result.files.single.path!);
      setState(() {
        image = file.path;
      });
    } else {
      // User canceled the picker
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget FormSetting(controller, title) {
      return Container(
        margin: EdgeInsets.only(top: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: gotham.copyWith(fontSize: 20, color: whiteColor),
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: controller,
              readOnly: !isEdit,
              minLines: 1,
              maxLines: 3,
              decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                filled: true,
                fillColor: whiteColor,
                border: InputBorder.none,
              ),
            ),
          ],
        ),
      );
    }

    Widget FormSettingImage(controller, title) {
      return Container(
        margin: EdgeInsets.only(top: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: gotham.copyWith(fontSize: 20, color: whiteColor),
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: controller,
              readOnly: !isEdit,
              onTap: isEdit
                  ? () {
                      pickFile();
                    }
                  : () {},
              decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                filled: true,
                fillColor: whiteColor,
                border: InputBorder.none,
              ),
            ),
          ],
        ),
      );
    }

    Widget pickImage() {
      return Container(
        margin: EdgeInsets.only(top: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Image",
              style: gotham.copyWith(fontSize: 20, color: whiteColor),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(top: 10),
                  color: whiteColor,
                  height: 200,
                  width: 150,
                  child: (image != null && image != "")
                      ? Image.file(File(image))
                      : Container(
                          child: Icon(
                            Icons.image,
                            size: 50,
                          ),
                        ),
                ),
                SizedBox(
                  width: 20,
                ),
                if (isEdit)
                  Column(
                    children: [
                      ElevatedButton(
                          style:
                              ElevatedButton.styleFrom(backgroundColor: fourth),
                          onPressed: isEdit
                              ? () {
                                  pickFile();
                                }
                              : () {},
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            child: Text("Pilih File"),
                          )),
                      if (image != null && image != "")
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red),
                              onPressed: isEdit
                                  ? () {
                                      setState(() {
                                        image = "";
                                      });
                                    }
                                  : () {},
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 5,
                                ),
                                child: Text(
                                  "Hapus",
                                  style: gotham.copyWith(color: whiteColor),
                                ),
                              )),
                        )
                    ],
                  )
              ],
            ),
          ],
        ),
      );
    }

    return WillPopScope(
      onWillPop: () async {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomePage()));
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: third,
          iconTheme: IconThemeData(color: secondary, size: 30),
          title: Text(
            "Setting",
            style: gotham.copyWith(fontSize: 30, color: primary),
          ),
        ),
        backgroundColor: primary,
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Column(
              children: [
                FormSetting(text1Controller, "Text 1"),
                FormSetting(text2Controller, "Text 2"),
                FormSetting(text3Controller, "Text 3"),
                // FormSettingImage(imageController, "Image"),
                pickImage(),

                Container(
                  margin: EdgeInsets.only(top: 30),
                  child: ElevatedButton(
                      onPressed: () {
                        if (isEdit) {
                          handleSave();
                        } else {
                          setState(() {
                            isEdit = !isEdit;
                          });
                        }
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                        child: Text(
                          (isEdit) ? "Save" : "Edit",
                          style: gotham.copyWith(fontSize: 20),
                        ),
                      )),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
