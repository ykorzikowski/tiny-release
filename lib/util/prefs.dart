
import 'package:shared_preferences/shared_preferences.dart';

class Prefs {

  static const String reportingDialogShown = "reporting_dialog_shown";
  static const String userReporting = "user_reporting";

  static bool nullMeansTrue(bool) => bool == null ? true : bool;

  static bool nullMeansFalse(bool) => bool == null ? false : bool;

  static Future<bool> get errorReportingIsAllowed async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return Prefs.nullMeansFalse(prefs.getBool(userReporting));
  }

  static Future<bool> get reportingDialogShownOnFirstStart async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return Prefs.nullMeansTrue(prefs.getBool(reportingDialogShown));
  }

  static setReportingDialogShownOnFirstStart(bool) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setBool(reportingDialogShown, bool);
  }

  static bool get isInDebugMode {
    // Assume you're in production mode.
    bool inDebugMode = false;

    // Assert expressions are only evaluated during development. They are ignored
    // in production. Therefore, this code only sets `inDebugMode` to true
    // in a development environment.
    assert(inDebugMode = true);

    return inDebugMode;
  }

}
