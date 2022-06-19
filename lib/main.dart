import 'package:flutter/material.dart';
import 'dart:math';
import '4_Gewinnt/4_Gewinnt.dart';
import 'Bilder_Auswahl/Bilder_Auswahl.dart';
import 'Malen/malen.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lighthouse',
      initialRoute: '/',
      routes: {
        '/VierGewinnt': (context) =>  VierGewinnt(),
        '/Malen': (context) => Malen(),
        '/Bilder_Auswahl': (context) => Bilder_Auswahl(),
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
                    Text("Lighthouse", style: TextStyle(color: Colors.white)),
                    Expanded(
                      child: ListView(
                        children: [
                          ListTile(
                            onTap: () {
                              Navigator.pushNamed(context, '/Malen');
                            },
                            leading: Icon(
                              Icons.edit,
                              color: Colors.white,
                            ),
                            title: Text(
                              "Malen",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          ListTile(
                            onTap: () {
                              Navigator.pushNamed(context, '/Bilder_Auswahl');
                            },
                            leading: Icon(
                              Icons.upload,
                              color: Colors.white,
                            ),
                            title: Text(
                              "Bilder Auswahl",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          ListTile(
                            onTap: () {
                              Navigator.pushNamed(context, '/VierGewinnt');
                            },
                            leading: Icon(
                              Icons.games,
                              color: Colors.white,
                            ),
                            title: Text(
                              "VierGewinnt",
                              style: TextStyle(color: Colors.white),
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
                      automaticallyImplyLeading: false,
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
              )
        ],
      ),
    );
  }
}
