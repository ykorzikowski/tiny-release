import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tiny_release/screens/control/control_helper.dart';
import 'package:tiny_release/screens/control/control_right.dart';
import 'package:tiny_release/util/ControlState.dart';
import 'package:tiny_release/screens/control/control_left_list.dart';
import 'package:tiny_release/util/BaseUtil.dart';

class MasterControlWidget extends StatefulWidget {
  @override
  _MasterControlState createState() => _MasterControlState();
}

class _MasterControlState extends State<MasterControlWidget> {
  var _isLargeScreen = false;
  var _showEditButton = false;
  var _showNavBackButton = false;
  var _showAddButton = true;
  var _showSaveButton = false;
  var _showContactImportButton = false;

  final GlobalKey<NavigatorState> _navigatorKeyLargeScreen = new GlobalKey<NavigatorState>();
  ControlScreenState controlState;

  _MasterControlState() {
    controlState = new ControlScreenState( _setShowNavBackButton, _setShowAddButton, _setShowEditButton, _setShowSaveButton, _setShowContactImportButton );
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

  bool selectedControlNotWording() {
    return controlState.selectedControlItem < 7;
  }

  void _setShowAddButton( bool val ) {
    setState(() {
      _showAddButton = val;
    });
  }

  void _setShowNavBackButton( bool val ) {
    setState(() {
      _showNavBackButton = val;
    });
  }

  void _setShowEditButton( bool val ) {
    setState(() {
      _showEditButton = val;
    });
  }

  void _setShowSaveButton( bool val ) {
    setState(() {
      _showSaveButton = val;
    });
  }

  void _setShowContactImportButton( bool val ) {
    setState(() {
      _showContactImportButton = val;
    });
  }

  void handleRightNavigationBackButton(context) {
    _navigatorKeyLargeScreen.currentState.pop();
    ControlHelper.setToolbarButtonsBasedOnNavState(controlState, _navigatorKeyLargeScreen.currentState);
  }

  /// called when the control item on the left side of the display is selected
  /// will clear navigation stack on the right and disable the navigation back button
  void largeScreenTransition( int position ) {
    _navigatorKeyLargeScreen.currentState.popUntil( (route) {
      return route.isFirst;
    });
    setState(() {
      controlState.selectedControlItem = position;
    });
  }

  void smallScreenTransition(int position) {
    controlState.selectedControlItem = position;
    ControlHelper.handleControlListTap(controlState, context);
  }

}