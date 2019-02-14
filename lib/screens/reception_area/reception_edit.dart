
import 'package:flutter/material.dart';
import 'package:tiny_release/data/tiny_reception.dart';
import 'package:tiny_release/screens/control/control_helper.dart';
import 'package:tiny_release/util/BaseUtil.dart';
import 'package:tiny_release/util/tiny_state.dart';

typedef Null ItemSelectedCallback(int value);

class ReceptionEditWidget extends StatefulWidget {

  final TinyState _controlState;

  ReceptionEditWidget( this._controlState );

  @override
  _ReceptionEditWidgetState createState() => _ReceptionEditWidgetState(_controlState);
}

class _ReceptionEditWidgetState extends State<ReceptionEditWidget> {
  final TinyState _controlState;

  _ReceptionEditWidgetState(this._controlState);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: !BaseUtil.isLargeScreen(context) ? AppBar(
          title: Text("Edit"),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.save_alt),
              tooltip: 'Save',
              onPressed: () {
                ControlHelper.handleSaveButton( _controlState, Navigator.of(context) );
              },
            ),
          ],
        ) : null,
        body: Text("Edit Reception")
    );
  }

}