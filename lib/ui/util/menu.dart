import 'package:flutter/material.dart';

class Menu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final li = <String>["电视", "电影", "设置"];
    return Container(
        width: 48,
        decoration: BoxDecoration(
            gradient: RadialGradient(colors: [
          Color(0xFFFFFF00),
          Color(0xFF00FF00),
          Color(0xFF00FFFF)
        ])),
        child: Center(
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: li.length,
                itemBuilder: (BuildContext context, int position) {
                  return Text(
                    li[position],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16.0,
                      height: 1.5,
                      color: Colors.grey,
                    ),
                  );
                })));
  }
}
