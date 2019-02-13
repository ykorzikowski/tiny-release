
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tiny_release/data/repo/tiny_reception_repo.dart';
import 'package:tiny_release/data/tiny_reception.dart';
import 'package:tiny_release/screens/control/control_helper.dart';
import 'package:tiny_release/util/ControlState.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';
import 'package:tiny_release/screens/people/people_preview.dart';
import 'package:tiny_release/util/BaseUtil.dart';
import 'package:tiny_release/util/tiny_page_wrapper.dart';

typedef Null ItemSelectedCallback(int value);

class ReceptionListWidget extends StatefulWidget {

  final ControlScreenState _controlState;

  ReceptionListWidget(this._controlState);

  @override
  _ListWidgetState createState() => _ListWidgetState(_controlState);
}

class _ListWidgetState extends State<ReceptionListWidget> {
  static const int PAGE_SIZE = 10;
  final TinyReceptionRepo receptionRepository = new TinyReceptionRepo();
  final ControlScreenState _controlState;
  PagewiseLoadController pageLoadController;

  _ListWidgetState(this._controlState);

  @override
  Widget build(BuildContext context) {
    pageLoadController = PagewiseLoadController(
        pageSize: PAGE_SIZE,
        pageFuture: (pageIndex) =>
            receptionRepository.getAll( pageIndex * PAGE_SIZE, PAGE_SIZE )
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
        Dismissible(
            background: Container(color: Colors.red),
            key: Key(entry.displayName),
            onDismissed: (direction) {
              receptionRepository.delete(entry);

              Scaffold
                  .of(context)
                  .showSnackBar(SnackBar(content: Text(entry.displayName + " dismissed")));
            },
            child: ListTile(
              leading: Icon(
                Icons.camera,
                color: Colors.brown[200],
              ),
              title: Text(entry.displayName),
              onTap: () {
                openDetailView(entry, context);
              },
            )),
        Divider()
      ],
    );
  }

  void openDetailView(item, context) {
    _controlState.setToolbarButtonsOnPreview();
    _controlState.curDBO = item;

    var myBuilder = (context) {
    return PeoplePreviewWidget( _controlState );
    };

    Navigator.push(context,
        TinyPageWrapper(
          builder: myBuilder,

        )
    );
    // todo
  }
}