
import 'dart:io' as Io;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tiny_release/data/repo/tiny_contract_repo.dart';
import 'package:tiny_release/data/tiny_contract.dart';
import 'package:tiny_release/generated/i18n.dart';
import 'package:tiny_release/screens/people/people_list.dart';
import 'package:tiny_release/util/BaseUtil.dart';
import 'package:tiny_release/util/NavRoutes.dart';
import 'package:tiny_release/util/tiny_state.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';

typedef Null ItemSelectedCallback(int value);

class ContractListWidget extends StatefulWidget {
  static const int PAGE_SIZE = 10;

  final TinyState _controlState;

  ContractListWidget(this._controlState);

  @override
  _ContractListWidgetState createState() => _ContractListWidgetState(_controlState);
}

class _ContractListWidgetState extends State<ContractListWidget> {
  final TinyContractRepo _tinyContractRepo = new TinyContractRepo();
  final TinyState _controlState;
  PagewiseLoadController pageLoadController;

  _ContractListWidgetState(this._controlState);

  @override
  Widget build(BuildContext context) {
    pageLoadController = PagewiseLoadController(
        pageSize: ContractListWidget.PAGE_SIZE,
        pageFuture: (pageIndex) =>
            _tinyContractRepo.getAll(pageIndex, ContractListWidget.PAGE_SIZE)
    );

    _controlState.inControlWidget = true;
    return
      CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          heroTag: 'contract',
          transitionBetweenRoutes: false,
          leading: BaseUtil.isLargeScreen(context) ? Container() : null,
          middle: Text(S.of(context).title_contracts),
          trailing:CupertinoButton(
            child: Text(S.of(context).title_add),
            onPressed: () {
              var _tinyContract = TinyContract();
              _tinyContract.isLocked = false;
              _controlState.curDBO = _tinyContract;
              BaseUtil.isLargeScreen(context) ? Navigator.of(context).pushNamed(NavRoutes.CONTRACT_MASTER) : Navigator.of(context).pushNamed(NavRoutes.CONTRACT_EDIT);
            },
          ),),
        child: SafeArea(
          child: Scaffold(
            resizeToAvoidBottomPadding: false,
            body: PagewiseListView(
              showRetry: false,
              padding: EdgeInsets.only(top: 10.0),
              itemBuilder: this._itemBuilder,
              pageLoadController: this.pageLoadController,
              noItemsFoundBuilder: (context) {
                return Text(S.of(context).create_new_contract, style: TextStyle(color: CupertinoColors.inactiveGray));
              },
          ),
        ),),
      );
  }

  Widget _itemBuilder(context, entry, index) {
    return Dismissible(
      direction: DismissDirection.endToStart,
      background: BaseUtil.getDismissibleBackground(),
      key: Key('contract_$index'),
      onDismissed: (direction) {
        _tinyContractRepo.delete(entry);

        Scaffold
            .of(context)
            .showSnackBar(
            SnackBar(content: Text(entry.displayName + " " +  S.of(context).scaff_deleted)));
      },
      child: Column(
        children: <Widget>[
          ListTile(
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[Icon(entry.isLocked == true ? CupertinoIcons
                  .check_mark_circled_solid : CupertinoIcons.pen),
              Text(entry.displayName),
              ],),
            subtitle: entry?.preset?.subtitle != null ? Text(entry.preset.subtitle) : null,
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                entry.date != null ? Padding(
                  padding: EdgeInsets.all(8.0),
                  child:
                  Column(children: <Widget>[
                    Icon(CupertinoIcons.location_solid),
                    Text(BaseUtil.getLocalFormattedDateTime(context, entry.date)),
                  ],),) : Container(),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child:
                  Column(children: <Widget>[
                    Icon(CupertinoIcons.location_solid),
                    Text(entry.location),
                  ],),),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child:
                  CircleAvatar(
                    backgroundColor: Colors.lightBlue,
                    child: entry.model.avatar == null ? Text(
                      PeopleListWidget.getCircleText(entry.model),
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ) : null,
                    backgroundImage: entry.model.avatar != null ? new FileImage(
                        Io.File(entry.model.avatar)) : null,
                    radius: 32.0,
                  ),),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child:
                  CircleAvatar(
                    backgroundColor: Colors.lightBlue,
                    child: entry.photographer.avatar == null ? Text(
                      PeopleListWidget.getCircleText(entry.model),
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ) : null,
                    backgroundImage: entry.photographer.avatar != null
                        ? new FileImage(
                        Io.File(entry.photographer.avatar))
                        : null,
                    radius: 32.0,
                  ),),
              ],),
            onTap: () {
              _controlState.curDBO = entry;
              entry.isLocked ? Navigator.of(context).pushNamed(NavRoutes.CONTRACT_GENERATED) :
              BaseUtil.isLargeScreen(context) ? Navigator.of(context).pushNamed(NavRoutes.CONTRACT_MASTER) : Navigator.of(context).pushNamed(NavRoutes.CONTRACT_EDIT);
            },
          ),
          Divider()
        ],
      ),);
  }
}