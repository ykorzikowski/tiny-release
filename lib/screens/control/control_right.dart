import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tiny_release/screens/control/control_helper.dart';
import 'package:tiny_release/util/BaseUtil.dart';
import 'package:tiny_release/util/ControlState.dart';
import 'package:tiny_release/util/NavRoutes.dart';
import 'package:tiny_release/util/tiny_page_wrapper.dart';

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
        return TinyPageWrapper(
          settings: new RouteSettings(name: NavRoutes.CONTROL_SUB_LIST, isInitialRoute: false),
          transitionDuration: ControlHelper.getScreenSizeBasedDuration(context),
          builder: (context) =>
              ControlHelper.getListWidgetByControlItem(controlState),);
      },
    );
  }
}