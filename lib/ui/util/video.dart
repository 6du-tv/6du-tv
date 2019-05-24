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
  @override
  Widget build(BuildContext context) {
    final widget = this.widget;
    return GestureDetector(
        onTap: widget.onTap,
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
                      "https://tv.ucommuner.com/${o[1]}?imageView2/1/w/$imgW/h/$imgH/format/webp",
                  errorWidget: (context, url, error) => Icon(Icons.error))),
          Text(widget.title, style: TextStyle(color: Colors.grey))
        ]));
  }
}
