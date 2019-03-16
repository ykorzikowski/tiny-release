
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tiny_release/data/data_types.dart';
import 'package:tiny_release/data/repo/sqlite_provider.dart';
import 'package:tiny_release/generated/i18n.dart';
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
        transitionBetweenRoutes: false,
        heroTag: 'control',
        middle: Text(S.of(context).title_settings),
      ),
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[

              Divider(),

              CupertinoButton(
                child: Text(S.of(context).btn_delete_all),
                color: CupertinoColors.destructiveRed,
                onPressed: () async {
                    final db = await SQLiteProvider.db.database;
                    db.delete(TableName.SETTINGS);
                    db.delete(TableName.CONTRACT);
                    db.delete(TableName.WORDING);
                    db.delete(TableName.PEOPLE_ADDRESS);
                    db.delete(TableName.PEOPLE_ITEM);
                    db.delete(TableName.PEOPLE);
                    db.delete(TableName.LAYOUT);
                    db.delete(TableName.RECEPTION);
                    db.delete(TableName.PARAGRAPH);
                    db.delete(TableName.PRESET);
                },
              )
            ],
          ),
        ),),
    );
  }

}