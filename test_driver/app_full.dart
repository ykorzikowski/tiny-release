import 'package:flutter/material.dart';

import 'package:flutter_driver/driver_extension.dart';
import 'package:paperflavor/main.dart' as app;

void main() {
  // This line enables the extension
  // enableFlutterDriverExtension();

  // Call the `main()` function of your app or call `runApp` with any widget you
  // are interested in testing.
  // app.main();

  // Enable integration testing with the Flutter Driver extension.
  // See https://flutter.io/testing/ for more info.
  enableFlutterDriverExtension();
  WidgetsApp.debugAllowBannerOverride = false; // remove debug banner
  app.main();
}
