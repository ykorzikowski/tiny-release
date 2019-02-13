
import 'package:flutter/material.dart';
import 'package:tiny_release/screens/control/control_helper.dart';
import 'package:tiny_release/util/BaseUtil.dart';
import 'package:tiny_release/util/tiny_state.dart';

typedef Null ItemSelectedCallback(int value);

class PresetEditWidget extends StatefulWidget {

  final TinyState _controlState;

  PresetEditWidget( this._controlState );

  @override
  _PresetEditWidgetState createState() => _PresetEditWidgetState(_controlState);
}

class _PresetEditWidgetState extends State<PresetEditWidget> {
  final TinyState _controlState;

  _PresetEditWidgetState(this._controlState);

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
        body: Text("Edit Preset")
    );
  }

}