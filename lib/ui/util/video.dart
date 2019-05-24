import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class VideoWidget extends StatefulWidget {
  final String img;
  final String title;
  final GestureTapCallback onTap;
  final width;
  final height;
  final padding;

  const VideoWidget(
      {Key key,
      this.padding,
      this.height,
      this.width,
      this.img,
      this.title,
      this.onTap})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return VideoWidgetState();
  }
}

class VideoWidgetState extends State<VideoWidget> {
  Color color = Colors.grey;
  double radius = 0;
  Color boxColor = Colors.transparent;

  void _onTap() {
    setState(() {
      if (color == Colors.grey) {
        color = Colors.yellow;
        radius = 3;
        boxColor = Colors.yellow;
      } else {
        color = Colors.grey;
        radius = 0;
        boxColor = Colors.transparent;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final widget = this.widget;

    final imgW = (widget.width * window.devicePixelRatio).toInt().toString();
    final imgH = (widget.height * window.devicePixelRatio).toInt().toString();

    return GestureDetector(
        onTap: _onTap,
        child: Column(children: <Widget>[
          Container(
              width: widget.width,
              margin: EdgeInsets.only(bottom: widget.padding),
              height: widget.height,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 1),
                color: Colors.black12,
                boxShadow: [
                  BoxShadow(
                    color: boxColor,
                    spreadRadius: radius,
                    blurRadius: radius,
                    offset: const Offset(0.0, 0.0),
                  )
                ],
              ),
              child: CachedNetworkImage(
                  width: widget.width,
                  height: widget.height,
                  fit: BoxFit.cover,
                  imageUrl:
                      "https://tv.ucommuner.com/${widget.img}?imageView2/1/w/$imgW/h/$imgH/format/webp",
                  errorWidget: (context, url, error) => Icon(Icons.error))),
          Container(
              width: widget.width,
              child: Text(widget.title,
                  maxLines: 1,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: color),
                  overflow: TextOverflow.ellipsis))
        ]));
  }
}
