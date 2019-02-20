
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tiny_release/data/repo/tiny_preset_repo.dart';
import 'package:tiny_release/data/tiny_preset.dart';
import 'package:tiny_release/generated/i18n.dart';
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
  final Function _onPresetTap;

  PresetListWidget(this._controlState, this._onPresetTap);

  @override
  _PresetListWidgetState createState() => _PresetListWidgetState(_controlState, _onPresetTap);
}

class _PresetListWidgetState extends State<PresetListWidget> {
  static const int PAGE_SIZE = 10;
  final TinyPresetRepo tinyPresetRepo = new TinyPresetRepo();
  final TinyState _controlState;
  final Function _onPresetTap;
  PagewiseLoadController pageLoadController;

  _PresetListWidgetState(this._controlState, this._onPresetTap);

  @override
  Widget build(BuildContext context) {
    pageLoadController = PagewiseLoadController(
        pageSize: PAGE_SIZE,
        pageFuture: (pageIndex) =>
            tinyPresetRepo.getAll( pageIndex * PAGE_SIZE, PAGE_SIZE )
    );

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        heroTag: 'control',
        transitionBetweenRoutes: false,
        leading: BaseUtil.isLargeScreen(context) ? Container() : null,
        middle: Text(S.of(context).title_preset),
        trailing:CupertinoButton(
          child: Text(S.of(context).btn_add),
          onPressed: () {
            var _tinyPreset = TinyPreset();
            _tinyPreset.paragraphs = List();
            _controlState.curDBO = _tinyPreset;
            Navigator.of(context).pushNamed(NavRoutes.PRESET_EDIT);
          },
        ),),
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomPadding: false,
          body: PagewiseListView(
            showRetry: false,
            padding: EdgeInsets.only(top: 10.0),
            itemBuilder: this._itemBuilder,
            pageLoadController: this.pageLoadController,
            noItemsFoundBuilder: (context) {
              return Text(S.of(context).no_items_presets, style: TextStyle(color: CupertinoColors.inactiveGray));
            },
        ),
      ),),
    );
  }

  Widget _itemBuilder(context, entry, index) {
    return
      Dismissible(
        direction: DismissDirection.endToStart,
        background: BaseUtil.getDismissibleBackground(),
        key: Key('preset_$index'),
        onDismissed: (direction) {
          tinyPresetRepo.delete(entry);

          Scaffold
              .of(context)
              .showSnackBar(
              SnackBar(content: Text(entry.title + S.of(context).scaff_deleted)));
        },
        child:
        Column(
          children: <Widget>[
            ListTile(
              leading: Icon(
                CupertinoIcons.collections,
              ),
              title: Text(entry.title),
              onTap:() => _onPresetTap(entry, context),
            ),
            Divider()
          ],
        ),);
  }
}