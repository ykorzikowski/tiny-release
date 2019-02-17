
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
  final bool isContactImportDialog;

  PeopleListWidget(this._controlState, this._getPeople, this._onPeopleTap, {this.isContactImportDialog: true});

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
  _ListWidgetState createState() => _ListWidgetState(_controlState, _getPeople, _onPeopleTap, isContactImportDialog: isContactImportDialog);
}

class _ListWidgetState extends State<PeopleListWidget> {
  final TinyPeopleRepo contactRepository = new TinyPeopleRepo();
  final TinyState _controlState;
  PagewiseLoadController pageLoadController;
  final bool isContactImportDialog;

  /// called by list to get people
  /// getPeople(pageIndex)
  final Function _getPeople;

  /// onPeopleTap(item, context)
  final Function _onPeopleTap;

  _ListWidgetState(this._controlState, this._getPeople, this._onPeopleTap, {this.isContactImportDialog: true});

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
          heroTag: 'control',
          transitionBetweenRoutes: false,
          leading: BaseUtil.isLargeScreen(context) ? Container() : null,
          middle: Text("People"),
          trailing: isContactImportDialog ? CupertinoButton(
            child: Text("Hinzufügen", key: Key('navbar_btn_add'),),
            onPressed: () {
              var _tinyPeople = TinyPeople.factory();
              _controlState.curDBO = _tinyPeople;
              Navigator.of(context).pushNamed(NavRoutes.PEOPLE_EDIT);
            },
          ) : null),
        child: SafeArea(
          child: Scaffold(
            resizeToAvoidBottomPadding: false,
            body: PagewiseListView(
              padding: EdgeInsets.only(top: 10.0),
              itemBuilder: this._itemBuilder,
              noItemsFoundBuilder: (context) {
                return Text('Fügen Sie Menschen aus Ihren Kontakten hinzu', style: TextStyle(color: CupertinoColors.inactiveGray));
              },
              pageLoadController: this.pageLoadController,
            ),
          ),),
      );
  }

  /// wrap child with dismissible if bool is ture
  Widget dismissibleDistinctive(child, entry, key) {
    return isContactImportDialog ?
    Dismissible(
      key: Key(key),
      direction: DismissDirection.endToStart,
      background: BaseUtil.getDismissibleBackground(),
      onDismissed: (direction) {
        contactRepository.delete(entry);

        Scaffold
            .of(context)
            .showSnackBar(
            SnackBar(content: Text(entry.displayName + " dismissed")));
      },
      child: child,) : Container(child: child,);
  }

  Widget _itemBuilder(context, entry, index) {
    return dismissibleDistinctive (Column(
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
      ), entry, 'people_$index');
  }
}