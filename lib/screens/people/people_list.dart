import 'dart:io' as Io;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:paperflavor/data/repo/tiny_contract_repo.dart';
import 'package:paperflavor/data/repo/tiny_people_repo.dart';
import 'package:paperflavor/data/tiny_people.dart';
import 'package:paperflavor/generated/i18n.dart';
import 'package:paperflavor/util/base_util.dart';
import 'package:paperflavor/util/nav_routes.dart';
import 'package:paperflavor/util/paywall.dart';
import 'package:paperflavor/util/tiny_state.dart';
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
            ? new FileImage(Io.File(entry.avatar))
            : null,
        radius: 32.0,
      );

  static String getCircleText(TinyPeople entry) {
    var result = "";
    if(entry.givenName != null && entry.givenName.isNotEmpty) result += entry.givenName.substring(0, 1);
    if(entry.familyName != null && entry.familyName.isNotEmpty) result += entry.familyName.substring(0, 1);
    return result;
  }


  @override
  _ListWidgetState createState() => _ListWidgetState(_controlState, _getPeople, _onPeopleTap, isContactImportDialog: isContactImportDialog);
}

class _ListWidgetState extends State<PeopleListWidget> {
  final TinyPeopleRepo _tinyPeopleRepo = new TinyPeopleRepo();
  final TinyContractRepo _tinyContractRepo = new TinyContractRepo();
  final TinyState _controlState;
  PagewiseLoadController pageLoadController;
  final bool isContactImportDialog;
  final PayWall _payWall = PayWall();

  /// called by list to get people
  /// getPeople(pageIndex)
  final Function _getPeople;

  /// onPeopleTap(item, context)
  final Function _onPeopleTap;

  _ListWidgetState(this._controlState, this._getPeople, this._onPeopleTap, {this.isContactImportDialog: true});

  _createNewPerson() {
    var _tinyPeople = TinyPeople.factory();
    _controlState.curDBO = _tinyPeople;
    Navigator.of(context).pushNamed(NavRoutes.PEOPLE_EDIT);
  }

  Widget _buildPeopleAddButton() => CupertinoButton(
      padding: EdgeInsets.all(10),
      child: Text(S.of(context).btn_add, key: Key('navbar_btn_add'),),
      onPressed: () {
        _tinyPeopleRepo.getPeopleCount().then((peopleCount) {
          if ( peopleCount > 10) {
            _payWall.checkIfPaid(PayFeature.PAY_UNLIMITED_PEOPLE,
                    () => _createNewPerson(),
                    (error) => showDialog(context: context, builder: (ctx) => PayWall.getSubscriptionDialog(PayFeature.PAY_UNLIMITED_PEOPLE, ctx)));
          } else {
            _createNewPerson();
          }
        });
      },
  );

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
          middle: Text(S.of(context).title_people),
          trailing: isContactImportDialog ? _buildPeopleAddButton() : null),
        child: SafeArea(
          child: Scaffold(
            resizeToAvoidBottomPadding: false,
            body: PagewiseListView(
              showRetry: false,
              padding: EdgeInsets.only(top: 10.0),
              itemBuilder: this._itemBuilder,
              noItemsFoundBuilder: (context) {
                return Text(S.of(context).no_items_people, style: TextStyle(color: CupertinoColors.inactiveGray));
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
      confirmDismiss: (direction) {
        var personHasNoContracts = _tinyContractRepo.personHasNoContracts(entry.id);
        personHasNoContracts.then((hasNoContracts) {
          if (!hasNoContracts) {
            Scaffold.of(context).showSnackBar(SnackBar(duration: Duration(milliseconds: 1000), content: Text(S.of(context).item_has_relations)));
          }
        },);
        return personHasNoContracts;
      },
      onDismissed: (direction) {
        _tinyPeopleRepo.delete(entry);
      },
      child: child,) : Container(child: child,);
  }

  String _getPersonName(TinyPeople tinyPeople) {
    String name = "";
    if (tinyPeople.givenName != null) name += tinyPeople.givenName + " ";
    if (tinyPeople.familyName != null) name += tinyPeople.familyName;

    return name;
  }

  Widget _itemBuilder(context, entry, index) {
    return dismissibleDistinctive (Column(
        children: <Widget>[
          ListTile(
            key: Key('people_$index'),
            leading: PeopleListWidget.getCircleAvatar(
                entry, PeopleListWidget.getCircleText(entry)),
            title: Text(_getPersonName(entry), overflow: TextOverflow.ellipsis,),
            onTap: () {
              _onPeopleTap(entry, context);
            },
          ),
          Divider(),

        ],
      ), entry, 'dismissible_people_$index');
  }
}
