
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tiny_release/data/repo/tiny_contract_repo.dart';
import 'package:tiny_release/data/tiny_contract.dart';
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

    return
      CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          transitionBetweenRoutes: false,
          leading: BaseUtil.isLargeScreen(context) ? Container() : null,
          middle: Text("Contracts"),
          trailing:CupertinoButton(
            child: Text("Hinzufügen"),
            onPressed: () {
              var _tinyContract = TinyContract();
              _controlState.curDBO = _tinyContract;
              BaseUtil.isLargeScreen(context) ? Navigator.of(context).pushNamed(NavRoutes.CONTRACT_MASTER) : Navigator.of(context).pushNamed(NavRoutes.CONTRACT_EDIT);
            },
          ),),
        child: SafeArea(
          child: Scaffold(
            resizeToAvoidBottomPadding: false,
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
      key: Key(entry.id.toString()),
      onDismissed: (direction) {
        _tinyContractRepo.delete(entry);

        Scaffold
            .of(context)
            .showSnackBar(
            SnackBar(content: Text(entry.displayName + " dismissed")));
      },
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text(entry.displayName),
            onTap: () {
              // todo if isFinished = directly go to generated widget
            },
          ),
          Divider()
        ],
      ),);
  }
}