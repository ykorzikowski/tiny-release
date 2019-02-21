
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tiny_release/data/repo/tiny_paragraph_repo.dart';
import 'package:tiny_release/data/repo/tiny_preset_repo.dart';
import 'package:tiny_release/data/tiny_preset.dart';
import 'package:tiny_release/generated/i18n.dart';
import 'package:tiny_release/util/BaseUtil.dart';
import 'package:tiny_release/util/tiny_state.dart';

typedef Null ItemSelectedCallback(int value);

class PresetParagraphSortWidget extends StatefulWidget {

  final TinyState _controlState;

  PresetParagraphSortWidget( this._controlState );

  @override
  _PresetParagraphSortWidgetState createState() => _PresetParagraphSortWidgetState(_controlState);
}

class _PresetParagraphSortWidgetState extends State<PresetParagraphSortWidget> {
  final TinyState _controlState;
  TinyPreset _tinyPreset;
  final TinyPresetRepo _tinyPresetRepo = TinyPresetRepo();
  final ParagraphRepo _paragraphRepo = ParagraphRepo();

  _PresetParagraphSortWidgetState(this._controlState) {
    _tinyPreset = TinyPreset.fromMap( TinyPreset.toMap (_controlState.curDBO ) );
  }

   _getParagraphWidgets() {
    var list = List< Widget >();

    for (int i = 0; i < _tinyPreset.paragraphs.length; i++) {
      var para = _tinyPreset.paragraphs[i];
      list.add(
          ListTile(
            key: Key(para.hashCode.toString()),
            trailing: CupertinoButton(child: Icon(CupertinoIcons.delete_simple), onPressed: () {
              setState(() {
                _tinyPreset.paragraphs.remove(para);
              });
              _paragraphRepo.delete(para);
            }),
            leading: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  child: _getParagraphWidget(para, i+1)
                ),
              ],
            ),
          )
      );
    }

    return list;
  }

  Widget _getParagraphWidget(Paragraph para, int index) =>
      Column(children: <Widget>[
        Text(BaseUtil.getParagraphTitle(context, para, index), style: TextStyle( fontSize: 24 ), ),
        Text(para.content, textAlign: TextAlign.left,)
      ]
      );

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        heroTag: 'control',
        transitionBetweenRoutes: false,
        middle: Text(S.of(context).change_order_title),
        trailing: CupertinoButton(
          child: Text(S.of(context).btn_save),
          onPressed:() {
            _tinyPresetRepo.save(_tinyPreset);
            Navigator.of(context).pop();
            setState(() {
              _controlState.curDBO = _tinyPreset;
              _controlState.tinyEditCallback();
            });
          }),),
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        body: SafeArea(
          child: ReorderableListView(
              children: _getParagraphWidgets(),
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              onReorder: (oldIndex, newIndex) {
                setState(() {
                  if (newIndex > oldIndex) {
                    newIndex -= 1;
                  }
                  final Paragraph item = _tinyPreset.paragraphs.removeAt(oldIndex);
                  _tinyPreset.paragraphs.insert(newIndex, item);
                });
              },
            ),
          ),
        ),
    );
  }

}