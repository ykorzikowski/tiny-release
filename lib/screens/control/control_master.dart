import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tiny_release/screens/control/control_helper.dart';
import 'package:tiny_release/screens/control/control_right.dart';
import 'package:tiny_release/screens/people/people_list.dart';
import 'package:tiny_release/util/ControlState.dart';
import 'package:tiny_release/screens/control/control_left_list.dart';
import 'package:tiny_release/util/BaseUtil.dart';

class MasterControlWidget extends StatefulWidget {
  @override
  _MasterControlState createState() => _MasterControlState();
}

class _MasterControlState extends State<MasterControlWidget> {
  var _isLargeScreen = false;
  var _showNavBackButton = false;
  var _showEditButton = false;
  var _showAddButton = true;
  var _showSaveButton = false;

  final GlobalKey<NavigatorState> _navigatorKeyLargeScreen = new GlobalKey<NavigatorState>();
  ControlScreenState controlState;

  _MasterControlState() {
    controlState = new ControlScreenState( _setShowNavBackButton, _setShowAddButton, _setShowEditButton, _setShowSaveButton );
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
          _showAddButton ? IconButton(
            icon: Icon(Icons.add),
            tooltip: 'Add new',
            onPressed: () {
              ControlHelper.handleAddButton( controlState, _navigatorKeyLargeScreen.currentState );
            },
          ) : Container(),
          _showEditButton && _isLargeScreen ? IconButton(
            icon: Icon(Icons.edit),
            tooltip: 'Edit',
            onPressed: () {
              controlState.setToolbarButtonsOnEdit();
              ControlHelper.handleEditButton( controlState, _navigatorKeyLargeScreen.currentState );
            },
          ) : Container(),
          _showSaveButton && _isLargeScreen ? IconButton(
            icon: Icon(Icons.save_alt),
            tooltip: 'Save',
            onPressed: () {
              controlState.setToolbarButtonsOnList();
              ControlHelper.handleSaveButton( controlState, _navigatorKeyLargeScreen.currentState );
            },
          ) : Container(),
        ],
      ),
      body: OrientationBuilder(builder: (context, orientation) {
        _isLargeScreen = BaseUtil.isLargeScreen(context);

        return Row(children: <Widget>[
          Expanded(
            child: ControlLeftListWidget((position) {
              controlState.selectedControlItem = position;
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
      controlState.setToolbarButtonsOnList();
      controlState.selectedControlItem = position;
    });
  }

  void smallScreenTransition(int position) {
    // todo switch case
    Navigator.push(context, MaterialPageRoute(
        builder: (context) {
          return PeopleListWidget(controlState);
        }
    )
    );
  }

}