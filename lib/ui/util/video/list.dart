import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:tv_6du/ui/util/video.dart';

class VideoList extends StatelessWidget {
  Future<List> fetchVideo() async {
    return (await Dio().get('https://auth.html.ucommuner.com/test.json')).data;
  }

  const VideoList({
    Key key,
    @required this.n,
    @required this.padding,
    @required this.width,
    @required this.height,
    @required ScrollController scrollController,
  })  : _scrollController = scrollController,
        super(key: key);

  final int n;
  final double padding;
  final double width;
  final double height;
  final ScrollController _scrollController;

  @override
  Widget build(BuildContext context) {
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
                      controller: _scrollController,
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
