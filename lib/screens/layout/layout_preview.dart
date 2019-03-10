
import 'package:flutter/material.dart';
import 'package:tiny_release/util/base_util.dart';
import 'package:tiny_release/util/tiny_state.dart';
import 'package:tiny_release/util/nav_routes.dart';

typedef Null ItemSelectedCallback(int value);

class LayoutPreviewWidget extends StatefulWidget {

  final TinyState _controlState;

  LayoutPreviewWidget(this._controlState);

  @override
  _LayoutPreviewWidgetState createState() => _LayoutPreviewWidgetState(_controlState);
}

class _LayoutPreviewWidgetState extends State<LayoutPreviewWidget> {
  final TinyState _controlState;

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
              Navigator.of(context).pushNamed(NavRoutes.LAYOUT_EDIT);
              },
          ),
        ],
      ) : null,
    );
  }

}