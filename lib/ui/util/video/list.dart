import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:package_info/package_info.dart';
import 'package:tv_6du/ui/util/menu.dart';
import 'package:tv_6du/ui/util/video.dart';
import 'package:tuple/tuple.dart';

class VideoList extends StatefulWidget {
  VideoList({Key key}) : super(key: key);

  @override
  VideoListState createState() {
    return VideoListState();
  }
}

class ListBuilder<T> {
  final Widget Function(BuildContext, T) builder;
  final int count;

  const ListBuilder(this.builder, this.count);
}

class VideoListState extends State<VideoList> {
  int _position = 0;
  final double padding = 6;
  final scrollController = ScrollController();

  String _url;
  Future<List> fetchVideo() async {
    return (await Dio().get('https://auth.html.ucommuner.com/test.json')).data;
  }

  void goto(List<String> url, int position) {
    setState(() {
      _position = position;
    });
    _url = url[position];
    print("goto $_url");
  }

  Widget Function(BuildContext, AsyncSnapshot<T>) _builder<T>(
      ListBuilder Function(BuildContext, T) function) {
    return (context, snapshot) {
      if (snapshot.hasError) {
        debugPrint(snapshot.error.toString());
        return Icon(Icons.error);
      }
      if (snapshot.connectionState != ConnectionState.done) {
        return Column(children: <Widget>[
          menu(),
          Expanded(child: Center(child: CircularProgressIndicator()))
        ]);
      }
      ListBuilder o = function(context, snapshot.data);
      /*
      GridView.builder(
          padding: EdgeInsets.only(bottom: padding),
          controller: scrollController,
          itemBuilder: (context, item) {
            if (item == 0) return menu();
            return o.builder(context, item - 1);
          },
          itemCount: 1 + o.count,
          gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: n)
        );
        */
      return Scrollbar(
        child: ListView.builder(
          padding: EdgeInsets.only(bottom: padding),
          controller: scrollController,
          itemCount: 1 + o.count,
          //itemCount: itemCount,
          itemBuilder: (context, item) {
            if (item == 0) return menu();
            return o.builder(context, item - 1);
          },
        ),
      );
    };
  }

  Widget menu() {
    return Menu(goto, _position);
  }

  bool _onKey(FocusNode node, RawKeyEvent event) {
    if (event.logicalKey == LogicalKeyboardKey(0x10200000004)) {
      setState(() {});
      return true;
    }
    return false;
  }

  Tuple2<int, double> _nWidth(int max) {
    final size = MediaQuery.of(context).size;
    double width = size.width;
    double height = size.height;
    int n;

    if (height < width) {
      n = max;
      width = (width - 2 * padding) / n - padding * 2;
    } else {
      n = 2;
      width = (width - 2 * padding) / n - padding * 2;
    }
    return Tuple2(n, width);
  }

  ListBuilder _row(int n, List li, Widget Function(dynamic) wrap) {
    List<Widget> children(int item) {
      List<Widget> r = <Widget>[];

      final base = item * n;
      final end = min<int>(li.length - base, n);
      for (var i = 0; i < end; ++i) {
        r.add(wrap(li[base + i]));
      }

      return r;
    }

    return ListBuilder(
      (context, item) {
        return Row(children: children(item));
      },
      ((li.length + n - 1) ~/ n),
    );
  }

  FutureBuilder<List> _future(
      Future<List> Function() future, int n, Widget Function(dynamic) wrap) {
    return FutureBuilder<List>(
        future: future(),
        builder: _builder((context, data) {
          return _row(n, data, wrap);
        }));
  }

  Widget _video() {
    Tuple2<int, double> nWidth = _nWidth(7);
    int n = nWidth.item1;
    double width = nWidth.item2;
    double height = width * 297 / 210;

    return _future(
        fetchVideo,
        n,
        (o) => Padding(
            padding: EdgeInsets.all(padding),
            child: VideoWidget(scrollController,
                img: o[1],
                title: o[0],
                width: width,
                height: height,
                padding: padding,
                onKey: _onKey)));
  }

  Widget _setting() {
    Tuple2<int, double> nWidth = _nWidth(4);
    int n = nWidth.item1;
    double width = nWidth.item2;

    return _future(
        () async {
          final data = await PackageInfo.fromPlatform();
          return [
            Focus(
                onKey: (FocusNode node, RawKeyEvent event) {
                  return _onKey(node, event);
                },
                autofocus: true,
                child: Builder(builder: (BuildContext context) {
                  final FocusNode focusNode = Focus.of(context);
                  bool hasFocus = focusNode.hasFocus;
                  TextStyle textStyle;
                  TextStyle btnStyle;

                  Color bg, textColor;
                  BoxDecoration decoration;
                  String text = "检测更新";
                  LinearGradient gradient;
                  if (hasFocus) {
                    bg = Colors.yellow;
                    textColor = Colors.white;
                    textStyle = TextStyle(color: textColor);
                    decoration = BoxDecoration(
                      color: bg,
                      border: Border.all(width: 1.5, color: bg),
                    );
                    btnStyle = TextStyle(color: Colors.black);
                    gradient = LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.lightGreen[700],
                          Colors.lightGreen[900],
                        ]);
                  } else {
                    textColor = Colors.white70;
                    textStyle = btnStyle = TextStyle(color: textColor);
                    decoration = BoxDecoration(
                      color: Colors.transparent,
                      border: Border.all(width: 1.5, color: textColor),
                    );
                    gradient = LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0xFF666666),
                          Color(0xFF555555),
                          Color(0xFF444444),
                        ]);
                  }

                  TextSpan app = TextSpan(
                      text: "${data.appName} ${data.version}",
                      style: textStyle);
                  final textPainter =
                      TextPainter(textDirection: TextDirection.ltr, text: app);
                  textPainter.layout();
                  final textWidth = textPainter.width;

                  Container btn = Container(
                    width: textWidth,
                    decoration: decoration,
                    child: Text(text,
                        style: btnStyle, textAlign: TextAlign.center),
                    margin: EdgeInsets.only(top: padding * 3),
                    padding: EdgeInsets.symmetric(
                        vertical: padding, horizontal: padding * 2),
                  );

                  return Container(
                      decoration: BoxDecoration(
                          gradient: gradient,
                          boxShadow: hasFocus
                              ? [
                                  BoxShadow(
                                    color: Colors.yellow,
                                    spreadRadius: 3,
                                    blurRadius: 3,
                                    offset: Offset(0.0, 0.0),
                                  )
                                ]
                              : []),
                      child: Container(
                        padding: EdgeInsets.all(padding * 2),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  RichText(text: app),
                                  Container(
                                    width: textWidth,
                                    child: FittedBox(
                                        fit: BoxFit.fitWidth,
                                        child: Text("更新于 2019 / 09 / 12",
                                            style: textStyle)),
                                  )
                                ],
                              ),
                              btn
                            ]),
                      ));
                }))
          ];
        },
        n,
        (child) {
          return Container(
              padding: EdgeInsets.fromLTRB(
                  padding * 2, padding, padding * 2, padding),
              height: width,
              width: width,
              child: child);
        });
  }

  @override
  Widget build(BuildContext context) {
    switch (_url) {
      case 'setting':
        return _setting();
      default:
        return _video();
    }
  }
}
