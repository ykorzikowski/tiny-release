
import 'package:flutter/material.dart';
import 'package:tiny_release/generated/i18n.dart';
import 'package:tiny_release/screens/control/control_helper.dart';
import 'package:tiny_release/util/BaseUtil.dart';
import 'package:tiny_release/util/tiny_state.dart';

typedef Null ItemSelectedCallback(int value);

class LayoutEditWidget extends StatefulWidget {

  final TinyState _controlState;

  LayoutEditWidget( this._controlState );

  @override
  _LayoutEditWidgetState createState() => _LayoutEditWidgetState(_controlState);
}

class _LayoutEditWidgetState extends State<LayoutEditWidget> {
  final TinyState _controlState;

  _LayoutEditWidgetState(this._controlState);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: !BaseUtil.isLargeScreen(context) ? AppBar(
          title: Text(S.of(context).btn_edit),
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
        body: Text("Edit Layout")
    );
  }

}