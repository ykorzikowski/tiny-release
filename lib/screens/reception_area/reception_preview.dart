
import 'package:flutter/material.dart';
import 'package:tiny_release/screens/control/control_helper.dart';
import 'package:tiny_release/util/BaseUtil.dart';
import 'package:tiny_release/util/tiny_state.dart';

typedef Null ItemSelectedCallback(int value);

class ReceptionPreviewWidget extends StatefulWidget {

  final TinyState _controlState;

  ReceptionPreviewWidget(this._controlState);

  @override
  _ReceptionPreviewWidgetState createState() => _ReceptionPreviewWidgetState(_controlState);
}

class _ReceptionPreviewWidgetState extends State<ReceptionPreviewWidget> {
  final TinyState _controlState;

  _ReceptionPreviewWidgetState(this._controlState);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text("Reception Preview"),
      appBar: !BaseUtil.isLargeScreen(context) ? AppBar(
        title: Text("Preview"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.edit),
            tooltip: 'Edit',
            onPressed: () {
            },
          ),
        ],
      ) : null,
    );
  }

}