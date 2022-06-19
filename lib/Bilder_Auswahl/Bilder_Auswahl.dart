import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:pixel_color_picker/pixel_color_picker.dart';






class Bilder_Auswahl extends StatefulWidget {
  @override
  _Bilder_AuswahlState createState() => _Bilder_AuswahlState();
}

class _Bilder_AuswahlState extends State<Bilder_Auswahl> {
  final AssetImage test = const AssetImage("assets/Flutter.png");
  FirebaseDatabase database = FirebaseDatabase.instance;
  DatabaseReference myRef;
  Offset localPosition = const Offset(0, 0);
  Color selectedColor = Colors.black;

  //* gibt den Weg zur Übertragung
  koordinaten_Farben_uebertragung() {
    myRef = database.ref("LED");
  }

    @override
  void initState() {
    super.initState();
    koordinaten_Farben_uebertragung();

  }
  //* löscht die RGB Werte von Firebase
  _clearIndex() {
    for (int i = 0; i < 288; i++) {
      myRef.child(i.toString()).child("R").set("0");
      myRef.child(i.toString()).child("G").set("0");
      myRef.child(i.toString()).child("B").set("0");
    }
  }
  @override
  Widget build(BuildContext context) {
    int width = MediaQuery.of(context).size.width.toInt();
    int height = MediaQuery.of(context).size.height.toInt();
    // wichtig für Verkleinern des Pixels
    int xfactor = width~/8;
    int yfactor = height~/36;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon:  Icon(Icons.arrow_back),
            onPressed: () {
              _clearIndex();
              Navigator.pop(context);
            },
          ),
        ],
        title: Text(localPosition.toString(),
        style:TextStyle(
          color: selectedColor,
        )),
      ),
      body: PixelColorPicker(
        onChanged: (color) {
          setState(() {
            this.selectedColor = color;
          });
        },
        child: Center(
          child:
          Listener(
            onPointerMove: (PointerMoveEvent details) {
              setState(() {
                localPosition = details.localPosition;
                // x-Achse wird gespiegelt und an der Simulatur angepasst
                int x = 7-localPosition.dx~/xfactor;
                // y-Achse wird an der Simulatur angepasst
                int y = localPosition.dy~/yfactor;
                // x-y Achse wird zu Index umgerechnet
                int n =((8*y)+x);
                print("x:${x} + y:${y} = n:${n} ");
                // die Daten werden zur Firebase übertragen
                if(n>=0 && n<288) {
                  myRef.child(n.toString()).child("R").set(selectedColor.red);
                  myRef.child(n.toString()).child("G").set(selectedColor.green);
                  myRef.child(n.toString()).child("B").set(selectedColor.blue);
                }
              });
            },
            child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 1.0,
                    color: Colors.black,
                  ),
                ),
                child: Image(image: test),
            ),
          ),
        ),
      ),
    );
  }
}



