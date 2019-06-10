import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:package_info/package_info.dart';
import 'package:tv_6du/ui/util/menu.dart';
import 'package:tv_6du/ui/util/video.dart';

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

  Widget _video() {
    final size = MediaQuery.of(context).size;
    double width = size.width;
    double height = size.height;
    int n;

    if (height < width) {
      n = 7;
      width = (width - 2 * padding) / n - padding * 2;
    } else {
      n = 2;
      width = (width - 2 * padding) / n - padding * 2;
    }
    height = width * 297 / 210;

    return FutureBuilder<List>(
        future: fetchVideo(),
        builder: _builder((context, data) {
          List<Widget> children(item) {
            List<Widget> li = <Widget>[];

            final base = item * n;
            final end = min<int>(data.length - base, n);
            for (var i = 0; i < end; ++i) {
              final o = data[base + i];

              li.add(Padding(
                  padding: EdgeInsets.all(padding),
                  child: VideoWidget(scrollController,
                      img: o[1],
                      title: o[0],
                      width: width,
                      height: height,
                      padding: padding,
                      onKey: _onKey)));
            }

            return li;
          }

          return ListBuilder(
            (context, item) {
              return Container(
                  padding: EdgeInsets.fromLTRB(padding, 0, padding, 0),
                  child: Row(children: children(item)));
            },
            ((data.length + n - 1) ~/ n),
          );
        }));
  }

  Widget _setting() {
    return FutureBuilder<PackageInfo>(
        future: PackageInfo.fromPlatform(),
        builder: _builder((context, data) {
          return ListBuilder((context, item) {
            final theme = Theme.of(context);
            return Container(
                padding: EdgeInsets.fromLTRB(
                    padding * 2, padding, padding * 2, padding),
                child: Row(children: [
                  Expanded(child: Text("${data.appName} ${data.version}")),
                  Expanded(
                    child: Focus(
                      onKey: (FocusNode node, RawKeyEvent event) {
                        return _onKey(node, event);
                      },
                      autofocus: true,
                      child: Builder(builder: (BuildContext context) {
                        final FocusNode focusNode = Focus.of(context);
                        Color bg, textColor;
                        String text = "检测更新";
                        void onPress() {}
                        if (focusNode.hasFocus) {
                          bg = theme.buttonColor;
                          textColor = theme.primaryColor;
                          return FlatButton(
                            onPressed: onPress,
                            color: bg,
                            shape: StadiumBorder(),
                            child:
                                Text(text, style: TextStyle(color: textColor)),
                          );
                        } else {
                          textColor = Colors.grey;
                          return OutlineButton(
                            onPressed: onPress,
                            borderSide: BorderSide(color: textColor),
                            shape: StadiumBorder(),
                            child:
                                Text(text, style: TextStyle(color: textColor)),
                          );
                        }
                      }),
                    ),
                  )
                ]));
          }, 1);
        }));
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
