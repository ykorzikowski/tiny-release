import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:sentry/sentry.dart';

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

bool get checkUserDeniedTracking {

  // TODO: implement me

  return false;
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
  if (isInDebugMode) {
    // Print the full stacktrace in debug mode.
    print(stackTrace);
    return;
  } else {
    // Send the Exception and Stacktrace to Sentry in Production mode.
    _sentry.captureException(
      exception: error,
      stackTrace: stackTrace,
    );
  }
}

