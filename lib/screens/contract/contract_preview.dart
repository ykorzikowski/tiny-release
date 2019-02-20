
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tiny_release/data/repo/tiny_preset_repo.dart';
import 'package:tiny_release/data/tiny_contract.dart';
import 'package:tiny_release/data/tiny_preset.dart';
import 'package:tiny_release/generated/i18n.dart';
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

  _getTitle(Paragraph p) {
    return '§' + p.position.toString() + " " + p.title;
  }

  buildPreview() {
    var widgetList = List<Widget>();
    _tinyContract.preset.paragraphs.forEach((paragraph) {
      widgetList.add(Text(_getTitle(paragraph), style: TextStyle( fontSize: 24 ),));
      widgetList.add(Text(paragraph.content));
    });

    return widgetList;
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        heroTag: 'contract',
        transitionBetweenRoutes: false,
        border: null,
        middle: Text(S.of(context).tile_contact_preview),
        trailing: !BaseUtil.isLargeScreen(context) ? CupertinoButton(
          child: Text(S.of(context).btn_edit),
          onPressed: () =>
              Navigator.of(context).pushNamed(NavRoutes.PRESET_EDIT),
        ) : null,),
      child:
      Scaffold(
        resizeToAvoidBottomPadding: false,
        body: SafeArea(
            child: _tinyContract.preset == null ? Text("No preset selected") : ListView( children: buildPreview(), ),
        ),
      ),
    );
  }

}