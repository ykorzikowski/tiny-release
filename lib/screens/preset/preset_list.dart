
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tiny_release/data/repo/tiny_preset_repo.dart';
import 'package:tiny_release/data/tiny_preset.dart';
import 'package:tiny_release/screens/control/control_helper.dart';
import 'package:tiny_release/screens/preset/preset_preview.dart';
import 'package:tiny_release/util/NavRoutes.dart';
import 'package:tiny_release/util/tiny_state.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';
import 'package:tiny_release/screens/people/people_preview.dart';
import 'package:tiny_release/util/BaseUtil.dart';

typedef Null ItemSelectedCallback(int value);

class PresetListWidget extends StatefulWidget {

  final TinyState _controlState;

  PresetListWidget(this._controlState);

  @override
  _PresetListWidgetState createState() => _PresetListWidgetState(_controlState);
}

class _PresetListWidgetState extends State<PresetListWidget> {
  static const int PAGE_SIZE = 10;
  final TinyPresetRepo tinyPresetRepo = new TinyPresetRepo();
  final TinyState _controlState;
  PagewiseLoadController pageLoadController;

  _PresetListWidgetState(this._controlState);

  @override
  Widget build(BuildContext context) {
    pageLoadController = PagewiseLoadController(
        pageSize: PAGE_SIZE,
        pageFuture: (pageIndex) =>
            tinyPresetRepo.getAll( pageIndex * PAGE_SIZE, PAGE_SIZE )
    );

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        leading: BaseUtil.isLargeScreen(context) ? Container() : null,
        middle: Text("Vorlagen"),
        trailing:CupertinoButton(
          child: Text("Hinzufügen"),
          onPressed: () {
            var _tinyPreset = TinyPreset();
            _tinyPreset.paragraphs = List();
            _controlState.curDBO = _tinyPreset;
            Navigator.of(context).pushNamed(NavRoutes.PRESET_EDIT);
          },
        ),),
      child: SafeArea(  child: Scaffold(
        body: PagewiseListView(
          padding: EdgeInsets.only(top: 10.0),
          itemBuilder: this._itemBuilder,
          pageLoadController: this.pageLoadController,
        ),
      ),),
    );
  }

  Widget _itemBuilder(context, entry, _) {
    return
      Dismissible(
        direction: DismissDirection.endToStart,
        background: BaseUtil.getDismissibleBackground(),
        key: Key(entry.title),
        onDismissed: (direction) {
          tinyPresetRepo.delete(entry);

          Scaffold
              .of(context)
              .showSnackBar(
              SnackBar(content: Text(entry.title + " dismissed")));
        },
        child:
        Column(
          children: <Widget>[
            ListTile(
              leading: Icon(
                CupertinoIcons.collections,
                color: Colors.brown[200],
              ),
              title: Text(entry.title),
              onTap: () {
                openDetailView(entry, context);
              },
            ),
            Divider()
          ],
        ),);
  }

  void openDetailView(item, context) {
    _controlState.curDBO = item;

    Navigator.of(context).pushNamed(NavRoutes.PRESET_PREVIEW);
  }
}