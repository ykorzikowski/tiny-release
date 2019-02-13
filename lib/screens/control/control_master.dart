import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tiny_release/screens/control/control_helper.dart';
import 'package:tiny_release/screens/control/control_right.dart';
import 'package:tiny_release/util/tiny_state.dart';
import 'package:tiny_release/screens/control/control_left_list.dart';
import 'package:tiny_release/util/BaseUtil.dart';

class MasterControlWidget extends StatefulWidget {
  @override
  _MasterControlState createState() => _MasterControlState();
}

class _MasterControlState extends State<MasterControlWidget> {
  var _isLargeScreen = false;

  final GlobalKey<NavigatorState> _navigatorKeyLargeScreen = new GlobalKey<NavigatorState>();
  TinyState controlState;

  _MasterControlState() {
    controlState = new TinyState( );
  }

  @override
  Widget build(BuildContext context) {
    return
      CupertinoPageScaffold(
        child:
      Scaffold(
      body: OrientationBuilder(builder: (context, orientation) {
        _isLargeScreen = BaseUtil.isLargeScreen(context);

        return Row(children: <Widget>[
          Expanded(
            child: ControlLeftListWidget((position) {
              _isLargeScreen ? largeScreenTransition( position ) : smallScreenTransition( position );
            }),
          ),
          _isLargeScreen ? Expanded(
              child: ControlRightWidget(controlState, _navigatorKeyLargeScreen)
          ) : Container(),
        ]);
      }),
    ), );
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
    controlState.selectedControlItem = position;
    _navigatorKeyLargeScreen.currentState.pushNamed(ControlHelper.getControlRouteByIndex(position));
  }

  void smallScreenTransition(int position) {
    controlState.selectedControlItem = position;
    Navigator.of(context).pushNamed(ControlHelper.getControlRouteByIndex(position));
  }

}