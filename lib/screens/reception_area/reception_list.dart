
import 'package:cool_ui/cool_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tiny_release/data/repo/tiny_reception_repo.dart';
import 'package:tiny_release/data/tiny_reception.dart';
import 'package:tiny_release/generated/i18n.dart';
import 'package:tiny_release/util/tiny_state.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';
import 'package:tiny_release/util/base_util.dart';

typedef Null ItemSelectedCallback(int value);

class ReceptionListWidget extends StatefulWidget {

  final TinyState _controlState;
  final Function _onReceptionTap;

  ReceptionListWidget(this._controlState, this._onReceptionTap);

  @override
  _ListWidgetState createState() => _ListWidgetState(_controlState, _onReceptionTap);
}

class _ListWidgetState extends State<ReceptionListWidget> {
  static const int PAGE_SIZE = 10;
  final TinyReceptionRepo _tinyRepo = new TinyReceptionRepo();
  TinyReception _tinyReception;
  final TinyState _controlState;
  PagewiseLoadController pageLoadController;
  final Function _onReceptionTap;

  _ListWidgetState(this._controlState, this._onReceptionTap);

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
        trailing: CupertinoPopoverButton(
          child: Text(S.of(context).btn_add, key: Key('btn_add_reception')),
          popoverHeight: 56,
          popoverWidth: 250,
          popoverBuild: (context) {
            _tinyReception = TinyReception();
            _controlState.curDBO = _tinyReception;
            return Column(
              children: <Widget>[
                ListTile(
                  trailing: CupertinoButton( // todo: bug when nothing is entered
                      child: Icon(CupertinoIcons.add_circled_solid, color: CupertinoColors.activeGreen, key: Key('btn_save_reception'),),
                      onPressed: () {
                        _tinyRepo.save(_tinyReception);
                        Navigator.of(context, rootNavigator: true).pop();
                      }),
                  leading: Container(
                    width: 170,
                    child: CupertinoTextField(
                      key: Key('tf_reception'),
                      onChanged: (t) => setState(() => _tinyReception.displayName = t),
                      onSubmitted: (t) => setState(() => _tinyReception.displayName = t),
                      placeholder: S.of(context).reception_area,
                    ),
                  ),
                )
              ],
            );
          },
        ),),
      child: SafeArea(  child: Scaffold(
        resizeToAvoidBottomPadding: false,
        body: PagewiseListView(
          showRetry: false,
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

  Widget _itemBuilder(context, entry, index) {
    return Dismissible(
      direction: DismissDirection.endToStart,
      background: BaseUtil.getDismissibleBackground(),
      key: Key('dismissible_reception_$index'),
      confirmDismiss: (direction) {
        var receptionHasNoContracts = _tinyRepo.receptionInContract(entry.id);
        receptionHasNoContracts.then((hasNoContracts) {
          if (!hasNoContracts) {
            Scaffold.of(context).showSnackBar(SnackBar(duration: Duration(milliseconds: 1000), content: Text(S.of(context).item_has_relations)));
          }
        },);
        return receptionHasNoContracts;
      },
      onDismissed: (direction) {
        _tinyRepo.delete(entry);
      },
      child: Column(
        children: <Widget>[
          ListTile(
            key: Key('reception_$index'),
            leading: Icon(
              Icons.camera,
              color: Colors.brown[200],
            ),
            title: Text(entry.displayName),
            onTap: () => _onReceptionTap(context, entry),
          ),
          Divider()
        ],
      ),);
  }
}