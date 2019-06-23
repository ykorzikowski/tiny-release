
import 'dart:io' as Io;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:paperflavor/data/repo/tiny_contract_repo.dart';
import 'package:paperflavor/data/tiny_contract.dart';
import 'package:paperflavor/data/tiny_people.dart';
import 'package:paperflavor/generated/i18n.dart';
import 'package:paperflavor/screens/people/people_list.dart';
import 'package:paperflavor/util/base_util.dart';
import 'package:paperflavor/util/nav_routes.dart';
import 'package:paperflavor/util/paywall.dart';
import 'package:paperflavor/util/tiny_state.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';

typedef Null ItemSelectedCallback(int value);

class ContractListWidget extends StatefulWidget {
  static const int PAGE_SIZE = 10;

  final TinyState tinyState;
  final TinyContractRepo tinyContractRepo;

  ContractListWidget({this.tinyState, this.tinyContractRepo});

  @override
  _ContractListWidgetState createState() => _ContractListWidgetState(tinyState, tinyContractRepo);
}

class _ContractListWidgetState extends State<ContractListWidget> {
  final PayWall _payWall = PayWall();
  final TinyState _controlState;
  TinyContractRepo _tinyContractRepo;
  PagewiseLoadController pageLoadController;

  _ContractListWidgetState(this._controlState, this._tinyContractRepo) {
    _tinyContractRepo = _tinyContractRepo ?? TinyContractRepo();
  }

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
          trailing: _buildContractAddButton(),
        ),
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

  _createNewContract() {
    var _tinyContract = TinyContract();
    _tinyContract.isLocked = false;
    _controlState.curDBO = _tinyContract;
    BaseUtil.isLargeScreen(context) ? Navigator.of(context).pushNamed(NavRoutes.CONTRACT_MASTER) : Navigator.of(context).pushNamed(NavRoutes.CONTRACT_EDIT);
  }

  Widget _buildContractAddButton() => CupertinoButton(
    padding: EdgeInsets.all(10),
    child: Text(S.of(context).title_add, key: Key('navbar_btn_add'),),
    onPressed: () {
      _tinyContractRepo.getContractCount().then((contractCount) {
        if ( contractCount > 10 ) {
          _payWall.checkIfPaid(PayFeature.PAY_UNLIMITED_CONTRACTS,
                  () => _createNewContract(),
                  (error) => showDialog(context: context, builder: (ctx) => PayWall.getSubscriptionDialog(PayFeature.PAY_UNLIMITED_CONTRACTS, ctx)));
        } else {
          _createNewContract();
        }
      });

    },
  );

  /// delete contract and print deleted scaffold
  _deleteContract(entry) {
    _tinyContractRepo.delete(entry);

    Scaffold.of(context).showSnackBar(SnackBar(duration: Duration(milliseconds: 1000), content: Text(entry.displayName + " " +  S.of(context).scaff_deleted)));
  }

  _onContractTap(entry) {
    _controlState.curDBO = entry;
    entry.isLocked ? Navigator.of(context).pushNamed(NavRoutes.CONTRACT_GENERATED) :
    BaseUtil.isLargeScreen(context) ? Navigator.of(context).pushNamed(NavRoutes.CONTRACT_MASTER) : Navigator.of(context).pushNamed(NavRoutes.CONTRACT_EDIT);
  }

  Widget _buildContractTileSubtitle(entry) => entry?.preset?.subtitle != null ? Text(entry.preset.subtitle, overflow: TextOverflow.ellipsis,) : null;

  Widget _buildDateBadge(entry, index) => entry.date != null ? Column(key: Key('date_badge_$index'),
    children: <Widget>[
          Icon(CupertinoIcons.time_solid),
          Text(BaseUtil.getLocalFormattedDateTime(context, entry.date).replaceFirst(" ", "\n"), textAlign: TextAlign.center,),
        ],) : Container();

  Widget _buildLocationBadge(entry, index) => Column(key: Key('location_badge_$index'), children: <Widget>[
        Icon(CupertinoIcons.location_solid),
        Text(entry.location + "\n"),
      ],);

  Widget _buildPeopleBadge(TinyPeople tinyPeople, index) => CircleAvatar(
        key: Key('circle_avatar_${tinyPeople.id}_$index'),
        backgroundColor: Colors.lightBlue,
        child: tinyPeople.avatar == null ? Text(
          PeopleListWidget.getCircleText(tinyPeople),
          style: TextStyle(
            color: Colors.white,
          ),
        ) : null,
        backgroundImage: tinyPeople.avatar != null ? new FileImage(
            Io.File(tinyPeople.avatar)) : null,
        radius: 32.0,
      );

  Widget _buildContractTileTrailingLarge(entry, index) => Row(
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      Padding(
        padding: EdgeInsets.only(right: 8.0),
        child: _buildDateBadge(entry, index)),
      Padding(
        padding: EdgeInsets.only(right: 8.0),
        child: _buildLocationBadge(entry, index)),
      Padding(
        padding: EdgeInsets.all(8.0),
        child: _buildPeopleBadge(entry.model, index)),
      Padding(
        padding: EdgeInsets.all(8.0),
        child: _buildPeopleBadge(entry.photographer, index)),
    ],);

  Widget _buildContractTileTrailingSmall(entry, index) => Row(
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      Padding(
          padding: EdgeInsets.all(4.0),
          child: _buildPeopleBadge(entry.model, index)),
      Padding(
          padding: EdgeInsets.all(4.0),
          child: _buildPeopleBadge(entry.photographer, index)),
    ],);

  Widget _buildListTile(entry, index) =>
      ListTile(
        title: Text(entry.displayName, overflow: TextOverflow.ellipsis,
          key: Key('contract_text_$index'),), //_buildContractTileTitle(entry),
        subtitle: _buildContractTileSubtitle(entry),
        trailing: BaseUtil.isLargeScreen(context)
            ? _buildContractTileTrailingLarge(entry, index)
            : _buildContractTileTrailingSmall(entry, index),
        onTap: () => _onContractTap(entry),
      );

  Widget _itemBuilder(context, entry, index) {
    return Dismissible(
      direction: DismissDirection.endToStart,
      background: BaseUtil.getDismissibleBackground(),
      key: Key('contract_$index'),
      onDismissed: (direction) => _deleteContract(entry),
      child: _buildListTile(entry, index));
  }
}
