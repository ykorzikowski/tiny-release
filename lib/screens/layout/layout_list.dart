
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tiny_release/data/repo/tiny_layout_repo.dart';
import 'package:tiny_release/screens/control/control_helper.dart';
import 'package:tiny_release/util/ControlState.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';
import 'package:tiny_release/screens/people/people_preview.dart';
import 'package:tiny_release/util/BaseUtil.dart';

typedef Null ItemSelectedCallback(int value);

class LayoutListWidget extends StatefulWidget {

  final ControlScreenState _controlState;

  LayoutListWidget(this._controlState);

  @override
  _LayoutListWidgetState createState() => _LayoutListWidgetState(_controlState);
}

class _LayoutListWidgetState extends State<LayoutListWidget> {
  static const int PAGE_SIZE = 10;
  final TinyLayoutRepo tinyLayoutRepo = new TinyLayoutRepo();
  final ControlScreenState _controlState;
  PagewiseLoadController pageLoadController;

  _LayoutListWidgetState(this._controlState);

  @override
  Widget build(BuildContext context) {
    pageLoadController = PagewiseLoadController(
        pageSize: PAGE_SIZE,
        pageFuture: (pageIndex) =>
            tinyLayoutRepo.getAll( pageIndex * PAGE_SIZE, PAGE_SIZE )
    );

    return Scaffold(
        appBar: !BaseUtil.isLargeScreen(context) ? AppBar(
          title: Text("Aufnahmebereiche"),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.add),
              tooltip: 'Add new',
              onPressed: () {
                ControlHelper.handleAddButton(_controlState, Navigator.of(context));
              },
            )
          ],
        ): null,
        body: PagewiseListView(
          itemBuilder: this._itemBuilder,
          pageLoadController: this.pageLoadController,
        ) );
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
    _controlState.setToolbarButtonsOnPreview();
    _controlState.curDBO = item;

    Navigator.push(context, CupertinoPageRoute(
        builder: (context) {
          return PeoplePreviewWidget( _controlState );
        }
    )
    );
    // todo
  }
}