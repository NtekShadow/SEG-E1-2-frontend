import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'drawn_line.dart';
import 'sketcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:firebase_database/firebase_database.dart';


class Malen extends StatefulWidget {
  @override
  _MalenState createState() => _MalenState();
}

class _MalenState extends State<Malen> {
  GlobalKey _globalKey = new GlobalKey();
  Offset localPosition = const Offset(0, 0);
  List<DrawnLine> lines = <DrawnLine>[];
  DrawnLine line;
  Color selectedColor = Colors.black;
  double selectedWidth = 5.0;
  FirebaseDatabase database = FirebaseDatabase.instance;
  DatabaseReference myRef;
  //* gibt den Weg zur Übertragung
  koordinaten_Farben_uebertragung() {
    myRef = database.ref("LED");
  }
  //* löscht die RGB Werte von Firebase
  _clearIndex() {
    for (int i = 0; i < 288; i++) {
      myRef.child(i.toString()).child("R").set("0");
      myRef.child(i.toString()).child("G").set("0");
      myRef.child(i.toString()).child("B").set("0");
    }
  }

  StreamController<List<DrawnLine>> linesStreamController = StreamController<List<DrawnLine>>.broadcast();
  StreamController<DrawnLine> currentLineStreamController = StreamController<DrawnLine>.broadcast();

  @override
  void initState() {
    super.initState();
    koordinaten_Farben_uebertragung();
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(

      backgroundColor: Colors.yellow[50],
      body: Stack(
        children: [
          buildAllPaths(context),
          buildCurrentPath(context),
          buildbackButton(),
          buildColorToolbar(),
          position(),

        ],
      ),
    );
  }

  Widget buildCurrentPath(BuildContext context) {
    int width = MediaQuery.of(context).size.width.toInt();
    int height = MediaQuery.of(context).size.height.toInt();
    // wichtig für Verkleinern des Pixels
    int xfactor = width~/8;
    int yfactor = height~/36;
    return GestureDetector(
      onPanStart: onPanStart,
      onPanUpdate: onPanUpdate,
      onPanEnd: onPanEnd,
      child: RepaintBoundary(

        child: Listener(
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
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            padding: EdgeInsets.all(4.0),
            color: Colors.transparent,
            alignment: Alignment.topLeft,
            child: StreamBuilder<DrawnLine>(
              stream: currentLineStreamController.stream,
              builder: (context, snapshot) {
                return CustomPaint(
                  painter: Sketcher(
                    lines: [line],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget buildAllPaths(BuildContext context) {
    return RepaintBoundary(
      key: _globalKey,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.transparent,
        padding: EdgeInsets.all(4.0),
        alignment: Alignment.topLeft,
        child: StreamBuilder<List<DrawnLine>>(
          stream: linesStreamController.stream,
          builder: (context, snapshot) {
            return CustomPaint(
              painter: Sketcher(
                lines: lines,
              ),
            );
          },
        ),
      ),
    );
  }

  void onPanStart(DragStartDetails details) {
    RenderBox box = context.findRenderObject();
    Offset point = box.globalToLocal(details.globalPosition);
    line = DrawnLine([point], selectedColor, selectedWidth);


  }

  void onPanUpdate(DragUpdateDetails details) {
    RenderBox box = context.findRenderObject();
    Offset point = box.globalToLocal(details.globalPosition);

    List<Offset> path = List.from(line.path)..add(point);
    line = DrawnLine(path, selectedColor, selectedWidth);
    currentLineStreamController.add(line);
  }

  void onPanEnd(DragEndDetails details) {
    lines = List.from(lines)..add(line);

    linesStreamController.add(lines);


  }

  Widget buildColorToolbar() {
    return Positioned(
      top: 40.0,
      right: 10.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          buildClearButton(),
          buildColorButton(Colors.red[600]),
          buildColorButton(Colors.blue[600]),
          buildColorButton(Colors.green[600]),
          buildColorButton(Colors.yellow),
          buildColorButton(Colors.black),
          buildColorButton(Colors.white),
        ],
      ),
    );
  }

  Widget buildColorButton(Color color) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: FloatingActionButton(
        mini: true,
        backgroundColor: color,
        child: Container(),
        onPressed: () {
          setState(() {
            selectedColor = color;
          });
        },
      ),
    );
  }


  Widget buildClearButton() {
    return GestureDetector(
      onTap: clear,
      child: CircleAvatar(
        child: Icon(
          Icons.delete,
          size: 20.0,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget buildbackButton() {
    return GestureDetector(
      onTap: (){Navigator.pop(context);
      _clearIndex();
        },
      child: Padding(
        padding: const EdgeInsets.only(left:2.0,top:25.0,right:0.0,bottom:0.0),
        child: CircleAvatar(
          child: Icon(
            Icons.arrow_back,
            size: 20.0,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
  Widget position() {
    return Padding(
      padding: const EdgeInsets.only(left:2.0,top:70.0,right:0.0,bottom:0.0),
      child: Text(
        localPosition.toString(),style: TextStyle(
        color: selectedColor,
      ),
      ),
    );
  }

  Future<void> clear() async {
    setState(() {
      _clearIndex();
      lines = [];
      line = null;
    });
  }


}