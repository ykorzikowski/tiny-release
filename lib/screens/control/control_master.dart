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
  var selectedControlEntry = 0;
  var isLargeScreen = false;
  ControlState controlState = new ControlState();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Verwaltung"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            tooltip: 'Add new',
            onPressed: () {
              handleAddButton();
            },
          ),
          IconButton(
            icon: Icon(Icons.arrow_back_ios),
            tooltip: 'Back',
            onPressed: () {
              handleRightNavigationBackButton(context);
            },
          ),
        ],
      ),
      body: OrientationBuilder(builder: (context, orientation) {
        isLargeScreen = BaseUtil.isLargeScreen(context);

        return Row(children: <Widget>[
          Expanded(
            child: ControlLeftListWidget((position) {
              controlState.value = getListTypeForPosition( position );
              isLargeScreen ? largeScreenTransition( position ) : smallScreenTransition( position );
            }),
          ),
          isLargeScreen ? Expanded(
              child: ControlRightWidget(controlState)
          ) : Container(),
        ]);
      }),
    );
  }

  void handleAddButton() {
    switch (selectedControlEntry) {
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
    controlState.navBack = true;
    setState(() {});
    // todo
  }

  void largeScreenTransition( int position ) {
    selectedControlEntry = position;
    setState(() {});
  }

  void smallScreenTransition(int position) {
    // todo switch case 
    Navigator.push(context, MaterialPageRoute(
        builder: (context) {
          return Scaffold(
              appBar: AppBar(title: Text(controlState.value),),
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