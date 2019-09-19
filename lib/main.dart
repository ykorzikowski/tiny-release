import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui show window;

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:package_info/package_info.dart';
import 'package:paperflavor/util/base_util.dart';
import 'package:paperflavor/util/prefs.dart';
import 'package:sentry/sentry.dart';
import 'package:device_info/device_info.dart';

import 'constants.dart';
import 'main_delegate.dart';

final SentryClient _sentry = SentryClient(dsn: "https://4b5466bcabc64aa9911bc3fd959149c1@crash.korzikowski.de/3");

Future<Null> main() {
  Constants.setEnvironment(Environment.WHITELABEL);

  runZoned<Future<void>>(() async {
    mainDelegate();
  }, onError: (error, stackTrace) {
    // Whenever an error occurs, call the `_reportError` function. This sends
    // Dart errors to the dev console or Sentry depending on the environment.
    _reportError(error, stackTrace);
  });
}

void getExceptionHandler(details,
    {bool forceReport = false}) {
  if (Prefs.isInDebugMode) {
    // In development mode, simply print to console.
    FlutterError.dumpErrorToConsole(details);
  } else {
    // In production mode, report to the application zone to report to
    // Sentry.
    Zone.current.handleUncaughtError(details.exception, details.stack);
  }
}

Future<void> _reportError(dynamic error, dynamic stackTrace) async {
  // Print the exception to the console.
  print('Caught error: $error');
  if (Prefs.isInDebugMode || !(await Prefs.errorReportingIsAllowed)) {
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

Map<String, dynamic> _fixMap(Map input) {
  Map<String, dynamic> fixedMap = {};

  input.forEach((k,v) {

    if (v is Map ) {
      fixedMap[k] = _fixMap(v);
      return;
    }

    fixedMap[k] = v;
  });

  return fixedMap;
}

Future<Map<String, dynamic>> _getDeviceExtra() async {
  final DeviceInfoPlugin info = DeviceInfoPlugin();

  Map<String, dynamic> extra = {};
  if (Platform.isAndroid) {
    extra['device_info'] = _fixMap(await DeviceInfoPlugin.channel.invokeMethod('getAndroidDeviceInfo'));
  }
  else if (Platform.isIOS) {
    extra['device_info'] = _fixMap(await DeviceInfoPlugin.channel.invokeMethod('getIosDeviceInfo'));
  }

  return extra;
}

Future<Map<String, dynamic>> _getTags() async {
  PackageInfo info = await PackageInfo.fromPlatform();

  Map<String, String> tags = {};
  tags['platform'] = defaultTargetPlatform.toString().substring('TargetPlatform.'.length);
  tags['package_name'] = info.packageName;
  tags['build_number'] = info.buildNumber;
  tags['version'] = info.version;
  tags['locale'] = ui.window.locale.toString();

  return tags;
}

Future<SentryResponse> _captureException({
  @required dynamic exception,
  dynamic stackTrace,
}) async {
  final Event event = new Event(
    exception: exception,
    stackTrace: stackTrace,
    extra: await _getDeviceExtra(),
    tags: await _getTags(),
    release: await BaseUtil.getVersionString(),
  );
  return _sentry.capture(event: event);
}

