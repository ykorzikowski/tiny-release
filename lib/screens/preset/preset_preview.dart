
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tiny_release/data/tiny_preset.dart';
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
  TinyPreset _tinyPreset;

  _PresetPreviewWidgetState(this._controlState) {
    _tinyPreset = _controlState.curDBO;
  }

  List< Widget > _getParagraphWidgets() =>
      _tinyPreset.paragraphs.map((para) =>
          Container(
            child:
              Column(
                children: <Widget>[
                  Divider(),
                  Text(para.title, style: TextStyle(
                    fontSize: 26.0,
                  ),),
                  Container(
                      child: Text(para.content,softWrap: true,)
                  ),
                ],
              ),
          ),
      ).toList();


  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        border: null,
        middle: Text(_tinyPreset.title),
        trailing: CupertinoButton(
          child: Text("Bearbeiten"),
          onPressed: () =>
              Navigator.of(context).pushNamed(NavRoutes.PRESET_EDIT),
        ),),
      child:
      Scaffold(
        body: SafeArea(
            child: ListView(children: <Widget>[
              _tinyPreset.subtitle != null ? Text(
                _tinyPreset.subtitle,
                style: TextStyle(fontSize: 26.0,),
                textAlign: TextAlign.center,
              ) : Container(),
              _tinyPreset.language != null ? Text(
                _tinyPreset.language,
                style: TextStyle(fontSize: 26.0,),
                textAlign: TextAlign.center,
              ) : Container(),
              _tinyPreset.description != null ? Text(
                _tinyPreset.description,
                style: TextStyle(fontSize: 26.0,),
                textAlign: TextAlign.center,
              ) : Container(),
          Column(children: _getParagraphWidgets(),),
            ],)
        ),

      ),
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