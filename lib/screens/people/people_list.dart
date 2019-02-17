
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tiny_release/data/repo/tiny_people_repo.dart';
import 'package:tiny_release/data/tiny_people.dart';
import 'package:tiny_release/util/BaseUtil.dart';
import 'package:tiny_release/util/NavRoutes.dart';
import 'package:tiny_release/util/tiny_state.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';

typedef Null ItemSelectedCallback(int value);

class PeopleListWidget extends StatefulWidget {
  static const int PAGE_SIZE = 10;

  final TinyState _controlState;
  final Function _getPeople;
  final Function _onPeopleTap;

  PeopleListWidget(this._controlState, this._getPeople, this._onPeopleTap);

  static Widget getCircleAvatar(TinyPeople entry, String circleText) =>
      CircleAvatar(
        backgroundColor: Colors.lightBlue,
        child: entry?.avatar == null ? Text(
          circleText,
          style: TextStyle(
            color: Colors.white,
          ),
        ) : null,
        backgroundImage: entry?.avatar != null
            ? new MemoryImage(entry.avatar)
            : null,
        radius: 32.0,
      );

  static String getCircleText(TinyPeople entry) {
    var result = "";
    entry.givenName.isNotEmpty ? result += entry.givenName.substring(0, 1) : "";
    entry.familyName.isNotEmpty ? result += entry.familyName.substring(0, 1) : "";
    return result;
  }


  @override
  _ListWidgetState createState() => _ListWidgetState(_controlState, _getPeople, _onPeopleTap);
}

class _ListWidgetState extends State<PeopleListWidget> {
  final TinyPeopleRepo contactRepository = new TinyPeopleRepo();
  final TinyState _controlState;
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
            leading: BaseUtil.isLargeScreen(context) ? Container() : null,
            middle: Text("People"),
            trailing:CupertinoButton(
              child: Text("Hinzufügen"),
              onPressed: () {
                var _tinyPeople = TinyPeople();
                _tinyPeople.type = this._controlState.selectedControlItem;
                _tinyPeople.emails = List();
                _tinyPeople.postalAddresses = List();
                _tinyPeople.phones = List();
                _controlState.curDBO = _tinyPeople;
                Navigator.of(context).pushNamed(NavRoutes.PEOPLE_EDIT);
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
    return Dismissible(
      direction: DismissDirection.endToStart,
      background: BaseUtil.getDismissibleBackground(),
      key: Key(entry.hashCode.toString()),
      onDismissed: (direction) {
        contactRepository.delete(entry);

        Scaffold
            .of(context)
            .showSnackBar(
            SnackBar(content: Text(entry.displayName + " dismissed")));
      },
      child: Column(
        children: <Widget>[
          ListTile(
            leading: PeopleListWidget.getCircleAvatar(
                entry, PeopleListWidget.getCircleText(entry)),
            title: Text(entry.givenName + " " + entry.familyName),
            onTap: () {
              _onPeopleTap(entry, context);
            },
          ),
          Divider(),

        ],
      ),);
  }
}