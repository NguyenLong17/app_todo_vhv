import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/controller/app_controller.dart';
import 'package:todo_app/common/hive_manager.dart';
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

   final  languageApp = await hive.getValue(TodoAppLanguage);
   final  themeApp = await hive.getValue(TodoAppTheme);

   AppController().isLanguage = languageApp;

   AppController().isDarkMode = themeApp;

    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const HomePage()),
        (Route<dynamic> route) => false);
  }

  @override
  void initState() {
    initData();
    super.initState();
  }
}
