import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:tv_6du/ui/util/menu.dart';
import 'package:tv_6du/ui/util/video.dart';

class VideoList extends StatefulWidget {
  VideoList({Key key}) : super(key: key);

  @override
  VideoListState createState() {
    return VideoListState();
  }
}

class VideoListState extends State<VideoList> {
  int _position = 0;
  String _url;
  Future<List> fetchVideo() async {
    return (await Dio().get('https://auth.html.ucommuner.com/test.json')).data;
  }

  void goto(List<String> url, int position) {
    DefaultFocusTraversal.of(context).changedScope();

    setState(() {
      _position = position;
    });
    _url = url[position];
    print("goto $_url");
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    double width = size.width;
    double height = size.height;
    final scrollController = ScrollController();
    int n;
    final double padding = 6;

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
        builder: (context, snapshot) {
          Menu _menu = Menu(goto, _position);
          if (snapshot.hasError) {
            debugPrint(snapshot.error.toString());
            return Icon(Icons.error);
          }
          if (snapshot.connectionState != ConnectionState.done) {
            return Column(children: <Widget>[
              _menu,
              Expanded(child: Center(child: CircularProgressIndicator()))
            ]);
          }
          List<Widget> children(item) {
            List<Widget> li = <Widget>[];

            switch (_url) {
              case 'setting':
                PackageInfo packageInfo = await PackageInfo.fromPlatform();

                String version = packageInfo.version;
                String buildNumber = packageInfo.buildNumber;
                li.add(Focus(
                    autofocus: true,
                    child: Text("版本号 $version ($buildNumber)")));
                break;
              default:
                final base = item * n;
                final end = min(snapshot.data.length - base, n);
                for (var i = 0; i < end; ++i) {
                  final o = snapshot.data[base + i];

                  li.add(Padding(
                      padding: EdgeInsets.all(padding),
                      child: VideoWidget(scrollController,
                          img: o[1],
                          title: o[0],
                          width: width,
                          height: height,
                          padding: padding,
                          onKey: (FocusNode node, RawKeyEvent event) {
                        if (event.logicalKey ==
                            LogicalKeyboardKey(0x10200000004)) {
                          setState(() {});
                          return true;
                        }
                        return false;
                      })));
                }
            }
            return li;
          }

          return Scrollbar(
            child: ListView.builder(
              padding: EdgeInsets.only(bottom: padding),
              controller: scrollController,
              itemCount: 1 + ((snapshot.data.length + n - 1) ~/ n),
              //itemCount: itemCount,
              itemBuilder: (context, item) {
                if (item == 0) return _menu;
                return Container(
                    padding: EdgeInsets.fromLTRB(padding, 0, padding, 0),
                    child: Row(children: children(item - 1)));
              },
            ),
          );
        }); // This trailing comma makes auto-formatting nicer for build methods.
  }
}
