import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:screen/screen.dart';
import 'package:tv_6du/ui/util/menu.dart';
import 'package:tv_6du/ui/util/video/list.dart';

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
  @override
  void initState() {
    super.initState();
  }

  bool _handleKeyPress(FocusNode node, RawKeyEvent event) {
    if (event is RawKeyDownEvent) {
      print("\n$event ${event.logicalKey}");

      if (event.logicalKey == LogicalKeyboardKey(0x10200000017) ||
          event.logicalKey == LogicalKeyboardKey.enter) {
        return true;
      }
      if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
        node.focusInDirection(TraversalDirection.left);
        return true;
      }
      if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
        node.focusInDirection(TraversalDirection.right);
        return true;
      }
      if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
        node.focusInDirection(TraversalDirection.up);
        return true;
      }
      if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
        node.focusInDirection(TraversalDirection.down);
        return true;
      }
    }
    return false;
  }

  DateTime _lastPressedAt; //上次点击时间

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    final scrollController = ScrollController();

    return DefaultFocusTraversal(
        policy: ReadingOrderTraversalPolicy(),
        child: FocusScope(
            onKey: _handleKeyPress,
            autofocus: true,
            child: WillPopScope(
                child: Scaffold(
                    body: Container(
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                              Color(0xFF000000),
                              Color(0xFF101010),
                              Color(0xFF1f1f2f),
                            ])),
                        child: VideoList(Menu(), scrollController))),
                onWillPop: () async {
                  if (_lastPressedAt == null ||
                      DateTime.now().difference(_lastPressedAt) >
                          Duration(seconds: 1)) {
                    //两次点击间隔超过1秒则重新计时
                    _lastPressedAt = DateTime.now();
                    return false;
                  }
                  return true;
                })));
  }
}
