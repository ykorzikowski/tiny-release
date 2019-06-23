import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:paperflavor/screens/control/control_helper.dart';
import 'package:paperflavor/util/nav_routes.dart';
import 'package:paperflavor/util/tiny_state.dart';
import 'package:paperflavor/util/tiny_page_wrapper.dart';

typedef Null ItemSelectedCallback(int value);

class ControlRightWidget extends StatefulWidget {

  final TinyState controlState;
  final GlobalKey<NavigatorState> navigatorKeyLargeScreen;

  ControlRightWidget( this.controlState, this.navigatorKeyLargeScreen );

  @override
  _ControlRightWidgetState createState() => _ControlRightWidgetState(controlState, navigatorKeyLargeScreen);
}

class _ControlRightWidgetState extends State<ControlRightWidget> {

  final TinyState controlState;
  final GlobalKey<NavigatorState> navigatorKeyLargeScreen;

  _ControlRightWidgetState( this.controlState, this.navigatorKeyLargeScreen );

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKeyLargeScreen,
      initialRoute: NavRoutes.PEOPLE_LIST,
      onGenerateRoute: (RouteSettings settings) {
        return TinyPageWrapper(
          settings: settings,
          transitionDuration: ControlHelper.getScreenSizeBasedDuration(context),
          builder: controlState.routes.containsKey(settings.name) ? controlState
              .routes[settings.name] : (context) => Container(),
        );
      }
    );
  }
}
