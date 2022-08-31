import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lockscreenapp/themes.dart';
import 'package:slide_countdown/slide_countdown.dart';
import 'package:window_manager/window_manager.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WindowListener {
  TextEditingController qrController = TextEditingController(text: '');
  bool countDown = false;
  bool waitingOut = false;
  bool wrong = false;
  Duration defaultDuration = Duration(seconds: 0);
  static const defaultPadding =
      EdgeInsets.symmetric(horizontal: 10, vertical: 5);

  FocusNode fQR = FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fQR = FocusNode();
  }

  void hideHandle(String code) async {
    int timer = 0;
    int timerwaiting = 60;

    if (code == "FHINDO") {
      timer = 5;
    } else if (code == "FHINDO10") {
      timer = 10;
    } else if (code == "qwertieser") {
      timer = 1;
      timerwaiting = 10;
    }

    setState(() {
      defaultDuration = Duration(minutes: timer);
      countDown = true;
    });
    // await windowManager.setPosition(Offset(1200, 700));
    await windowManager.setSize(Size(300, 80));

    Future.delayed(Duration(minutes: timer), () async {
      await windowManager.setFullScreen(true);
      await windowManager.focus();
      setState(() {
        defaultDuration = Duration(seconds: 0);
        countDown = false;
        waitingOut = true;
      });
    })
        .then((value) =>
            Future.delayed(Duration(seconds: timerwaiting), () async {
              setState(() {
                waitingOut = false;
              });
            }))
        .then((value) async {
      await windowManager.isFocused();
      await windowManager.focus();
      fQR.requestFocus();
    });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: primary,
        body: !countDown
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
                                      if (value == "FHINDO" ||
                                          value == "FHINDO10" ||
                                          value == "qwertieser") {
                                        hideHandle(qrController.text);
                                        qrController.clear();
                                      } else if (value == "exitqwertieser") {
                                        windowManager.close();
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

                                /* Text(
                                  "Scan QR CODE For Open Screen Lock",
                                  style: gotham.copyWith(
                                    fontSize: 20,
                                    fontWeight: light,
                                    color: whiteColor,
                                  ),
                                ),*/
                                SizedBox(
                                  height: 100,
                                ),
                                Text(
                                  "NIKMATI SESI FOTO ANDA DIDALAM FOTO BOX INI SELAMA 5 ATAU 10 MENIT SESUAI DENGAN WAKTU ORDER ANDA",
                                  style: gotham.copyWith(
                                    fontSize: 20,
                                    color: whiteColor,
                                    fontWeight: light,
                                  ),
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                Text(
                                  "HUBUNGI ADMIN UNTUK MEMBUKA SCREEN LOCK",
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
                              "TERIMAKASIH\n\nSesi foto anda sudah habis, Silahkan keluar dari box ",
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
                            "assets/logo.png",
                            width: 50,
                          ),
                          Image.asset(
                            "assets/title.png",
                            width: 200,
                          ),
                          Image.asset(
                            "assets/description.png",
                            width: 200,
                          )
                        ],
                      ),
                    ),
                  )
                ],
              )
            : Container(
                child: Center(
                  child: SlideCountdown(
                    duration: defaultDuration,
                    padding: defaultPadding,
                    fade: true,
                    textStyle: gotham.copyWith(fontSize: 30, color: whiteColor),
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
                  ),
                ),
              ));
  }
}
