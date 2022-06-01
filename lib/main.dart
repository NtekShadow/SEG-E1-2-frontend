import 'package:flutter/material.dart';
import 'dart:math';



import '4_Gewinnt/4_Gewinnt.dart';
import '4_Gewinnt/screens/game_screen/game_screen.dart';
import 'bild_hochladen.dart';
import 'Malen/drawing_page.dart';
import 'package:flutter/services.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
  DeviceOrientation.portraitUp,
  DeviceOrientation.portraitDown,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lighthouse',
      initialRoute: '/main',
      routes: {
        // When navigating to the "/" route, build the FirstScreen widget.

        // When navigating to the "/second" route, build the SecondScreen widget.
        '/VierGewinnt': (context) =>  VierGewinnt(),
        '/Malen': (context) => Malen(),
        '/BildHochladen': (context) => BildHochladen(),
        '/Homepage':(context)=>HomePage(),
      },
      home:  HomePage(),
    );
  }
}



class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);


  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {


  double value = 0;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [Colors.black,Colors.blue,],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                )

            ),
          ),

            SafeArea(
              child: Container(

                width: 200.0,
                padding: EdgeInsets.all(8.0),
                child:Column(
                  children: [
                    Text("Lighthouse"),
                    Expanded(
                      child: ListView(
                        children: [
                          ListTile(
                            onTap: () {
                              Navigator.pushNamed(context, '/Malen');
                            },
                            leading: Icon(
                              Icons.edit,
                              color: Colors.red,
                            ),
                            title: Text(
                              "Malen",
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                          ListTile(
                            onTap: () {
                              Navigator.pushNamed(context, '/BildHochladen');
                            },
                            leading: Icon(
                              Icons.upload,
                              color: Colors.red,
                            ),
                            title: Text(
                              "BildHochladen",
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                          ListTile(
                            onTap: () {
                              Navigator.pushNamed(context, '/VierGewinnt');
                            },
                            leading: Icon(
                              Icons.games,
                              color: Colors.red,
                            ),
                            title: Text(
                              "VierGewinnt",
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

          TweenAnimationBuilder(
              tween: Tween<double>(begin: 0, end: value),
              duration: Duration(milliseconds: 500),
              builder: (_, double val, __) {
                return (Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.001)
                    ..setEntry(0, 3, 200 * val)
                    ..rotateY((pi / 6) * val),
                  child: Scaffold(
                    appBar: AppBar(
                      title: Text("Lighthouse Test"),
                    ),
                    body: Center(
                      child: Text("nach Links schieben"),
                    ),
                  ),
                ));
              }),
          GestureDetector(onHorizontalDragUpdate: (e) {
            if (e.delta.dx > 0) {
              setState(() {
                value = 1;
              });
            } else {
              setState(() {
                value = 0;
              });
            }
          }
              /*onTap:(){
              setState(() {
                value == 0 ? value =1 : value =0;
              });
            },*/
              )
        ],
      ),
    );
  }
}
