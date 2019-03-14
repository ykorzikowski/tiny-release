

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tiny_release/data/repo/tiny_paragraph_repo.dart';
import 'package:tiny_release/data/repo/tiny_preset_repo.dart';
import 'package:tiny_release/data/tiny_preset.dart';
import 'package:tiny_release/generated/i18n.dart';
import 'package:tiny_release/screens/preset/preset_json_parser.dart';
import 'package:tiny_release/util/base_util.dart';
import 'package:tiny_release/util/nav_routes.dart';
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
  final TinyPresetRepo _tinyPresetRepo = TinyPresetRepo();
  TinyPreset _tinyPreset;

  _TextControllerBundle _textEditControllerBundle;
  final Map<Paragraph, _ParagraphControllerBundle> _paragraphTextControllers = Map();

  _PresetEditWidgetState(this._controlState);

  @override
  void initState() {
    super.initState();

    _tinyPreset = TinyPreset.fromMap( TinyPreset.toMap (_controlState.curDBO ) );

    _initParagraphControllers();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        heroTag: 'control',
        transitionBetweenRoutes: false,
        middle: Text(S.of(context).title_add_preset),
        trailing: CupertinoButton(
          child: Text(S.of(context).btn_save, key: Key('btn_navbar_save')),
          onPressed: validPreset() ? _onPresetSavePressed : null,),),
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        body: ListView(
          key: Key('scrlvw_preset_edit'),
          shrinkWrap: true,
          children: _buildFields(),
        ),),
    );
  }
  
  _onPresetSavePressed() {
    _tinyPresetRepo.save(_tinyPreset);
    _controlState.curDBO = _tinyPreset;
    Navigator.of(context).pop();
  }

  _initParagraphControllers() {
    _tinyPreset.paragraphs.forEach((para) => _paragraphTextControllers.putIfAbsent(para, () => _ParagraphControllerBundle(para)));
    _textEditControllerBundle = _TextControllerBundle(_tinyPreset);
  }

  _updateTextWidgetState(txt) {
    setState(() {
      _tinyPreset.title = _textEditControllerBundle.titleController.text;
      _tinyPreset.subtitle = _textEditControllerBundle.subtitleController.text;
      _tinyPreset.language = _textEditControllerBundle.languageController.text;
      _tinyPreset.description = _textEditControllerBundle.descriptionController.text;

      for (var para in _tinyPreset.paragraphs) {
        _ParagraphControllerBundle bundle = _paragraphTextControllers[para];
        para.title = bundle.paragraphTitleController.text;
        para.content = bundle.paragraphContentController.text;
      }
    });
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

  _addParagraph(pos) {
    setState(() {
      var paragraph = Paragraph(position: pos);
      _tinyPreset.paragraphs.add(paragraph);
      _paragraphTextControllers.putIfAbsent(paragraph, () => _ParagraphControllerBundle(paragraph));
    });
  }

  _buildParagraphAddButton() =>
      CupertinoButton(
        child:
          Text(S.of(context).btn_add_paragrpah, key: Key('btn_add_paragraph'),),
        onPressed: () =>
            setState(() => _addParagraph(_tinyPreset.paragraphs.length+1)),
      );

  _buildSortParagraphsButton() => CupertinoButton(
    child: Text(S.of(context).change_order_title),
    onPressed: validPreset() ? () {
      _controlState.curDBO = _tinyPreset;
      _controlState.tinyEditCallback = () {
        _tinyPreset = TinyPreset.fromMap( TinyPreset.toMap (_controlState.curDBO ) );
      };
      Navigator.of(context).pushNamed(NavRoutes.PRESET_PARAGRAPH_EDIT);
    } : null,
  );

  _onImportError() => showDialog(context: context, builder: (f) =>
      CupertinoAlertDialog(
        title: Text(S.of(context).error_while_importing),
        content: Text(S.of(context).the_file_you_specified_is_not_a_valid_tiny_release),
        actions: <Widget>[
          CupertinoDialogAction(
            child: Text(S.of(context).ok),
            onPressed: () => Navigator.of(context).pop(
            ),
          )
        ],
      ));

  _importPresetFile() async {
    String path = await FilePicker.getFilePath(type: FileType.ANY, fileExtension: 'tinyjson');
    if ( path == '' ) {
      return;
    }
    var parser = PresetJSONParser(path, _onImportError);
    var tinyPreset = await parser.map();
    if ( tinyPreset == null ) {
      return;
    }
    setState(() {
      _tinyPreset = tinyPreset;
      _initParagraphControllers();
    });
  }

  _getImportButton() => CupertinoButton(
    child: Text(S.of(context).import_preset_from_file),
    onPressed: _importPresetFile,
  );

  /// get paragraphs widgets
  List< Widget > _buildParagraphWidgets() {
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
                    child: _buildParagraphWidget(para, i)
                ),
              ),
            ],
          ));
    }
    return list;
  }

  Widget _buildParagraphWidget(Paragraph para, index) {
    _ParagraphControllerBundle bundle = _paragraphTextControllers[para];
    return Column(children: <Widget>[
      Padding(
        padding: EdgeInsets.all(12.0),
        child: CupertinoTextField(
          key: Key('tf_paragraph_title_$index'),
          onChanged: _updateTextWidgetState,
          controller: bundle.paragraphTitleController,
          keyboardType: TextInputType.text,
          placeholder: S.of(context).hint_title,
        ),
      ),
      Padding(
        padding: EdgeInsets.all(12.0),
        child: CupertinoTextField(
          key: Key('tf_paragraph_content_$index'),
          onChanged: _updateTextWidgetState,
          controller: bundle.paragraphContentController,
          keyboardType: TextInputType.multiline,
          maxLines: 12,
          placeholder: S.of(context).hint_content,
        ),
      ),
    ]
    );
  }

  _buildFields() =>
      <Widget>[
        Padding(
          padding: EdgeInsets.all(12.0),
          child: CupertinoTextField(
            key: Key('tf_preset_title'),
            onChanged: _updateTextWidgetState,
            controller: _textEditControllerBundle.titleController,
            keyboardType: TextInputType.text,
            placeholder: S.of(context).hint_title,
          ),
        ),
        Padding(
          padding: EdgeInsets.all(12.0),
          child: CupertinoTextField(
            key: Key('tf_preset_subtitle'),
            onChanged: _updateTextWidgetState,
            controller: _textEditControllerBundle.subtitleController,
            keyboardType: TextInputType.text,
            placeholder:  S.of(context).hint_subtitle,
          ),
        ),
        Padding(
          padding: EdgeInsets.all(12.0),
          child: CupertinoTextField(
            key: Key('tf_preset_language'),
            onChanged: _updateTextWidgetState,
            controller: _textEditControllerBundle.languageController,
            keyboardType: TextInputType.text,
            placeholder: S.of(context).hint_language,
          ),
        ),
        Padding(
          padding: EdgeInsets.all(12.0),
          child: CupertinoTextField(
            key: Key('tf_preset_description'),
            onChanged: _updateTextWidgetState,
            controller: _textEditControllerBundle.descriptionController,
            keyboardType: TextInputType.text,
            placeholder: S.of(context).hint_description,
          ),
        ),
        Container(
          child: Column(
            children: _buildParagraphWidgets(),
          ),
        ),

        BaseUtil.isLargeScreen(context) ? ListTile(
          leading: _buildParagraphAddButton(),
          title:  _getImportButton(),
          trailing: _buildSortParagraphsButton(),
        ) : Column(children: <Widget>[
          _buildParagraphAddButton(),
          _buildSortParagraphsButton(),
          _getImportButton(),
        ],),
      ];
}

class _TextControllerBundle {
  final titleController = TextEditingController();
  final subtitleController = TextEditingController();
  final languageController = TextEditingController();
  final descriptionController = TextEditingController();

  _TextControllerBundle(TinyPreset tinyPreset) {
    titleController.text = tinyPreset.title;
    subtitleController.text = tinyPreset.subtitle;
    languageController.text = tinyPreset.language;
    descriptionController.text = tinyPreset.description;
  }
}

class _ParagraphControllerBundle {

  final paragraphTitleController = TextEditingController();
  final paragraphContentController = TextEditingController();

  _ParagraphControllerBundle(Paragraph para) {
    paragraphTitleController.text = para.title;
    paragraphContentController.text = para.content;
  }
}