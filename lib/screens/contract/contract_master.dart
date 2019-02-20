import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tiny_release/screens/contract/contract_preview.dart';
import 'package:tiny_release/screens/control/control_helper.dart';
import 'package:tiny_release/util/NavRoutes.dart';
import 'package:tiny_release/util/tiny_page_wrapper.dart';
import 'package:tiny_release/util/tiny_state.dart';

class ContractMasterWidget extends StatefulWidget {

  TinyState _controlState;

  ContractMasterWidget(this._controlState);

  @override
  _ContractMasterWidgetState createState() => _ContractMasterWidgetState(_controlState);
}

class _ContractMasterWidgetState extends State<ContractMasterWidget> {

  final GlobalKey<NavigatorState> _navigatorKeyLargeScreen = new GlobalKey<NavigatorState>();
  TinyState _controlState;

  _ContractMasterWidgetState(this._controlState);

  @override
  Widget build(BuildContext context) {
    return
      CupertinoPageScaffold(
        child:
        Scaffold(
          resizeToAvoidBottomPadding: false,
          body: OrientationBuilder(builder: (context, orientation) {
            return Row(children: <Widget>[
              Expanded(
                flex: 5,
                child:
                Navigator(
                    key: _navigatorKeyLargeScreen,
                    initialRoute: NavRoutes.CONTRACT_EDIT,
                    onGenerateRoute: (RouteSettings settings) {
                      return TinyPageWrapper(
                        settings: settings,
                        transitionDuration: ControlHelper.getScreenSizeBasedDuration(context),
                        builder: _controlState.routes.containsKey(settings.name)
                            ? _controlState
                            .routes[settings.name]
                            : (context) => Container(),
                      );
                    }
                ),
              ),
              Expanded(
                  flex: 5,
                  child: ContractPreviewWidget(_controlState)
              ),
            ]);
          }),
        ),);
  }

  void handleRightNavigationBackButton(context) {
    _navigatorKeyLargeScreen.currentState.pop();
  }

}