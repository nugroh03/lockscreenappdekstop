import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lockscreenapp/constant.dart';
import 'package:lockscreenapp/models/setting_models.dart';
import 'package:lockscreenapp/settingpage.dart';
import 'package:lockscreenapp/themes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:slide_countdown/slide_countdown.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:timer_count_down/timer_count_down.dart';
import 'package:window_manager/window_manager.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WindowListener {
  TextEditingController qrController = TextEditingController(text: '');
  TextEditingController maintenanceController = TextEditingController(text: '');
  Future<SharedPreferences> _settingPrefs = SharedPreferences.getInstance();
  bool countDown = false;
  bool waitingOut = false;
  bool wrong = false;
  bool isTesting = false;
  bool isPause = false;
  bool isSetting = false;
  bool wrongcodemaintenance = false;
  Duration defaultDuration = Duration(seconds: 0);

  SettingModel? setting;

  bool isInitial = true;

  FocusNode fQR = FocusNode();

  final CountdownController _controller =
      new CountdownController(autoStart: false);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getView();
    getSetting();
    fQR = FocusNode();
  }

  getView() async {
    await windowManager.setAlwaysOnTop(true);
    await windowManager.setSkipTaskbar(true);
  }

  // void hideHandle(String code) async {
  //   int timer = 0;
  //   int timerwaiting = 60;

  //   if (code == "fh5") {
  //     timer = 6;
  //   } else if (code == "010") {
  //     timer = 11;
  //   } else if (code == "e5") {
  //     timer = 5;
  //   }
  //   // else if (code == "tes") {
  //   //   timer = 1;
  //   //   timerwaiting = 10;
  //   // }

  //   setState(() {
  //     defaultDuration = Duration(minutes: timer);
  //     countDown = true;
  //   });
  //   // await windowManager.setPosition(Offset(1200, 700));
  //   await windowManager.setSize(Size(300, 80));

  //   Future.delayed(Duration(minutes: timer), () async {
  //     await windowManager.setFullScreen(true);
  //     await windowManager.focus();
  //     setState(() {
  //       defaultDuration = Duration(seconds: 0);
  //       countDown = false;
  //       waitingOut = true;
  //     });
  //   })
  //       .then((value) =>
  //           Future.delayed(Duration(seconds: timerwaiting), () async {
  //             setState(() {
  //               waitingOut = false;
  //             });
  //           }))
  //       .then((value) async {
  //     await windowManager.isFocused();
  //     await windowManager.focus();
  //     fQR.requestFocus();
  //   });
  // }

  getSetting() async {
    final SharedPreferences prefs = await _settingPrefs;

    final String? dataSetting = prefs.getString('setting');
    print(dataSetting.toString());
    if (dataSetting != null && dataSetting != "") {
      SettingModel data = SettingModel.fromJson(jsonDecode(dataSetting));

      setState(() {
        setting = data;
        isInitial = false;
      });
    } else {
      SettingModel settingdata = SettingModel(
          text1: defaulttext1,
          text2: defaulttext2,
          text3: defaulttext3,
          image: defaultimage);

      await prefs.setString('setting', jsonEncode(settingdata));

      setState(() {
        setting = settingdata;
        isInitial = false;
      });
    }
  }

  formatedTime({required int timeInSecond}) {
    int sec = timeInSecond % 60;
    int min = (timeInSecond / 60).floor();
    String minute = min.toString().length <= 1 ? "0$min" : "$min";
    String second = sec.toString().length <= 1 ? "0$sec" : "$sec";
    return "$minute : $second";
  }

  void hideHandleNew(String code) async {
    int timer = 0;

    if (code == "005") {
      timer = 6;
    } else if (code == "010") {
      timer = 11;
    } else if (code == "051") {
      timer = 5;
    } else if (code == "qwertieser") {
      timer = 1;
    }
    // else if (code == "tes") {
    //   timer = 1;
    //   timerwaiting = 10;
    // }

    setState(() {
      defaultDuration = Duration(minutes: timer);
      countDown = true;
    });
    // await windowManager.setPosition(Offset(1200, 700));
    await windowManager
        .setSize(Size(350, 90))
        .then((value) => _controller.start())
        .then((value) => _controller.pause())
        .then((value) => _controller.resume());

    // Future.delayed(Duration(minutes: timer), () async {
    // await windowManager.setFullScreen(true);
    // await windowManager.focus();
    // setState(() {
    //   defaultDuration = Duration(seconds: 0);
    //   countDown = false;
    //   waitingOut = true;
    // });
    // })
    //     .then((value) =>
    //         Future.delayed(Duration(seconds: timerwaiting), () async {
    //           setState(() {
    //             waitingOut = false;
    //           });
    //         }))
    //     .then((value) async {
    //   await windowManager.isFocused();
    //   await windowManager.focus();
    //   fQR.requestFocus();
    // });
  }

  void handleAfterTimerDone() async {
    int timerwaiting = 40;
    await windowManager.setFullScreen(true);
    await windowManager.focus();
    setState(() {
      defaultDuration = Duration(seconds: 0);
      countDown = false;
      waitingOut = true;
      isPause = false;
    });

    Future.delayed(Duration(seconds: timerwaiting), () async {
      setState(() {
        waitingOut = false;
      });
    }).then((value) async {
      await windowManager.isFocused();
      await windowManager.focus();
      fQR.requestFocus();
    });
  }

  void handleStop() async {
    await windowManager.setFullScreen(true);
    await windowManager.focus();
    setState(() {
      defaultDuration = Duration(seconds: 0);
      countDown = false;
      isPause = false;
    });

    await windowManager.isFocused();
    await windowManager.focus();
    fQR.requestFocus();
  }

  @override
  void dispose() {
    // TODO: implement disposesa
    fQR.dispose();
    super.dispose();
  }

  @override
  void onWindowFocus() {
    // Make sure to call once.
    // setState(() {});
    fQR.requestFocus();
    // do something
  }

  void onWindowClose() async {
    await windowManager.destroy();
  }

  void testing() async {
    setState(() {
      countDown = true;
      isTesting = true;
    });
    await windowManager.setSize(Size(300, 80));
  }

  // void minimize() async {
  //   await windowManager.minimize();

  //   qrController.clear();
  // }
  handlePause() async {
    setState(() {
      isSetting = false;
      isPause = true;
    });
    maintenanceController.clear();

    //  hideHandle(qrController.text);
    _controller.pause();
  }

  @override
  Widget build(BuildContext context) {
    Widget testingWidget() {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Testing !",
              style: gotham.copyWith(fontSize: 14, color: secondary),
            ),
            SizedBox(
              height: 10,
            ),
            Center(
              child: Container(
                width: 100,
                height: 30,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: secondary),
                  onPressed: () async {
                    await windowManager.setFullScreen(true);
                    setState(() {
                      countDown = false;
                      isTesting = false;
                    });
                  },
                  child: Center(
                    child: Text(
                      "Selesai",
                      style: gotham.copyWith(
                          fontSize: 14, color: primary, fontWeight: bold),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      );
    }

    Widget testFieldMaintenance() {
      return Container(
        height: 30,
        margin: EdgeInsets.only(top: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 150,
              child: TextFormField(
                autofocus: true,
                obscureText: true,
                controller: maintenanceController,
                style: gotham.copyWith(
                  color: primary,
                ),
                onChanged: (String value) {
                  setState(() {
                    wrongcodemaintenance = false;
                  });
                },
                onFieldSubmitted: (String value) {
                  if (value.toLowerCase() == "11") {
                    handlePause();
                  } else {
                    setState(() {
                      wrongcodemaintenance = true;
                    });
                  }
                },
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  isDense: true, // Added this
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                  filled: true,
                  fillColor: whiteColor,
                  border: InputBorder.none,
                ),
              ),
            ),
            if (wrongcodemaintenance)
              SizedBox(
                width: 15,
              ),
            if (wrongcodemaintenance)
              Container(
                height: 30,
                child: Center(
                  child: Text(
                    "X",
                    style: gotham.copyWith(
                        fontWeight: bold, color: Colors.red, fontSize: 25),
                  ),
                ),
              )
          ],
        ),
      );
    }

    Widget settingPlayAndStop() {
      return Container(
        padding: EdgeInsets.only(top: 10),
        child: Row(
          children: [
            if (isPause)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: GestureDetector(
                  onTap: () {
                    _controller.resume();
                    setState(() {
                      isPause = false;
                    });
                  },
                  child: Icon(
                    Icons.play_arrow,
                    color: Colors.green,
                    size: 30,
                  ),
                ),
              ),
            if (isPause)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: GestureDetector(
                  onTap: () async {
                    _controller.pause();

                    handleStop();
                  },
                  child: Icon(
                    Icons.stop,
                    color: Colors.red,
                    size: 30,
                  ),
                ),
              ),
            if (!isPause)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: GestureDetector(
                  onTap: () async {
                    // await windowManager
                    //     .setSize(Size(300, 120))
                    //     .then((value) =>);
                    setState((() {
                      isSetting = !isSetting;
                    }));
                  },
                  child: Container(
                    alignment: Alignment.centerRight,
                    child: Icon(
                      Icons.settings,
                      color: secondary,
                      size: 25,
                    ),
                  ),
                ),
              ),
          ],
        ),
      );
    }

    return Scaffold(
        backgroundColor: primary,
        body: isInitial
            ? Center(
                child: CircularProgressIndicator(
                  color: secondary,
                ),
              )
            : !countDown
                ? Stack(
                    children: [
                      if (!waitingOut)
                        Positioned(
                          child: Center(
                            child: Container(
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "SELAMAT DATANG",
                                      style: gotham.copyWith(
                                        fontSize: 60,
                                        color: secondary,
                                      ),
                                    ),
                                    Container(
                                      width: displayWidth(context) * 0.6,
                                      margin: EdgeInsets.only(top: 20),
                                      height: 60,
                                      child: TextField(
                                        autofocus: true,
                                        obscureText: true,
                                        focusNode: fQR,
                                        controller: qrController,
                                        style: gotham.copyWith(color: primary),
                                        onChanged: (String value) {
                                          setState(() {
                                            wrong = false;
                                          });
                                          fQR.requestFocus();
                                        },
                                        onSubmitted: (String value) {
                                          if (value.toLowerCase() == "005" ||
                                              value.toLowerCase() == "010" ||
                                              value.toLowerCase() == "051" ||
                                              value.toLowerCase() ==
                                                  "qwertieser") {
                                            //  hideHandle(qrController.text);
                                            hideHandleNew(qrController.text
                                                .toLowerCase());
                                            qrController.clear();
                                          } else if (value.toLowerCase() ==
                                              "000") {
                                            qrController.clear();
                                            testing();
                                          } else if (value.toLowerCase() ==
                                              "111") {
                                            onWindowClose();
                                          } else if (value.toLowerCase() ==
                                              "555") {
                                            qrController.clear();
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        SettingPage()));
                                          } else {
                                            setState(() {
                                              wrong = true;
                                            });
                                            fQR.requestFocus();
                                          }
                                        },
                                        textAlign: TextAlign.center,
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: whiteColor,
                                          border: InputBorder.none,
                                        ),
                                      ),
                                    ),
                                    if (wrong)
                                      Text(
                                        "Kode yang anda masukkan salah",
                                        style: gotham.copyWith(
                                          fontSize: 20,
                                          fontWeight: light,
                                          color: whiteColor,
                                        ),
                                      ),
                                    if (setting!.image != "")
                                      Container(
                                        margin:
                                            EdgeInsets.symmetric(vertical: 60),
                                        height: 200,
                                        width: displayWidth(context),
                                        child: Image.file(
                                          File(setting!.image),
                                          fit: BoxFit.fitHeight,
                                        ),
                                      ),

                                    /* Text(
                                  "Scan QR CODE For Open Screen Lock",
                                  style: gotham.copyWith(
                                    fontSize: 20,
                                    fontWeight: light,
                                    color: whiteColor,
                                  ),
                                ),*/

                                    if (setting!.image == "")
                                      SizedBox(
                                        height: 100,
                                      ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      child: Text(
                                        setting!.text1,
                                        textAlign: TextAlign.center,
                                        style: gotham.copyWith(
                                          fontSize: 20,
                                          color: whiteColor,
                                          fontWeight: light,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 30,
                                    ),
                                    Text(
                                      setting!.text2,
                                      style: gotham.copyWith(
                                        fontSize: 20,
                                        color: secondary,
                                      ),
                                    ),
                                  ]),
                            ),
                          ),
                        ),
                      if (waitingOut)
                        Positioned(
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "TERIMAKASIH\n\n${setting!.text3} ",
                                  textAlign: TextAlign.center,
                                  style: gotham.copyWith(
                                    fontSize: 20,
                                    color: whiteColor,
                                    fontWeight: bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      Positioned(
                        bottom: 40,
                        right: 10,
                        child: Container(
                          child: Column(
                            children: [
                              Image.asset(
                                "assets/logo-new.png",
                                width: 50,
                              ),
                              // Image.asset(
                              //   "assets/title.png",
                              //   width: 200,
                              // ),
                              // Image.asset(
                              //   "assets/description.png",
                              //   width: 200,
                              // )
                            ],
                          ),
                        ),
                      )
                    ],
                  )
                : Container(
                    child: (isTesting)
                        ? testingWidget()
                        : Center(
                            child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Container(
                                height: 40,
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    settingPlayAndStop(),
                                    if (isSetting) testFieldMaintenance()
                                  ],
                                ),
                              ),
                              if (isPause || isSetting)
                                SizedBox(
                                  height: 10,
                                ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      child: Countdown(
                                          controller: _controller,
                                          onFinished: () {
                                            handleAfterTimerDone();
                                          },
                                          seconds: defaultDuration.inSeconds,
                                          build: (_, double time) {
                                            return Container(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.alarm,
                                                    color: Colors.white,
                                                    size: 20,
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text(
                                                    formatedTime(
                                                        timeInSecond:
                                                            time.toInt()),
                                                    style: gotham.copyWith(
                                                        fontSize: 30,
                                                        color: whiteColor),
                                                  ),
                                                ],
                                              ),
                                            );
                                          }),
                                    ),
                                  ),
                                  // if (isSetting) testFieldMaintenance()
                                ],
                              ),
                            ],
                          )

                            /* SlideCountdown(
                          duration: defaultDuration,
                          padding: defaultPadding,
                          fade: true,
                          textStyle:fh5
                              gotham.copyWith(fontSize: 30, color: whiteColor),
                          icon: const Padding(
                            padding: EdgeInsets.only(right: 5),
                            child: Icon(
                              Icons.alarm,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          decoration: BoxDecoration(
                            color: primary,
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                          ),
                        ),*/
                            ),
                  ));
  }
}
