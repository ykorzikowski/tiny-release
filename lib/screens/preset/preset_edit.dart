
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_list_drag_and_drop/drag_and_drop_list.dart';
import 'package:flutter_list_drag_and_drop/my_draggable.dart';
import 'package:tiny_release/data/repo/tiny_preset_repo.dart';
import 'package:tiny_release/data/tiny_preset.dart';
import 'package:tiny_release/generated/i18n.dart';
import 'package:tiny_release/util/BaseUtil.dart';
import 'package:tiny_release/util/NavRoutes.dart';
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
  TinyPreset _tinyPreset;

  _PresetEditWidgetState(this._controlState) {
    _tinyPreset = TinyPreset.fromMap( TinyPreset.toMap (_controlState.curDBO ) );
  }

  bool validParagraphs() {
    for ( var para in _tinyPreset.paragraphs ) {
      if ( !validParagraph(para) ) {
        return false;
      }
    }
    return true;
  }

  bool validParagraph(Paragraph paragraph) {
    return paragraph.content != null && paragraph.content.isNotEmpty &&
      paragraph.title != null && paragraph.title.isNotEmpty;
  }

  bool validPreset() {
    return _tinyPreset.title != null && _tinyPreset.title.isNotEmpty &&
        _tinyPreset.paragraphs.length > 0 && validParagraphs() ;
  }

  initialValue(val) {
    return TextEditingController(text: val);
  }

  CupertinoButton _getParagraphAddButton() =>
      CupertinoButton(
        child: Row(children: <Widget>[
          IconTheme(data: IconThemeData(color: CupertinoColors.activeGreen),
              child: Icon(CupertinoIcons.add_circled_solid)),
          Text(S.of(context).btn_add_paragrpah),
        ],),
        onPressed: () =>
            setState(() => _tinyPreset.paragraphs.add(Paragraph())),
      );

  /// get phone widgets
  List< Widget > _getParagraphWidgets() =>
      _tinyPreset.paragraphs.map((para) =>
          Column(
            children: <Widget>[
              Divider(),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 4.0),
                child:
                Dismissible(
                    direction: DismissDirection.endToStart,
                    background: BaseUtil.getDismissibleBackground(),
                    key: Key(para.hashCode.toString()),
                    onDismissed: (direction) =>
                        setState(() {
                          _tinyPreset.paragraphs.remove(para);
                        }),
                    child: _getParagraphWidget(para)
                ),
              ),
            ],
          ),
      ).toList();

  Widget _getParagraphWidget(Paragraph para) =>
      Column(children: <Widget>[
        Padding(
          padding: EdgeInsets.all(12.0),
          child: TextField(
            onChanged: (t) => para.title = t,
            controller: initialValue(para.title),
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              border: UnderlineInputBorder(),
              hintText: S.of(context).hint_title,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(12.0),
          child: TextField(
            onChanged: (t) => para.content = t,
            controller: initialValue(para.content),
            keyboardType: TextInputType.multiline,
            maxLines: 12,
            decoration: InputDecoration(
              border: UnderlineInputBorder(),
              hintText: S.of(context).hint_content,
            ),
          ),
        ),
        ]
      );

  _getFields() =>
      <Widget>[
        Padding(
          padding: EdgeInsets.all(12.0),
          child: TextField(
            onChanged: (t) => _tinyPreset.title = t,
            controller: initialValue(_tinyPreset.title),
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              border: UnderlineInputBorder(),
              hintText: S.of(context).hint_title,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(12.0),
          child: TextField(
            onChanged: (t) => _tinyPreset.subtitle = t,
            controller: initialValue(_tinyPreset.subtitle),
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              border: UnderlineInputBorder(),
              hintText: S.of(context).hint_subtitle,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(12.0),
          child: TextField(
            onChanged: (t) => _tinyPreset.language = t,
            controller: initialValue(_tinyPreset.language),
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              border: UnderlineInputBorder(),
              hintText: S.of(context).hint_language,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(12.0),
          child: TextField(
            onChanged: (t) => _tinyPreset.description = t,
            controller: initialValue(_tinyPreset.description),
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              border: UnderlineInputBorder(),
              hintText: S.of(context).hint_description,
            ),
          ),
        ),
        Container(
          child: Column(
            children: _getParagraphWidgets(),
          ),
        ),
        _getParagraphAddButton()
      ];

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        heroTag: 'control',
        transitionBetweenRoutes: false,
        middle: Text(S.of(context).title_add_preset),
        trailing: CupertinoButton(
          child: Text(S.of(context).btn_save),
          onPressed: validPreset() ? () {
            if (!validPreset()) {
              return;
            }
            new TinyPresetRepo().save(_tinyPreset);
            _controlState.curDBO = _tinyPreset;
            Navigator.of(context).popUntil((route) => !Navigator.of(context).canPop());
            Navigator.of(context).pushNamed(NavRoutes.PRESET_PREVIEW);
          } : null,),),
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        body: ListView(
          shrinkWrap: true,
          children: _getFields(),
      ),),
    );
  }

}