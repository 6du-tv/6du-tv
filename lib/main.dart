import 'dart:ui';

import 'package:background_fetch/background_fetch.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:screen/screen.dart';
import 'package:tv_6du/sdk/auto_update.dart';
import 'package:tv_6du/ui/util/video/list.dart';

void main() {
  autoUpdate();
  runApp(MyApp());
}

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
    checkUpdate();
  }

  void checkUpdate() {
    BackgroundFetch.configure(
        BackgroundFetchConfig(
            minimumFetchInterval: 1,
            stopOnTerminate: false,
            enableHeadless: true), () async {
      // This is the fetch-event callback.
      print('[BackgroundFetch] Event received');
      // setState(() {_events.insert(0, new DateTime.now());});
      // IMPORTANT:  You must signal completion of your fetch task or the OS can punish your app
      // for taking too long in the background.
      BackgroundFetch.finish();
    }).then((int status) {
      print('[BackgroundFetch] SUCCESS: $status');
      //    setState(() {_status = status;});
    }).catchError((e) {
      print('[BackgroundFetch] ERROR: $e');
      // setState(() {_status = e;});
    });
  }

  bool _handleKeyPress(FocusNode node, RawKeyEvent event) {
    if (event is RawKeyDownEvent) {
      print(
          "\n0x${event.logicalKey.keyId.toRadixString(16).padLeft(8, '0')} ${event.logicalKey.debugName} ");

      if (event.logicalKey == LogicalKeyboardKey(0x100070077) ||
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

    Widget focusScope = FocusScope(
        onKey: _handleKeyPress,
        autofocus: true,
        child: Scaffold(body: Builder(builder: (context) {
          final int duration = 3;

          return WillPopScope(
              child: Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                        Color(0xFF000000),
                        Color(0xFF101010),
                        Color(0xFF1f1f2f),
                      ])),
                  child: Center(child: VideoList())),
              onWillPop: () async {
                Scaffold.of(context).showSnackBar(SnackBar(
                  backgroundColor: Colors.black,
                  duration: Duration(
                      milliseconds: duration * 1000 - 250), // 250是显示动画时长
                  content: Text("连按两次返回键退出",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.deepOrange)),
                ));
                if (_lastPressedAt == null ||
                    DateTime.now().difference(_lastPressedAt) >
                        Duration(seconds: 1)) {
                  _lastPressedAt = DateTime.now();
                  return false;
                }

                return true;
              });
        })));
    return DefaultFocusTraversal(
        policy: ReadingOrderTraversalPolicy(), child: focusScope);
  }
}
