import 'package:flutter/material.dart';

class Menu extends StatefulWidget {
  @override
  _MenuState createState() => _MenuState();
  int now;

  Menu(int now, {Key key})
      : this.now = now,
        super(key: key);
}

class _MenuState extends State<Menu> {
  final padding = 6.0;

  @override
  Widget build(BuildContext context) {
    final li = <String>["电视", "电影", "设置"];
    return Expanded(
      child: Container(
          padding: EdgeInsets.only(left: padding, right: padding),
          margin: EdgeInsets.only(bottom: padding),
          child: Center(
            child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: li.length,
                itemBuilder: (BuildContext context, int position) {
                  return Focus(
                    skipTraversal: this.widget.now == position,
                    child: Builder(builder: (BuildContext context) {
                      final FocusNode focusNode = Focus.of(context);
                      final bool hasFocus = focusNode.hasFocus;
                      BoxDecoration decoration;
                      Color color;

                      if (position == this.widget.now) {
                        color = Colors.grey;

                        decoration = BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                          color: Colors.grey,
                          width: 1.5,
                        )));
                      } else {
                        color = hasFocus ? Colors.yellow : Colors.grey;
                        decoration = null;
                      }

                      return GestureDetector(
                          onTap: () {
                            focusNode.requestFocus();
                            setState(() {
                              this.widget.now = position;
                            });
                          },
                          child: Padding(
                              child: Container(
                                  decoration: decoration,
                                  child: Padding(
                                    padding: EdgeInsets.only(bottom: padding),
                                    child: Text(
                                      li[position],
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: color,
                                      ),
                                    ),
                                  )),
                              padding: EdgeInsets.fromLTRB(
                                  padding, padding, padding, 0)));
                    }),
                  );
                }),
          )),
    );
  }
}
