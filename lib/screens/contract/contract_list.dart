
import 'dart:io' as Io;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tiny_release/data/repo/tiny_contract_repo.dart';
import 'package:tiny_release/data/tiny_contract.dart';
import 'package:tiny_release/generated/i18n.dart';
import 'package:tiny_release/screens/people/people_list.dart';
import 'package:tiny_release/util/base_util.dart';
import 'package:tiny_release/util/nav_routes.dart';
import 'package:tiny_release/util/paywall.dart';
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
  final PayWall _payWall = PayWall();

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

  Widget _buildContractTileTitle(entry) => Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(entry.isLocked == true
            ? CupertinoIcons.check_mark_circled_solid
            : CupertinoIcons.pen,
          color: entry.isLocked == true
              ? CupertinoColors.black
              : CupertinoColors.activeBlue,),
        Padding(
          padding: const EdgeInsets.only(left: 8.0, top: 8.0),
          child: Text(entry.displayName),
        ),
        ],);
  
  Widget _buildContractTileSubtitle(entry) => entry?.preset?.subtitle != null ? Text(entry.preset.subtitle) : null;

  Widget _buildDateBadge(entry) => entry.date != null ? Column(children: <Widget>[
          Icon(CupertinoIcons.time_solid),
          Text(BaseUtil.getLocalFormattedDateTime(context, entry.date).replaceFirst(" ", "\n"), textAlign: TextAlign.center,),
        ],) : Container();

  Widget _buildLocationBadge(entry) => Column(children: <Widget>[
        Icon(CupertinoIcons.location_solid),
        Text(entry.location + "\n"),
      ],);

  Widget _buildModelBadge(entry) => CircleAvatar(
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
      );

  Widget _buildPhotographerBadge(entry) => CircleAvatar(
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
      );

  Widget _buildContractTileTrailingLarge(entry) => Row(
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      Padding(
          padding: EdgeInsets.only(right: 8.0),
          child: _buildDateBadge(entry)),
      Padding(
          padding: EdgeInsets.only(right: 8.0),
          child: _buildLocationBadge(entry)),
      Padding(
        padding: EdgeInsets.all(8.0),
        child: _buildModelBadge(entry)),
      Padding(
        padding: EdgeInsets.all(8.0),
        child: _buildPhotographerBadge(entry) ),
    ],);

  Widget _buildContractTileTrailingSmall(entry) => Row(
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      Padding(
          padding: EdgeInsets.all(8.0),
          child: _buildModelBadge(entry)),
      Padding(
          padding: EdgeInsets.all(8.0),
          child: _buildPhotographerBadge(entry) ),
    ],);

  Widget _itemBuilder(context, entry, index) {
    return Dismissible(
      direction: DismissDirection.endToStart,
      background: BaseUtil.getDismissibleBackground(),
      key: Key('contract_$index'),
      onDismissed: (direction) => _deleteContract(entry),
      child: Column(
        children: <Widget>[
          ListTile(
            title: _buildContractTileTitle(entry),
            subtitle: _buildContractTileSubtitle(entry),
            trailing: BaseUtil.isLargeScreen(context) ? _buildContractTileTrailingLarge(entry) : _buildContractTileTrailingSmall(entry),
            onTap: () => _onContractTap(entry),
          ),
          Divider()
        ],
      ),);
  }
}