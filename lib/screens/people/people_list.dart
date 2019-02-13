
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tiny_release/data/repo/tiny_people_repo.dart';
import 'package:tiny_release/screens/control/control_helper.dart';
import 'package:tiny_release/util/ControlState.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';

typedef Null ItemSelectedCallback(int value);

class PeopleListWidget extends StatefulWidget {
  static const int PAGE_SIZE = 10;

  final ControlScreenState _controlState;
  final Function _getPeople;
  final Function _onPeopleTap;

  PeopleListWidget(this._controlState, this._getPeople, this._onPeopleTap);

  @override
  _ListWidgetState createState() => _ListWidgetState(_controlState, _getPeople, _onPeopleTap);
}

class _ListWidgetState extends State<PeopleListWidget> {
  final TinyPeopleRepo contactRepository = new TinyPeopleRepo();
  final ControlScreenState _controlState;
  PagewiseLoadController pageLoadController;

  /// called by list to get people
  /// getPeople(pageIndex)
  final Function _getPeople;

  /// onPeopleTap(item, context)
  final Function _onPeopleTap;

  _ListWidgetState(this._controlState, this._getPeople, this._onPeopleTap);

  @override
  Widget build(BuildContext context) {
    pageLoadController = PagewiseLoadController(
        pageSize: PeopleListWidget.PAGE_SIZE,
        pageFuture: (pageIndex) =>
            _getPeople(pageIndex)
    );

    return
      CupertinoPageScaffold(
          navigationBar: CupertinoNavigationBar(
            middle: Text("People"),
            trailing:CupertinoButton(
              child: Text("Hinzufügen"),
              onPressed: () {
                ControlHelper.handleAddButton( _controlState, Navigator.of(context) );
              },
            ),),
          child: Scaffold(
            body: PagewiseListView(
              padding: EdgeInsets.only(top: 80.0),
              itemBuilder: this._itemBuilder,
              pageLoadController: this.pageLoadController,
            ),
          ));
  }

  Widget leadingElement(var entry) {
    return CircleAvatar(
      child: entry.avatar == null ? Icon(
        CupertinoIcons.person,
      ) : null,
      backgroundImage: entry.avatar != null ? new MemoryImage(entry.avatar) : null,
//      backgroundColor: Colors.lightGreen,
      radius: 32.0,
    );
  }

  Widget _itemBuilder(context, entry, _) {
    return Column(
        children: <Widget>[
          Dismissible(
            background: Container(color: Colors.red),
            key: Key(entry.displayName),
            onDismissed: (direction) {
              contactRepository.delete(entry);

              Scaffold
                  .of(context)
                  .showSnackBar(SnackBar(content: Text(entry.displayName + " dismissed")));
            },
            child: ListTile(
              leading: leadingElement( entry ),
              title: Text(entry.displayName),
              onTap: () {
                _onPeopleTap( entry, context );
              },
            ),),
          Divider()
        ],
    );
  }
}