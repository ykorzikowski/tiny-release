import 'package:flutter/material.dart';
import 'package:tiny_release/screens/control/control_helper.dart';
import 'package:tiny_release/util/ControlState.dart';

typedef Null ItemSelectedCallback(int value);

class ControlRightWidget extends StatefulWidget {

  final ControlScreenState controlState;
  final GlobalKey<NavigatorState> navigatorKeyLargeScreen;

  ControlRightWidget( this.controlState, this.navigatorKeyLargeScreen );

  @override
  _ControlRightWidgetState createState() => _ControlRightWidgetState(controlState, navigatorKeyLargeScreen);
}

class _ControlRightWidgetState extends State<ControlRightWidget> {

  final ControlScreenState controlState;
  final GlobalKey<NavigatorState> navigatorKeyLargeScreen;

  _ControlRightWidgetState( this.controlState, this.navigatorKeyLargeScreen );

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKeyLargeScreen,
      onGenerateRoute: (RouteSettings settings) {
        MaterialPageRoute(builder: (context) => ControlHelper.getListWidgetByControlItem(controlState) );
      },
    );
  }
}