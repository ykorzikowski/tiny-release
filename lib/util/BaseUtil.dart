import 'package:flutter/cupertino.dart';

class BaseUtil {
  static bool isLargeScreen(context) {
    return MediaQuery.of(context).size.width > 600;
  }
}