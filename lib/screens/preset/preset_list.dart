
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:paperflavor/data/repo/tiny_contract_repo.dart';
import 'package:paperflavor/data/repo/tiny_preset_repo.dart';
import 'package:paperflavor/data/tiny_preset.dart';
import 'package:paperflavor/generated/i18n.dart';
import 'package:paperflavor/util/nav_routes.dart';
import 'package:paperflavor/util/tiny_state.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';
import 'package:paperflavor/util/base_util.dart';

typedef Null ItemSelectedCallback(int value);

class PresetListWidget extends StatefulWidget {

  final TinyState tinyState;
  final Function onPresetTap;
  final TinyPresetRepo tinyPresetRepo;
  final TinyContractRepo tinyContractRepo;

  PresetListWidget({ this.tinyPresetRepo, this.tinyContractRepo, this.tinyState, this.onPresetTap});

  @override
  _PresetListWidgetState createState() => _PresetListWidgetState(tinyState, onPresetTap, tinyPresetRepo, tinyContractRepo);
}

class _PresetListWidgetState extends State<PresetListWidget> {
  static const int PAGE_SIZE = 10;
  TinyPresetRepo _tinyPresetRepo;
  TinyContractRepo _tinyContractRepo;
  final TinyState _controlState;
  final Function _onPresetTap;
  PagewiseLoadController pageLoadController;

  _PresetListWidgetState(this._controlState, this._onPresetTap, this._tinyPresetRepo, this._tinyContractRepo) {
    _tinyPresetRepo = _tinyPresetRepo ?? TinyPresetRepo();
    _tinyContractRepo = _tinyContractRepo ?? TinyContractRepo();
  }

  @override
  Widget build(BuildContext context) {
    pageLoadController = PagewiseLoadController(
        pageSize: PAGE_SIZE,
        pageFuture: (pageIndex) =>
            _tinyPresetRepo.getAll( pageIndex * PAGE_SIZE, PAGE_SIZE )
    );

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        heroTag: 'control',
        transitionBetweenRoutes: false,
        leading: BaseUtil.isLargeScreen(context) ? Container() : null,
        middle: Text(S.of(context).title_preset),
        trailing:CupertinoButton(
          padding: EdgeInsets.all(10),
          child: Text(S.of(context).btn_add, key: Key('navbar_btn_add')),
          onPressed: _onAddPresetPressed,
        ),),
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomPadding: false,
          body: PagewiseListView(
            showRetry: false,
            padding: EdgeInsets.only(top: 10.0),
            itemBuilder: _itemBuilder,
            pageLoadController: pageLoadController,
            noItemsFoundBuilder: (context) => Text(S.of(context).no_items_presets, style: TextStyle(color: CupertinoColors.inactiveGray)),
        ),
      ),),
    );
  }

  _onAddPresetPressed() {
    var _tinyPreset = TinyPreset();
    _tinyPreset.paragraphs = List();
    _controlState.curDBO = _tinyPreset;
    Navigator.of(context).pushNamed(NavRoutes.PRESET_EDIT);
  }

  Widget _buildListTile(index, entry) => ListTile(
    key: Key('preset_$index'),
    leading: Icon(CupertinoIcons.collections,),
    title: Text(entry.title, key: Key('preset_title_$index')),
    onTap:() => _onPresetTap(entry, context),
  );

  _onDismissed(direction, entry) {
    _tinyPresetRepo.delete(entry);

    Scaffold
        .of(context)
        .showSnackBar(
        SnackBar(content: Text(entry.title + S.of(context).scaff_deleted)));
  }

  Future<bool> _confirmDismiss(direction, entry) {
    var presetHasNoContracts = _tinyContractRepo.presetHasNoContracts(entry.id);
    presetHasNoContracts.then((hasNoContracts) {
      if (!hasNoContracts) {
        Scaffold.of(context).showSnackBar(
            SnackBar(
                key: Key('confirm_dismiss_denied_snackbar'),
                duration: Duration(milliseconds: 1000),
                content: Text(S.of(context).item_has_relations))
        );
      }
    },);
    return presetHasNoContracts;
  }

  Widget _itemBuilder(context, entry, index) {
    return
      Dismissible(
        direction: DismissDirection.endToStart,
        background: BaseUtil.getDismissibleBackground(),
        key: Key('dismissible_preset_$index'),
        confirmDismiss: (direction) => _confirmDismiss(direction, entry),
        onDismissed: (direction) => _onDismissed(direction, entry),
        child: _buildListTile(index, entry)
      );
  }
}
