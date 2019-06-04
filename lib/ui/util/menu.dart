import 'package:flutter/material.dart';

class Menu extends StatelessWidget {
  final padding = 6.0;
  @override
  Widget build(BuildContext context) {
    final li = <String>["电视", "电影", "设置"];
    return Container(
        height: 33,
        padding: EdgeInsets.only(left: padding, right: padding),
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF252423), Color(0xFF101010)])),
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: li.length,
            itemBuilder: (BuildContext context, int position) {
              return Padding(
                  child: Text(
                    li[position],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.grey,
                    ),
                  ),
                  padding: EdgeInsets.all(padding));
            }));
  }
}
