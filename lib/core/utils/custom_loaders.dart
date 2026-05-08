import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class CustomLoaders {
  static void config(BuildContext context) {
    EasyLoading.instance
      ..lineWidth = 5
      ..loadingStyle = .custom
      ..boxShadow = []
      ..indicatorType = .ring
      ..indicatorColor = Colors.amber
      ..textColor = Theme.of(context).colorScheme.onPrimary
      ..maskType = .black
      ..userInteractions = false
      ..backgroundColor = Colors.transparent
      ..dismissOnTap = false;
  }

  static void showLoading() {
    EasyLoading.show();
  }

  static void hideLoading() {
    EasyLoading.dismiss();
  }
}
