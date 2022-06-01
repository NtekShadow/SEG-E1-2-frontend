import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'drawn_line.dart';
import 'sketcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

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


  StreamController<List<DrawnLine>> linesStreamController = StreamController<List<DrawnLine>>.broadcast();
  StreamController<DrawnLine> currentLineStreamController = StreamController<DrawnLine>.broadcast();



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

    return GestureDetector(
      onPanStart: onPanStart,
      onPanUpdate: onPanUpdate,
      onPanEnd: onPanEnd,
      child: Scaffold(

        body: Listener(
          onPointerMove: (PointerMoveEvent details) {
            setState(() {
              localPosition = details.localPosition;
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

  /*Widget buildStrokeToolbar() {
    return Positioned(
      bottom: 100.0,
      right: 10.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [

          position(),

        ],
      ),
    );
  }*/

  /*Widget buildStrokeButton(double strokeWidth) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedWidth = strokeWidth;
        });
      },
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Container(
          width: strokeWidth * 2,
          height: strokeWidth * 2,
          decoration: BoxDecoration(color: selectedColor, borderRadius: BorderRadius.circular(50.0)),
        ),
      ),
    );
  }*/

  Widget buildColorToolbar() {
    return Positioned(
      top: 40.0,
      right: 10.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          buildClearButton(),
          buildColorButton(Colors.red),
          buildColorButton(Colors.blueAccent),
          buildColorButton(Colors.deepOrange),
          buildColorButton(Colors.green),
          buildColorButton(Colors.lightBlue),
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

  Widget buildSaveButton() {
    return GestureDetector(
      onTap: save,
      child: CircleAvatar(
        child: Icon(
          Icons.save,
          size: 20.0,
          color: Colors.white,
        ),
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
      onTap: (){Navigator.pop(context);},
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

  Future<void> save() async {
    try {
      RenderRepaintBoundary boundary = _globalKey.currentContext.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage();
      ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData.buffer.asUint8List();
      var saved = await ImageGallerySaver.saveImage(
        pngBytes,
        quality: 100,
        name: DateTime.now().toIso8601String() + ".png",
        isReturnImagePathOfIOS: true,
      );
      print(saved);
    } catch (e) {
      print(e);
    }
  }

  Future<void> clear() async {
    setState(() {
      lines = [];
      line = null;
    });
  }
}
