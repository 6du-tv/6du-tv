import 'package:flutter/services.dart';
import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

const UPDATE_CHECK = "updateCheck";

void autoUpdate() {
  Future.delayed(Duration(seconds: 1), () async {
    SharedPreferences kv = await SharedPreferences.getInstance();
    final updateCheck = kv.getInt(UPDATE_CHECK) ?? 0;
    final int now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
/*
    if ((now - updateCheck) < 86400) {
      return;
    }
    */
    List<String> version =
        (await rootBundle.loadString('sh/release/npm/version/version.txt'))
            .split("\n");
    print(version);
    final data = await PackageInfo.fromPlatform();

    print(data.version);
    kv.setInt(UPDATE_CHECK, now);
  });
}
