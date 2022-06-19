import 'package:flutter/material.dart';
import 'package:Lighthouse/4_Gewinnt/core/bindings/main_bindings.dart';
import 'package:get/get.dart';

import 'package:Lighthouse/4_Gewinnt/screens/game_screen/game_screen.dart';



class VierGewinnt extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialBinding: MainBindings(),
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),

      getPages: [
        GetPage(name: '/', page: () => GameScreen()),
      ],
    );
  }
}