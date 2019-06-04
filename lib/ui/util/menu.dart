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
    return Container(
        height: 37,
        padding: EdgeInsets.only(left: padding, right: padding),
        margin: EdgeInsets.only(bottom: padding),
        child: Center(
          child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: li.length,
              itemBuilder: (BuildContext context, int position) {
                return Focus(
                  child: Builder(builder: (BuildContext context) {
                    final FocusNode focusNode = Focus.of(context);
                    final bool hasFocus = focusNode.hasFocus;
                    BoxDecoration decoration;
                    Color color = hasFocus ? Colors.yellow : Colors.grey;
                    print("hasFocus $hasFocus");
                    if (position == this.widget.now) {
                      decoration = BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                        color: color,
                        width: 1,
                      )));
                    } else
                      decoration = null;

                    return GestureDetector(
                        onTap: () {
                          focusNode.requestFocus();
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
                                      fontSize: 14.0,
                                      color: color,
                                    ),
                                  ),
                                )),
                            padding: EdgeInsets.all(padding)));
                  }),
                );
              }),
        ));
  }
}
