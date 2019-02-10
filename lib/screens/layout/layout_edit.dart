
import 'package:flutter/material.dart';
import 'package:tiny_release/screens/control/control_helper.dart';
import 'package:tiny_release/util/BaseUtil.dart';
import 'package:tiny_release/util/ControlState.dart';

typedef Null ItemSelectedCallback(int value);

class LayoutEditWidget extends StatefulWidget {

  final ControlScreenState _controlState;

  LayoutEditWidget( this._controlState );

  @override
  _LayoutEditWidgetState createState() => _LayoutEditWidgetState(_controlState);
}

class _LayoutEditWidgetState extends State<LayoutEditWidget> {
  final ControlScreenState _controlState;

  _LayoutEditWidgetState(this._controlState);

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
                _controlState.setToolbarButtonsOnEdit();
                ControlHelper.handleSaveButton( _controlState, Navigator.of(context) );
              },
            ),
          ],
        ) : null,
        body: Text("Edit Layout")
    );
  }

}