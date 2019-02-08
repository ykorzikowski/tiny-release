import 'package:flutter/material.dart';
import 'package:tiny_release/util/ControlState.dart';
import 'package:tiny_release/screens/people/people_list.dart';

typedef Null ItemSelectedCallback(int value);

class ControlRightWidget extends StatefulWidget {

  final ControlState controlState;

  ControlRightWidget( this.controlState );

  @override
  _ControlRightWidgetState createState() => _ControlRightWidgetState(controlState);
}

class _ControlRightWidgetState extends State<ControlRightWidget> {

  final ControlState controlState;

  _ControlRightWidgetState( this.controlState );

//  @override
//  void setState(fn) {
//    Navigator.pushNamed(context, controlState.value);
//    if ( controlState.navBack ) {
//      Navigator.pop(context);
//      controlState.navBack = false;
//    }
//
//    super.setState(fn);
//  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (RouteSettings settings) {
        switch (settings.name) {
        // todo models, photographer routes
          default:
            return MaterialPageRoute(builder: (context) => PeopleListWidget(controlState) );
        }
      },
    );
  }
}