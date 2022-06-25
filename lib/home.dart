import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void hideHandle() async {
    await windowManager.hide();

    Future.delayed(Duration(seconds: 5), () async {
      // 5s over, navigate to a new page
      await windowManager.hide();
      await windowManager.focus();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: ElevatedButton(
          onPressed: () {
            hideHandle();
          },
          child: Text("Hide")),
    ));
  }
}
