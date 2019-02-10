import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tiny_release/screens/control/control_right.dart';
import 'package:tiny_release/screens/people/people_list.dart';
import 'package:tiny_release/util/ControlState.dart';
import 'package:tiny_release/screens/control/controls_str.dart';
import 'package:tiny_release/screens/control/control_left_list.dart';
import 'package:tiny_release/util/BaseUtil.dart';

class MasterControlWidget extends StatefulWidget {
  @override
  _MasterControlState createState() => _MasterControlState();
}

class _MasterControlState extends State<MasterControlWidget> {
  var _selectedControlEntry = 0;
  var _isLargeScreen = false;
  var _showNavBackButton = false;

  final GlobalKey<NavigatorState> _navigatorKeyLargeScreen = new GlobalKey<NavigatorState>();
  ControlScreenState controlState;

  _MasterControlState() {
    controlState = new ControlScreenState(_setShowNavBackButton);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Verwaltung"),
        actions: <Widget>[
          _showNavBackButton && _isLargeScreen ? IconButton(
            icon: Icon(Icons.arrow_back_ios),
            tooltip: 'Back',
            onPressed: () {
              handleRightNavigationBackButton(context);
            },
          ) : Container(),
          IconButton(
            icon: Icon(Icons.add),
            tooltip: 'Add new',
            onPressed: () {
              handleAddButton();
            },
          ),
        ],
      ),
      body: OrientationBuilder(builder: (context, orientation) {
        _isLargeScreen = BaseUtil.isLargeScreen(context);

        return Row(children: <Widget>[
          Expanded(
            child: ControlLeftListWidget((position) {
              controlState.selectedControlItem = getListTypeForPosition( position );
              _isLargeScreen ? largeScreenTransition( position ) : smallScreenTransition( position );
            }),
          ),
          _isLargeScreen ? Expanded(
              child: ControlRightWidget(controlState, _navigatorKeyLargeScreen)
          ) : Container(),
        ]);
      }),
    );
  }

  void _setShowNavBackButton( bool val ) {
    setState(() {
      _showNavBackButton = val;
    });
  }

  void handleAddButton() {
    switch (_selectedControlEntry) {
      case 0:
      // TODO add model
        break;
      case 1:
      // TODO add photographer
        break;
      case 2:
      // TODO add witness
        break;
      case 3:
      // TODO add parent
        break;
      case 4:
      // TODO add preset
        break;
      case 5:
      // TODO add capture area
        break;
      case 6:
      // TODO add layouts
        break;
      default:
      // TODO
    }
  }

  void handleRightNavigationBackButton(context) {
    _navigatorKeyLargeScreen.currentState.pop();
    _navigatorKeyLargeScreen.currentState.popUntil( (route) {
      if ( route.isFirst ) {
        _setShowNavBackButton( false );
      }
      return true;
    });
  }

  void largeScreenTransition( int position ) {
    _navigatorKeyLargeScreen.currentState.popUntil( (route) {
      return route.isFirst;
    });
    setState(() {
      _showNavBackButton = false;
      _selectedControlEntry = position;
    });
  }

  void smallScreenTransition(int position) {
    // todo switch case
    Navigator.push(context, MaterialPageRoute(
        builder: (context) {
          return Scaffold(
              appBar: AppBar(title: Text(controlState.selectedControlItem),),
              body: PeopleListWidget(controlState)
          );
        }
    )
    );
  }

  String getListTypeForPosition(int position) {
    switch (position) {
      case 0:
        return Controls.MODEL;
      case 1:
        return Controls.PHOTOGRAPHER;
      case 2:
        return Controls.WITNESS;
      case 3:
        return Controls.PARENT;
      default:
        return "notImplYet";
    }
  }
}