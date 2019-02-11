
import 'package:flutter/material.dart';
import 'package:tiny_release/screens/control/control_helper.dart';
import 'package:tiny_release/util/BaseUtil.dart';
import 'package:tiny_release/util/ControlState.dart';

typedef Null ItemSelectedCallback(int value);

class PeopleEditWidget extends StatefulWidget {

  final ControlScreenState _controlState;

  PeopleEditWidget(this._controlState);

  @override
  _PeopleEditWidgetState createState() => _PeopleEditWidgetState(_controlState);
}

class _PeopleEditWidgetState extends State<PeopleEditWidget> {
  final ControlScreenState _controlState;

  _PeopleEditWidgetState(this._controlState);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: !BaseUtil.isLargeScreen(context) ? AppBar(
          title: Text("Edit"),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.save_alt),
              tooltip: 'Save',
              onPressed: () => ControlHelper.handleSaveButton( _controlState, Navigator.of(context) ),
            ),
            IconButton(
              icon: Icon(Icons.contacts),
              tooltip: 'Import',
              onPressed: () => ControlHelper.initContactImport( _controlState, Navigator.of(context) ),
            ),
          ],
        ) : null,
        body: Text("Edit People")
    );
  }

}