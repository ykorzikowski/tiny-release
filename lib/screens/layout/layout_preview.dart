
import 'package:flutter/material.dart';
import 'package:tiny_release/screens/control/control_helper.dart';
import 'package:tiny_release/util/BaseUtil.dart';
import 'package:tiny_release/util/ControlState.dart';

typedef Null ItemSelectedCallback(int value);

class LayoutPreviewWidget extends StatefulWidget {

  final ControlScreenState _controlState;

  LayoutPreviewWidget(this._controlState);

  @override
  _LayoutPreviewWidgetState createState() => _LayoutPreviewWidgetState(_controlState);
}

class _LayoutPreviewWidgetState extends State<LayoutPreviewWidget> {
  final ControlScreenState _controlState;

  _LayoutPreviewWidgetState(this._controlState);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text("Layout Preview"),
      appBar: !BaseUtil.isLargeScreen(context) ? AppBar(
        title: Text("Preview"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.edit),
            tooltip: 'Edit',
            onPressed: () {
              ControlHelper.handleEditButton( _controlState, Navigator.of(context) );
            },
          ),
        ],
      ) : null,
    );
  }

}