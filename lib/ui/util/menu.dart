import 'package:flutter/material.dart';

class Menu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final li = <String>["电视", "电影", "设置"];
    return Center(
        child: ListView.builder(
            itemCount: li.length,
            itemBuilder: (BuildContext context, int position) {
              return Text(li[position]);
            }));
  }
}
