
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:paperflavor/generated/i18n.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AllowReportingDialog {

  _setReportingBool(bool) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("user_reporting", bool);
  }

  Widget buildDialog(context) =>
      CupertinoAlertDialog(
        title: Text("Allow Error Reporting"),
        content: Text("On occurence of an error, the app will report this error to a server. No user data will be transmitted. For detail, check the privacy declaration."),
        actions: <Widget>[
          CupertinoDialogAction(
            child: Text(S.of(context).allow),
            onPressed: () {
              _setReportingBool(true);
              Navigator.of(context).pop();
            }
          ),
          CupertinoDialogAction(
            child: Text(S.of(context).decline),
            onPressed: () {
              _setReportingBool(false);
              Navigator.of(context).pop();
           }
          )
        ],
      );

}
