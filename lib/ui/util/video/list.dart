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
    DefaultFocusTraversal.of(context).changedScope();

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
                      onKey: (FocusNode node, RawKeyEvent event) {
                    if (event.logicalKey == LogicalKeyboardKey(0x10200000004)) {
                      setState(() {});
                      return true;
                    }
                    return false;
                  })));
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
    /*  
    String version = packageInfo.version;
    String buildNumber = packageInfo.buildNumber;
    return Focus(autofocus: true, child: Text("版本号 $version ($buildNumber)"));
    */
    return FutureBuilder<PackageInfo>(
        future: PackageInfo.fromPlatform(),
        builder: _builder((context, data) {
          return ListBuilder((context, item) {
            return Text(
                "${data.appName} ${data.packageName} version ${data.version} buildNumber ${data.buildNumber}");
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
