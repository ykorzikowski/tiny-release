import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:package_info/package_info.dart';
import 'package:paperflavor/util/base_util.dart';
import 'package:sentry/sentry.dart';
import 'package:device_info/device_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'constants.dart';
import 'main_delegate.dart';

final SentryClient _sentry = SentryClient(dsn: "https://4b5466bcabc64aa9911bc3fd959149c1@crash.korzikowski.de/3");

Future<Null> main() {
  Constants.setEnvironment(Environment.WHITELABEL);

  // This captures errors reported by the Flutter framework.
  FlutterError.onError = (FlutterErrorDetails details) {
    if (isInDebugMode) {
      // In development mode, simply print to console.
      FlutterError.dumpErrorToConsole(details);
    } else {
      // In production mode, report to the application zone to report to
      // Sentry.
      Zone.current.handleUncaughtError(details.exception, details.stack);
    }
  };

  runZoned<Future<void>>(() async {
    mainDelegate();
  }, onError: (error, stackTrace) {
    // Whenever an error occurs, call the `_reportError` function. This sends
    // Dart errors to the dev console or Sentry depending on the environment.
    _reportError(error, stackTrace);
  });
}

bool get isInDebugMode {
  // Assume you're in production mode.
  bool inDebugMode = false;

  // Assert expressions are only evaluated during development. They are ignored
  // in production. Therefore, this code only sets `inDebugMode` to true
  // in a development environment.
  assert(inDebugMode = true);

  return inDebugMode;
}

Future<void> _reportError(dynamic error, dynamic stackTrace) async {
  // Print the exception to the console.
  print('Caught error: $error');
  if (isInDebugMode || !(await BaseUtil.errorReportingIsAllowed)) {
    // Print the full stacktrace in debug mode.
    print(stackTrace);
    return;
  } else {
    // Send the Exception and Stacktrace to Sentry in Production mode.
    await _captureException(
      exception: error,
      stackTrace: stackTrace,
    );
  }
}

_getDeviceExtra() async {
  final DeviceInfoPlugin info = DeviceInfoPlugin();

  Map<String, dynamic> extra = {};
  if (Platform.isAndroid) {
    extra['device_info'] = await info.androidInfo;
  }
  else if (Platform.isIOS) {
    extra['device_info'] = await info.iosInfo;
  }

  return extra;
}

Future<SentryResponse> _captureException({
  @required dynamic exception,
  dynamic stackTrace,
}) async {
  final Event event = new Event(
    exception: exception,
    stackTrace: stackTrace,
    extra: await _getDeviceExtra(),
    release: await BaseUtil.getVersionString(),
  );
  return _sentry.capture(event: event);
}

