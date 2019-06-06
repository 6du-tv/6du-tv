import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:tv_6du/ui/util/menu.dart';
import 'package:tv_6du/ui/util/video.dart';

class VideoList extends StatefulWidget {
  final ScrollController _scrollController;
  final Menu _menu;
  VideoList(Menu menu, ScrollController scrollController, {Key key})
      : _menu = menu,
        _scrollController = scrollController,
        super(key: key);

  @override
  VideoListState createState() => VideoListState();
}

class VideoListState extends State<VideoList> {
  Future<List> fetchVideo() async {
    return (await Dio().get('https://auth.html.ucommuner.com/test.json')).data;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    double width = size.width;
    double height = size.height;
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
          if (snapshot.hasError) {
            debugPrint(snapshot.error.toString());
            return Icon(Icons.error);
          }
          if (snapshot.connectionState != ConnectionState.done) {
            return Column(children: <Widget>[
              widget._menu,
              Expanded(child: Center(child: CircularProgressIndicator()))
            ]);
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
                    scrollController: widget._scrollController,
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
              padding: EdgeInsets.only(bottom: padding),
              controller: widget._scrollController,
              itemCount: 1 + ((snapshot.data.length + n - 1) ~/ n),
              //itemCount: itemCount,
              itemBuilder: (context, item) {
                if (item == 0) return widget._menu;
                return Container(
                    padding: EdgeInsets.fromLTRB(padding, 0, padding, 0),
                    child: Row(children: children(item - 1)));
              },
            ),
          );
        }); // This trailing comma makes auto-formatting nicer for build methods.
  }
}
