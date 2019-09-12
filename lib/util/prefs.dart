
import 'package:shared_preferences/shared_preferences.dart';

class Prefs {

  static const String firstLaunch = "first_launch";
  static const String userReporting = "user_reporting";

  static bool nullMeansTrue(bool) => bool == null ? true : bool;

  static bool nullMeansFalse(bool) => bool == null ? false : bool;

  static Future<bool> get errorReportingIsAllowed async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return Prefs.nullMeansFalse(prefs.getBool(userReporting));
  }

  static Future<bool> get isFirstLaunch async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return Prefs.nullMeansFalse(prefs.getBool(firstLaunch));
  }

  static setFirstLaunch(bool) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setBool(firstLaunch, bool);
  }


}
