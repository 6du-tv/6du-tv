import 'package:flutter/material.dart';

class Menu extends StatelessWidget {
  final padding = 6.0;
  @override
  Widget build(BuildContext context) {
    final li = <String>["电视", "电影", "设置"];
    return Container(
        height: 33,
        padding: EdgeInsets.only(left: padding, right: padding),
        margin: EdgeInsets.only(bottom: padding),
        child: Center(
          child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: li.length,
              itemBuilder: (BuildContext context, int position) {
                final FocusNode focusNode = Focus.of(context);
                final bool hasFocus = focusNode.hasFocus;
                print("hasFocus $hasFocus");
                return GestureDetector(
                  onTap: () {
                    focusNode.requestFocus();
                  },
                  child: Padding(
                      child:
                          Focus(child: Builder(builder: (BuildContext context) {
                        return Text(
                          li[position],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14.0,
                            color: Colors.grey,
                          ),
                        );
                      })),
                      padding: EdgeInsets.all(padding)),
                );
              }),
        ));
  }
}
