
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tiny_release/data/tiny_contract.dart';
import 'package:tiny_release/util/BaseUtil.dart';
import 'package:tiny_release/util/NavRoutes.dart';
import 'package:tiny_release/util/tiny_state.dart';

typedef Null ItemSelectedCallback(int value);

class ContractPreviewWidget extends StatefulWidget {

  final TinyState _controlState;

  ContractPreviewWidget(this._controlState);

  @override
  _ContractPreviewWidgetState createState() => _ContractPreviewWidgetState(_controlState);
}

class _ContractPreviewWidgetState extends State<ContractPreviewWidget> {
  final TinyState _controlState;
  TinyContract _tinyContract;

  _ContractPreviewWidgetState(this._controlState) {
    _tinyContract = _controlState.curDBO;
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        transitionBetweenRoutes: false,
        border: null,
        middle: Text("Contact Preview"),
        trailing: !BaseUtil.isLargeScreen(context) ? CupertinoButton(
          child: Text("Bearbeiten"),
          onPressed: () =>
              Navigator.of(context).pushNamed(NavRoutes.PRESET_EDIT),
        ) : null,),
      child:
      Scaffold(
        resizeToAvoidBottomPadding: false,
        body: SafeArea(
            child: Text("Text")
        ),
      ),
    );
  }

}