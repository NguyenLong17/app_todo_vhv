import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/controller/app_controller.dart';
import 'package:todo_app/hive_manager.dart';
import 'package:todo_app/page/home_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: FlutterLogo(),
      ),
    );
  }

  Future initData() async {
    await hive.init();

    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const HomePage()),
        (Route<dynamic> route) => false);

    //   if (AppController().isLanguage == null) {
    //     await hive.getValue(TodoAppLanguage);
    //     await hive.getValue(TodoAppTheme);
    //
    //     Navigator.of(context).pushAndRemoveUntil(
    //         MaterialPageRoute(builder: (context) => const HomePage()),
    //             (Route<dynamic> route) => false);
    //   } else {
    //
    //     AppController().isLanguage = false.obs;
    //
    //     Navigator.of(context).pushAndRemoveUntil(
    //         MaterialPageRoute(builder: (context) => const HomePage()),
    //             (Route<dynamic> route) => false);
    //   }
    //   print('Languege: ${AppController().isLanguage!.value}');
    // }
  }

  @override
  void initState() {
    initData();
    super.initState();
  }
}
