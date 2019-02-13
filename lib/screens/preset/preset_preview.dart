
import 'package:flutter/material.dart';
import 'package:tiny_release/data/tiny_preset.dart';
import 'package:tiny_release/screens/control/control_helper.dart';
import 'package:tiny_release/screens/preset/preset_edit.dart';
import 'package:tiny_release/util/BaseUtil.dart';
import 'package:tiny_release/util/NavRoutes.dart';
import 'package:tiny_release/util/tiny_state.dart';

typedef Null ItemSelectedCallback(int value);

class PresetPreviewWidget extends StatefulWidget {

  final TinyState _controlState;

  PresetPreviewWidget(this._controlState);

  @override
  _PresetPreviewWidgetState createState() => _PresetPreviewWidgetState(_controlState);
}

class _PresetPreviewWidgetState extends State<PresetPreviewWidget> {
  final TinyState _controlState;

  _PresetPreviewWidgetState(this._controlState);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text("Preset Preview - " + getText()),
      appBar: !BaseUtil.isLargeScreen(context) ? AppBar(
        title: Text("Preview"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.edit),
            tooltip: 'Edit',
            onPressed: () {
              Navigator.of(context).pushNamed(NavRoutes.PRESET_EDIT);
            },
          ),
        ],
      ) : null,
    );
  }

  String getText() {
    TinyPreset curDBO = _controlState.curDBO;
    if ( curDBO.paragraphs == null) {
      return "NULL";
    }
    return curDBO.paragraphs.first != null ? curDBO.paragraphs.first.title : "NULL";
  }

}