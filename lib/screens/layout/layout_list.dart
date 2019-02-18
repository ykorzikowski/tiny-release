
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tiny_release/data/repo/tiny_layout_repo.dart';
import 'package:tiny_release/screens/control/control_helper.dart';
import 'package:tiny_release/util/NavRoutes.dart';
import 'package:tiny_release/util/tiny_state.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';
import 'package:tiny_release/screens/people/people_preview.dart';
import 'package:tiny_release/util/BaseUtil.dart';

typedef Null ItemSelectedCallback(int value);

class LayoutListWidget extends StatefulWidget {

  final TinyState _controlState;

  LayoutListWidget(this._controlState);

  @override
  _LayoutListWidgetState createState() => _LayoutListWidgetState(_controlState);
}

class _LayoutListWidgetState extends State<LayoutListWidget> {
  static const int PAGE_SIZE = 10;
  final TinyLayoutRepo tinyLayoutRepo = new TinyLayoutRepo();
  final TinyState _controlState;
  PagewiseLoadController pageLoadController;

  _LayoutListWidgetState(this._controlState);

  @override
  Widget build(BuildContext context) {
    pageLoadController = PagewiseLoadController(
        pageSize: PAGE_SIZE,
        pageFuture: (pageIndex) =>
            tinyLayoutRepo.getAll( pageIndex * PAGE_SIZE, PAGE_SIZE )
    );

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        heroTag: 'control',
        transitionBetweenRoutes: false,
        leading: BaseUtil.isLargeScreen(context) ? Container() : null,
        middle: Text("Layout"),
        trailing:CupertinoButton(
          child: Text("Hinzufügen"),
          onPressed: () {

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
            return Text('Erstellen Sie ein neues Layout', style: TextStyle(color: CupertinoColors.inactiveGray));
          },
        ),
      ),),
    );
  }

  Widget _itemBuilder(context, entry, _) {
    return Column(
      children: <Widget>[
        ListTile(
          leading: Icon(
            Icons.person,
            color: Colors.brown[200],
          ),
          title: Text(entry.displayName),
          onTap: () {
            openDetailView( entry, context );
          },
        ),
        Divider()
      ],
    );
  }

  void openDetailView(item, context) {
    _controlState.curDBO = item;

    Navigator.of(context).pushNamed(NavRoutes.PEOPLE_PREVIEW);
    // todo
  }
}