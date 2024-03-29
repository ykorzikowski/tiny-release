import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:paperflavor/screens/control/control_helper.dart';
import 'package:paperflavor/screens/control/control_right.dart';
import 'package:paperflavor/util/tiny_state.dart';
import 'package:paperflavor/screens/control/control_left_list.dart';
import 'package:paperflavor/util/base_util.dart';

class MasterControlWidget extends StatefulWidget {

  final TinyState _controlState;

  MasterControlWidget(this._controlState);

  @override
  _MasterControlState createState() => _MasterControlState(_controlState);
}

class _MasterControlState extends State<MasterControlWidget> {
  var _isLargeScreen = false;

  final GlobalKey<NavigatorState> _navigatorKeyLargeScreen = new GlobalKey<NavigatorState>();
  TinyState _controlState;

  _MasterControlState(this._controlState);

  @override
  Widget build(BuildContext context) {
    return
      CupertinoPageScaffold(
        child:
        Scaffold(
          resizeToAvoidBottomPadding: false,
          body: OrientationBuilder(builder: (context, orientation) {
            _isLargeScreen = BaseUtil.isLargeScreen(context);

            return Row(children: <Widget>[
              Expanded(
                child: ControlLeftListWidget((position) {
                  _isLargeScreen
                      ? largeScreenTransition(position)
                      : smallScreenTransition(position);
                }, _controlState),
              ),
              _isLargeScreen ? Expanded(
                  flex: 2,
                  child: ControlRightWidget(
                      _controlState, _navigatorKeyLargeScreen)
              ) : Container(),
            ]);
          }),
        ),);
  }

  void handleRightNavigationBackButton(context) {
    _navigatorKeyLargeScreen.currentState.pop();
  }

  /// called when the control item on the left side of the display is selected
  /// will clear navigation stack on the right and disable the navigation back button
  void largeScreenTransition( int position ) {
    _navigatorKeyLargeScreen.currentState.popUntil( (route) {
      return route.isFirst;
    });
    _controlState.selectedControlItem = position;
    _navigatorKeyLargeScreen.currentState.pushNamed(ControlHelper.getControlRouteByIndex(position));
  }

  void smallScreenTransition(int position) {
    _controlState.selectedControlItem = position;
    Navigator.of(context).pushNamed(ControlHelper.getControlRouteByIndex(position));
  }

}
