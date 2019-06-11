import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Menu extends StatefulWidget {
  @override
  _MenuState createState() => _MenuState(position);
  final Function(List<String>, int) goto;
  final int position;
  Menu(this.goto, this.position, {Key key}) : super(key: key);
}

class _MenuState extends State<Menu> {
  final padding = 6.0;
  int now;
  _MenuState(this.now);
  @override
  Widget build(BuildContext context) {
    final li = <String>[
      "最新",
      "历史",
      "收藏",
      "电视",
      "电影",
      "设置",
    ];
    final url = <String>[
      'lastest',
      'histroy',
      'star',
      'tv',
      'film',
      'setting',
    ];
    List<Widget> left = <Widget>[];
    List<Widget> right = <Widget>[];
    List<Widget> t = left;
    for (int position = 0; position < li.length; ++position) {
      Widget focus = Focus(
          //                skipTraversal: this.widget.now == position,
          onKey: (FocusNode node, RawKeyEvent event) {
        if (event is RawKeyDownEvent) {
          if (event.logicalKey == LogicalKeyboardKey(0x100070077) ||
              event.logicalKey == LogicalKeyboardKey.enter) {
            node.unfocus();
            setState(() {
              this.now = position;
            });
            this.widget.goto(url, position);
            return true;
          }
        }
        return false;
      }, child: Builder(builder: (BuildContext context) {
        final FocusNode focusNode = Focus.of(context);
        final bool hasFocus = focusNode.hasFocus;
        BoxDecoration decoration;
        Color color;
        if (hasFocus) {
          if (this.now == position) {
            color = Colors.orange;
          } else
            color = Colors.yellow;
        } else {
          color = Colors.grey;
        }
        if (position == this.now) {
          decoration = BoxDecoration(
              border: Border(
                  bottom: BorderSide(
            color: color,
            width: 1.4,
          )));
        }

        return GestureDetector(
            onTap: () {
              focusNode.requestFocus();
              setState(() {
                this.now = position;
              });
              this.widget.goto(url, position);
            },
            child: Padding(
                child: Container(
                    decoration: decoration,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: padding / 2),
                      child: Text(
                        li[position],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: color,
                        ),
                      ),
                    )),
                padding: EdgeInsets.fromLTRB(padding, padding, padding, 0)));
      }));

      if (position == 5) {
        t = right;
      }

      t.add(focus);
    }

    return Container(
        padding: EdgeInsets.only(left: padding, right: padding),
        margin: EdgeInsets.only(bottom: padding),
        child: Center(
            child: Row(
                children: <Widget>[Row(children: left), Row(children: right)],
                mainAxisAlignment: MainAxisAlignment.spaceBetween)));
  }
}
