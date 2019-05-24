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
  double scale = 1;
  Color color = Colors.grey;

  @override
  Widget build(BuildContext context) {
    final widget = this.widget;

    final imgW = (widget.width * window.devicePixelRatio).toInt().toString();
    final imgH = (widget.height * window.devicePixelRatio).toInt().toString();

    return GestureDetector(
        onTap: widget.onTap,
        child: Transform.scale(
            scale: scale,
            child: Column(children: <Widget>[
              Container(
                  width: widget.width,
                  color: Colors.black12,
                  margin: EdgeInsets.only(bottom: widget.padding),
                  height: widget.height,
                  child: CachedNetworkImage(
                      width: widget.width,
                      height: widget.height,
                      fit: BoxFit.cover,
                      imageUrl:
                          "https://tv.ucommuner.com/${widget.img}?imageView2/1/w/$imgW/h/$imgH/format/webp",
                      errorWidget: (context, url, error) => Icon(Icons.error))),
              FittedBox(
                  fit: BoxFit.contain,
                  child: Text(widget.title,
                      style: TextStyle(color: color),
                      overflow: TextOverflow.fade))
            ])));
  }
}
