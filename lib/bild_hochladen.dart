/*import 'package:flutter/material.dart';
import 'package:image/image.dart' as I;

class BildHochladen extends StatefulWidget {
  const BildHochladen({Key key}) : super(key: key);

  @override
  State<BildHochladen> createState() => _BildHochladenState();
}

class _BildHochladenState extends State<BildHochladen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
        ],
      ),
      body: Container(
        child: Text("hochladen"),
      ),
    );
  }
}

void bild(){

  I.image img = I.decodeImage(_image.readAsBytesSync());
  for(int x =0;x<img.width;x++) {
    for(int y = 0;y<img.height;y++){
      int pixel = img.getPixelSafe(x,y);
      Color pixelColor = getFlutterColor(pixel);
    }
  }

  Color getFlutterColor(int abgr) {
    int argb = abgrToArgb(abgr);
    return Color(argb);
  }

  //Shamelessly stolen from stack overflow
  int abgrToArgb(int argbColor) {
    int r = (argbColor >> 16) & 0xFF;
    int b = argbColor & 0xFF;
    return (argbColor & 0xFF00FF00) | (b << 16) | r;
  }
}*/

import 'package:flutter/material.dart';
import 'package:image_pixels/image_pixels.dart';




/*class BildHochladen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ImagePixels Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Find color demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final AssetImage flutter = const AssetImage("assets/f.png");

  Offset localPosition = const Offset(0, 0);
  Color color = const Color(0x00000000);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title:
          Text(localPosition.toString(),
          style:TextStyle(
            color: color,
          ),
          ),
      ),
      body: SizedBox.expand(
        child: Column(
          children: [
            Padding(
                padding: const EdgeInsets.all(1.0),
                child: Center(
                  child: Container(

                    child: Listener(
                      onPointerMove: (PointerMoveEvent details) {
                        setState(() {
                          localPosition = details.localPosition;
                        });
                      },
                      onPointerDown: (PointerDownEvent details) {
                        setState(() {
                          localPosition = details.localPosition;
                        });
                      },
                      child: ImagePixels(
                        imageProvider: flutter,
                        builder: (BuildContext context, ImgDetails img) {
                          var color = img.pixelColorAt(
                            localPosition.dx.toInt(),
                            localPosition.dy.toInt(),
                          );

                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            if (mounted)
                              setState(() {
                                if (color != this.color) this.color = color;
                              });
                          });

                          return Container(


                            child:Image(image:flutter,

                            ),

                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),

            //
          ],
        ),
      ),
    );
  }
}*/
/*import 'dart:typed_data';

import 'package:image/image.dart' as img;
import 'package:flutter/rendering.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'package:muego_dev2/models/songs.dart';
//import 'package:provider/provider.dart';



class BildHochladen extends StatefulWidget {
  //static const routeName = '/';

  @override
  _BildHochladenState createState() => _BildHochladenState();
}

class _BildHochladenState extends State<BildHochladen> {
  final coverData ="assets/f.png";

  img.Image photo;

  void setImageBytes(imageBytes) {
    print("setImageBytes");
    List<int> values = imageBytes.buffer.asUint8List();
    photo = null;
    photo = img.decodeImage(values);
  }

  // image lib uses uses KML color format, convert #AABBGGRR to regular #AARRGGBB
  int abgrToArgb(int argbColor) {
    print("abgrToArgb");
    int r = (argbColor >> 16) & 0xFF;
    int b = argbColor & 0xFF;
    return (argbColor & 0xFF00FF00) | (b << 16) | r;
  }

  // FUNCTION

  Future<Color> _getColor() async {
    print("_getColor");
    Uint8List data;

    try{
      data =
          (await NetworkAssetBundle(
              Uri.parse(coverData)).load(coverData))
              .buffer
              .asUint8List();
    }
    catch(ex){
      print(ex.toString());
    }

    print("setImageBytes....");
    setImageBytes(data);

//FractionalOffset(1.0, 0.0); //represents the top right of the [Size].
    double px = 1.0;
    double py = 0.0;

    int pixel32 = photo.getPixelSafe(px.toInt(), py.toInt());
    int hex = abgrToArgb(pixel32);
    print("Value of int: $hex ");

    return Color(hex);
  }

  @override
  Widget build(BuildContext context) {
    print("build");

    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: <Widget>[
          Flexible(
            flex: 2,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(coverData),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Flexible(
            flex: 1,
            child:

            FutureBuilder(
                future: _getColor(),
                builder: (_, AsyncSnapshot<Color> data){
                  if (data.connectionState==ConnectionState.done){
                    return Container(
                      color: data.data,
                    );
                  }
                  return CircularProgressIndicator();
                }
            ),
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                MaterialButton(
                  elevation: 5.0,
                  padding: EdgeInsets.all(15.0),
                  color: Colors.grey,
                  child: Text("Get Sizes"),
                  onPressed: null,
                ),
                MaterialButton(
                  elevation: 5.0,
                  color: Colors.grey,
                  padding: EdgeInsets.all(15.0),
                  child: Text("Get Positions"),
                  onPressed: _getColor,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}*/

import 'package:flutter/material.dart';
import 'package:pixel_color_picker/pixel_color_picker.dart';






class BildHochladen extends StatefulWidget {
  @override
  _BildHochladenState createState() => _BildHochladenState();
}

class _BildHochladenState extends State<BildHochladen> {
  final AssetImage test = const AssetImage("assets/c.png");

  Offset localPosition = const Offset(0, 0);
  Color color;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(localPosition.toString(),
        style:TextStyle(
          color: color,
        )),
      ),
      body: PixelColorPicker(
        onChanged: (color) {
          setState(() {
            this.color = color;
          });
        },
        child: Center(
          child:
          Listener(
            onPointerMove: (PointerMoveEvent details) {
              setState(() {
                localPosition = details.localPosition;
              });
            },

            child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 1.0,
                    color: Colors.black,
                  ),

                ),



                child:Image(image:test)



            ),
          ),
        ),
      ),
    );
  }
}



