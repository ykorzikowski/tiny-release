
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tiny_release/generated/i18n.dart';
import 'package:tiny_release/screens/control/control_helper.dart';
import 'package:tiny_release/util/BaseUtil.dart';
import 'package:tiny_release/util/tiny_state.dart';

typedef Null ItemSelectedCallback(int value);

class WordingSettingsWidget extends StatefulWidget {

  final TinyState _controlState;

  WordingSettingsWidget(this._controlState);

  @override
  _WordingSettingsWidgetState createState() => _WordingSettingsWidgetState(_controlState);
}

class _WordingSettingsWidgetState extends State<WordingSettingsWidget> {
  final TinyState _controlState;

  _WordingSettingsWidgetState(this._controlState);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        heroTag: 'control',
        transitionBetweenRoutes: false,
        leading: BaseUtil.isLargeScreen(context) ? Container() : null,
        middle: Text(S.of(context).title_wording),

        ),
      child: SafeArea(  child: Scaffold(
        resizeToAvoidBottomPadding: false,
        body: Text("TODO"),
      ),
    ), );
  }

}