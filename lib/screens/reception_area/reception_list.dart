
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tiny_release/data/repo/tiny_reception_repo.dart';
import 'package:tiny_release/data/tiny_reception.dart';
import 'package:tiny_release/generated/i18n.dart';
import 'package:tiny_release/util/tiny_state.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';
import 'package:tiny_release/util/BaseUtil.dart';

typedef Null ItemSelectedCallback(int value);

class ReceptionListWidget extends StatefulWidget {

  final TinyState _controlState;

  ReceptionListWidget(this._controlState);

  @override
  _ListWidgetState createState() => _ListWidgetState(_controlState);
}

class _ListWidgetState extends State<ReceptionListWidget> {
  static const int PAGE_SIZE = 10;
  final TinyReceptionRepo _tinyRepo = new TinyReceptionRepo();
  TinyReception _tinyReception;
  final TinyState _controlState;
  PagewiseLoadController pageLoadController;

  _ListWidgetState(this._controlState);

  @override
  Widget build(BuildContext context) {
    pageLoadController = PagewiseLoadController(
        pageSize: PAGE_SIZE,
        pageFuture: (pageIndex) =>
            _tinyRepo.getAll( pageIndex * PAGE_SIZE, PAGE_SIZE )
    );

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        heroTag: 'control',
        transitionBetweenRoutes: false,
        leading: BaseUtil.isLargeScreen(context) ? Container() : null,
        middle: Text(S.of(context).title_reception),
        trailing:CupertinoButton(
          child: Text(S.of(context).btn_add),
          onPressed: () {
            _tinyReception = TinyReception();
            _controlState.curDBO = _tinyReception;
            showCupertinoDialog(context: context, builder: (context) => CupertinoAlertDialog(
              title: Text(S.of(context).title_add_reception),
              content: CupertinoTextField(
                onChanged: (t) => _tinyReception.displayName = t,
                onSubmitted: (t) => _tinyReception.displayName = t,
              ),
              actions: <Widget>[
                CupertinoDialogAction(
                  child: Text(S.of(context).btn_save),
                  isDefaultAction: true,
                  onPressed: () {
                    _tinyRepo.save(_tinyReception);
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                ),
                CupertinoDialogAction(
                  isDestructiveAction: true,
                  child: Text(S.of(context).btn_dialog_cancel),
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                )
              ],
            ));
          },
        ),),
      child: SafeArea(  child: Scaffold(
        resizeToAvoidBottomPadding: false,
        body: PagewiseListView(
          padding: EdgeInsets.only(top: 10.0),
          itemBuilder: this._itemBuilder,
          pageLoadController: this.pageLoadController,
          noItemsFoundBuilder: (context) {
            return Text(S.of(context).no_items_reception, style: TextStyle(color: CupertinoColors.inactiveGray),);
          },
        ),
      ),),
    );
  }

  Widget _itemBuilder(context, entry, _) {
    return Dismissible(
      direction: DismissDirection.endToStart,
      background: BaseUtil.getDismissibleBackground(),
      key: Key(entry.displayName),
      onDismissed: (direction) {
        _tinyRepo.delete(entry);

        Scaffold
            .of(context)
            .showSnackBar(
            SnackBar(content: Text(entry.displayName + S.of(context).scaff_deleted)));
      },
      child: Column(
        children: <Widget>[
          ListTile(
            leading: Icon(
              Icons.camera,
              color: Colors.brown[200],
            ),
            title: Text(entry.displayName),
          ),
          Divider()
        ],
      ),);
  }
}