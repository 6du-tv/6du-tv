import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:screen/screen.dart';
import 'package:dio/dio.dart';
import 'package:tv_6du/ui/util/video.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final String title = "六度电视";
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final theme = ThemeData(
      // This is the theme of your application.
      //
      // Try running your application with "flutter run". You'll see the
      // application has a blue toolbar. Then, without quitting the app, try
      // changing the primarySwatch below to Colors.green and then invoke
      // "hot reload" (press "r" in the console where you ran "flutter run",
      // or simply save your changes to "hot reload" in a Flutter IDE).
      // Notice that the counter didn't reset back to zero; the application
      // is not restarted.
      primarySwatch: Colors.yellow,
      brightness: Brightness.dark,
    );

    SystemChrome.setEnabledSystemUIOverlays([]);

    //让程序不熄屏
    Screen.keepOn(true);

    return MaterialApp(
      title: title,
      theme: theme,
      debugShowCheckedModeBanner: false,
      home: MainPage(title: title),
    );
  }
}

class MainPage extends StatefulWidget {
  MainPage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  Future<List> fetchVideo() async {
    return (await Dio().get('https://auth.html.ucommuner.com/test.json')).data;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    double width = size.width;
    double height = size.height;
    int n;
    final double padding = 8;

    if (height < width) {
      n = 4;
      width = (width - 2 * padding) / n - padding * 2;
    } else {
      n = 2;
      width = (width - 2 * padding) / n - padding * 2;
    }
    height = width * 1.5;

    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.

    return Scaffold(
        body: Center(
            // Center is a layout widget. It takes a single child and positions it
            // in the middle of the parent.
            child: FutureBuilder<List>(
                future: fetchVideo(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    debugPrint(snapshot.error.toString());
                    return Icon(Icons.error);
                  }
                  if (snapshot.connectionState != ConnectionState.done) {
                    return CircularProgressIndicator();
                  }
                  List<Widget> children(item) {
                    var li = <Widget>[];
                    final base = item * n;
                    final end = min(snapshot.data.length - base, n);
                    for (var i = 0; i < end; ++i) {
                      final o = snapshot.data[base + i];
                      li.add(Padding(
                          padding: EdgeInsets.all(padding),
                          child: VideoWidget(
                            img: o[1],
                            title: o[0],
                            width: width,
                            height: height,
                            padding: padding,
                          )));
                    }
                    return li;
                  }

                  return Scrollbar(
                    child: ListView.builder(
                      padding: EdgeInsets.all(padding),
                      itemCount: (snapshot.data.length + n - 1) ~/ n,
                      //itemCount: itemCount,
                      itemBuilder: (context, item) {
                        return Container(child: Row(children: children(item)));
                      },
                    ),
                  );
                })) // This trailing comma makes auto-formatting nicer for build methods.
        );
  }
}
