import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tiny_release/data/contact_full.dart';
import 'package:tiny_release/screens/control/controls_str.dart';
import 'package:tiny_release/screens/people/people_edit.dart';
import 'package:tiny_release/util/ControlState.dart';

class ControlHelper {

  static String getListTypeForPosition( final int position ) {
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

  static void handleEditButton( final ControlScreenState controlScreenState, final NavigatorState navigatorState) {
    navigatorState.push(
        MaterialPageRoute(
            builder: (context) {
              return PeopleEditWidget(controlScreenState, new TinyContact());
            }
        ),
    );

    switch (controlScreenState.selectedControlItem) {
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

  static void handleAddButton( final ControlScreenState controlScreenState, final NavigatorState navigatorState ) {

  }
}