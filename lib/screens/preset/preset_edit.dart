
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tiny_release/data/repo/tiny_paragraph_repo.dart';
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
  final ParagraphRepo _paragraphRepo = ParagraphRepo();
  TinyPreset _tinyPreset;

  _PresetEditWidgetState(this._controlState) {
    _tinyPreset = TinyPreset.fromMap( TinyPreset.toMap (_controlState.curDBO ) );
  }

  ///
  /// validation
  ///

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
    var textEditingController = TextEditingController(text: val);
    textEditingController.addListener(() => setState(() => validPreset()));
    return textEditingController;
  }

  _getParagraphAddButton() =>
      CupertinoButton(
        child:
          Text(S.of(context).btn_add_paragrpah, key: Key('btn_add_paragraph'),),
        onPressed: () =>
            setState(() => _tinyPreset.paragraphs.add(Paragraph(position: (_tinyPreset.paragraphs.length+1)))),
      );

  _getSortParagraphsButton() => CupertinoButton(
    child: Text(S.of(context).change_order_title),
    onPressed: validPreset() ? () {
      _controlState.curDBO = _tinyPreset;
      _controlState.tinyEditCallback = () {
        _tinyPreset = TinyPreset.fromMap( TinyPreset.toMap (_controlState.curDBO ) );
      };
      Navigator.of(context).pushNamed(NavRoutes.PRESET_PARAGRAPH_EDIT);
    } : null,
  );

  /// get paragraphs widgets
  List< Widget > _getParagraphWidgets() {
    var list = List<Widget>();

    for ( int i = 0; i <  _tinyPreset.paragraphs.length; i++ ) {
      var para = _tinyPreset.paragraphs[i];
      list.add(
          Column(
            children: <Widget>[
              Divider(),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 4.0),
                child:
                Dismissible(
                    direction: DismissDirection.endToStart,
                    background: BaseUtil.getDismissibleBackground(),
                    key: Key('para_dismiss_$i'),
                    onDismissed: (direction) =>
                        setState(() {
                          _tinyPreset.paragraphs.remove(para);
                          _paragraphRepo.delete(para);
                        }),
                    child: _getParagraphWidget(para, i)
                ),
              ),
            ],
          ));
    }
    return list;
  }

  Widget _getParagraphWidget(Paragraph para, index) =>
      Column(children: <Widget>[
        Padding(
          padding: EdgeInsets.all(12.0),
          child: CupertinoTextField(
            key: Key('tf_paragraph_title_$index'),
            onChanged: (t) => para.title = t,
            controller: initialValue(para.title),
            keyboardType: TextInputType.text,
            placeholder: S.of(context).hint_title,
          ),
        ),
        Padding(
          padding: EdgeInsets.all(12.0),
          child: CupertinoTextField(
            key: Key('tf_paragraph_content_$index'),
            onChanged: (t) => para.content = t,
            controller: initialValue(para.content),
            keyboardType: TextInputType.multiline,
            maxLines: 12,
            placeholder: S.of(context).hint_content,
            ),
        ),
        ]
      );

  _getFields() =>
      <Widget>[
        Padding(
          padding: EdgeInsets.all(12.0),
          child: CupertinoTextField(
            key: Key('tf_preset_title'),
            onChanged: (t) => _tinyPreset.title = t,
            controller: initialValue(_tinyPreset.title),
            keyboardType: TextInputType.text,
            placeholder: S.of(context).hint_title,
          ),
        ),
        Padding(
          padding: EdgeInsets.all(12.0),
          child: CupertinoTextField(
            key: Key('tf_preset_subtitle'),
            onChanged: (t) => _tinyPreset.subtitle = t,
            controller: initialValue(_tinyPreset.subtitle),
            keyboardType: TextInputType.text,
            placeholder:  S.of(context).hint_subtitle,
          ),
        ),
        Padding(
          padding: EdgeInsets.all(12.0),
          child: CupertinoTextField(
            key: Key('tf_preset_language'),
            onChanged: (t) => _tinyPreset.language = t,
            controller: initialValue(_tinyPreset.language),
            keyboardType: TextInputType.text,
            placeholder: S.of(context).hint_language,
          ),
        ),
        Padding(
          padding: EdgeInsets.all(12.0),
          child: CupertinoTextField(
            key: Key('tf_preset_description'),
            onChanged: (t) => _tinyPreset.description = t,
            controller: initialValue(_tinyPreset.description),
            keyboardType: TextInputType.text,
            placeholder: S.of(context).hint_description,
          ),
        ),
        Container(
          child: Column(
            children: _getParagraphWidgets(),
          ),
        ),

        BaseUtil.isLargeScreen(context) ? ListTile(
          leading: _getParagraphAddButton(),
          trailing: _getSortParagraphsButton(),
        ) : Column(children: <Widget>[
          _getParagraphAddButton(),
          _getSortParagraphsButton()
        ],),
      ];

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        heroTag: 'control',
        transitionBetweenRoutes: false,
        middle: Text(S.of(context).title_add_preset),
        trailing: CupertinoButton(
          child: Text(S.of(context).btn_save, key: Key('btn_navbar_save')),
          onPressed: validPreset() ? () {
            if (!validPreset()) {
              return;
            }
            new TinyPresetRepo().save(_tinyPreset);
            _controlState.curDBO = _tinyPreset;
            Navigator.of(context).pop();
          } : null,),),
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        body: ListView(
          key: Key('scrlvw_preset_edit'),
          shrinkWrap: true,
          children: _getFields(),
      ),),
    );
  }

}