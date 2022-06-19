import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:Lighthouse/4_Gewinnt/controllers/game_controller.dart';
import 'package:get/get.dart';

import 'widgets/game_body.dart';

class GameScreen extends StatelessWidget {
  final GameController gameController = Get.find<GameController>();
  FirebaseDatabase database = FirebaseDatabase.instance;
  DatabaseReference myRef;

  //* löscht die RGB Werte von Firebase
  _clearIndex() {
    myRef = database.ref("LED");
    for (int i = 0; i < 288; i++) {
      myRef.child(i.toString()).child("R").set("0");
      myRef.child(i.toString()).child("G").set("0");
      myRef.child(i.toString()).child("B").set("0");
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(


        appBar: AppBar(
          actions: [
            IconButton(
              icon:  Icon(Icons.reset_tv),
              onPressed: () {
                _clearIndex();
                gameController.resetGame();
              },
            ),
          ],
          title: Obx(() => Text(
              gameController.turnYellow ? 'Grün' : ' Rot',
              style: TextStyle(
                  color:
                      gameController.turnYellow ? Colors.green[600] : Colors.red[600]))),


        ),
        body: GameBody());
  }
}
