
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tiny_release/data/data_types.dart';
import 'package:tiny_release/data/repo/sqlite_provider.dart';
import 'package:tiny_release/util/tiny_state.dart';

typedef Null ItemSelectedCallback(int value);

class SettingsWidget extends StatefulWidget {

  final TinyState _controlState;

  SettingsWidget(this._controlState);

  @override
  _SettingsWidgetState createState() => _SettingsWidgetState(_controlState);
}

class _SettingsWidgetState extends State<SettingsWidget> {
  final TinyState _controlState;

  _SettingsWidgetState(this._controlState);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text("Einstellungen"),
      ),
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        body: ListView(
          shrinkWrap: true,
          children: <Widget>[

            Divider(),

            CupertinoButton(
              child: Text("Lösche alle Daten"),
              color: CupertinoColors.destructiveRed,
              onPressed: () async {
                  final db = await SQLiteProvider.db.database;
                  db.delete(DataType.SETTINGS);
                  db.delete(DataType.CONTRACT);
                  db.delete(DataType.WORDING);
                  db.delete(DataType.PEOPLE_ADDRESS);
                  db.delete(DataType.PEOPLE_ITEM);
                  db.delete(DataType.PEOPLE);
                  db.delete(DataType.LAYOUT);
                  db.delete(DataType.RECEPTION);
                  db.delete(DataType.PARAGRAPH);
                  db.delete(DataType.PRESET);
              },
            )
          ],
        ),),
    );
  }

}