
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tiny_release/data/tiny_preset.dart';
import 'package:tiny_release/generated/i18n.dart';
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
  TinyPreset _tinyPreset;

  _PresetPreviewWidgetState(this._controlState) {
    _tinyPreset = _controlState.curDBO;
  }

  _getParagraphWidgets() {
    var list = List<Widget>();
    for (int i = 0; i < _tinyPreset.paragraphs.length; i++) {
      var para = _tinyPreset.paragraphs[i];
      list.add(
        Container(
          child:
          Column(
            children: <Widget>[
              Divider(),
              Text(BaseUtil.getParagraphTitle(context, para, i+1), style: TextStyle(
                fontSize: 26.0,
              ),),
              Container(
                  child: Text(para.content,softWrap: true,)
              ),
            ],
          ),
        ),
      );
    }
    return list;
  }



  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        heroTag: 'control',
        transitionBetweenRoutes: false,
        border: null,
        middle: Text(_tinyPreset.title),
        trailing: CupertinoButton(
          child: Text(S.of(context).btn_edit),
          onPressed: () =>
              Navigator.of(context).pushNamed(NavRoutes.PRESET_EDIT),
        ),),
      child:
      Scaffold(
        resizeToAvoidBottomPadding: false,
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