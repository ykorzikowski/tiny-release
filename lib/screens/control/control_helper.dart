import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tiny_release/data/data_types.dart';
import 'package:tiny_release/data/tiny_contact.dart';
import 'package:tiny_release/data/tiny_dbo.dart';
import 'package:tiny_release/data/tiny_layout.dart';
import 'package:tiny_release/data/tiny_preset.dart';
import 'package:tiny_release/data/tiny_reception.dart';
import 'package:tiny_release/data/repo/tiny_repo.dart';
import 'package:tiny_release/screens/layout/layout_edit.dart';
import 'package:tiny_release/screens/layout/layout_list.dart';
import 'package:tiny_release/screens/people/people_edit.dart';
import 'package:tiny_release/screens/people/people_list.dart';
import 'package:tiny_release/screens/preset/preset_edit.dart';
import 'package:tiny_release/screens/preset/preset_list.dart';
import 'package:tiny_release/screens/reception_area/reception_edit.dart';
import 'package:tiny_release/screens/reception_area/reception_list.dart';
import 'package:tiny_release/screens/wording/wording_settings.dart';
import 'package:tiny_release/util/BaseUtil.dart';
import 'package:tiny_release/util/ControlState.dart';

class ControlHelper {

  /// could be implemented directly in DataType if enum is supported
  static String getListTypeForPosition( final int position ) {
    switch (position) {
      case 0:
        return DataType.MODEL;
      case 1:
        return DataType.PHOTOGRAPHER;
      case 2:
        return DataType.WITNESS;
      case 3:
        return DataType.PARENT;
      case 4:
        return DataType.PRESET;
      case 5:
        return DataType.RECEPTION;
      case 6:
        return DataType.LAYOUT;
      case 7:
        return DataType.WORDING;
      default:
        return "notImplYet";
    }
  }

  /// called when the edit button in toolbar is hit
  /// determines what kind of item we want to edit
  static void handleEditButton( final ControlScreenState controlScreenState, final NavigatorState navigatorState ) {
    Widget widget;
    switch (controlScreenState.selectedControlItem) {
      case 0:
      case 1:
      case 2:
      case 3:
        widget = PeopleEditWidget( controlScreenState );
        break;
      case 4:
        widget = PresetEditWidget( controlScreenState );
        break;
      case 5:
        widget = ReceptionEditWidget( controlScreenState );
        break;
      case 6:
        widget = LayoutEditWidget( controlScreenState );
        break;
      default:
      // TODO
    }

    navigatorState.push(
      MaterialPageRoute(
          builder: (context) {
            return widget;
          }
      ),
    );
  }

  static void setToolbarButtonsBasedOnNavState( final ControlScreenState controlScreenState, final NavigatorState navigatorState ) {
    navigatorState.popUntil((route) {
      if ( route.isFirst ) {
        controlScreenState.setToolbarButtonsOnList();
      } else {
        controlScreenState.setToolbarButtonsOnPreview();
      }
      return true;
    });
  }

  static void handleSaveButton( final ControlScreenState controlScreenState, final NavigatorState navigatorState ) {
    final TinyDBO curDBO = controlScreenState.curDBO as TinyDBO;
    TinyRepo repoForDataType = BaseUtil.getRepoForDataType(curDBO);
    repoForDataType.save(curDBO);

    navigatorState.pop();
    setToolbarButtonsBasedOnNavState( controlScreenState, navigatorState );
  }

  static void handleAddButton( final ControlScreenState controlScreenState, final NavigatorState navigatorState ) {
    Widget widget;
    controlScreenState.setToolbarButtonsOnEdit();

    switch (controlScreenState.selectedControlItem) {
      case 0:
      case 1:
      case 2:
      case 3:
        controlScreenState.curDBO = new TinyContact();
        widget = PeopleEditWidget( controlScreenState );
        break;
      case 4:
        controlScreenState.curDBO = new TinyPreset();
        widget = PresetEditWidget( controlScreenState );
        break;
      case 5:
        controlScreenState.curDBO = new TinyReception();
        widget = ReceptionEditWidget( controlScreenState );
        break;
      case 6:
        controlScreenState.curDBO = new TinyLayout();
        widget = LayoutEditWidget( controlScreenState );
        break;
      default:
      // TODO
    }

    navigatorState.push(
      MaterialPageRoute(
          builder: (context) {
            return widget;
          }
      ),
    );
  }

  static Widget getListWidgetByControlItem( final ControlScreenState controlScreenState ) {
    switch (controlScreenState.selectedControlItem) {
      case 0:
      case 1:
      case 2:
      case 3:
        return PeopleListWidget( controlScreenState );
      case 4:
        return PresetListWidget( controlScreenState );
      case 5:
        return ReceptionListWidget( controlScreenState );
      case 6:
        return new LayoutListWidget( controlScreenState );
      case 7:
        return new WordingSettingsWidget( controlScreenState );
    }
    return null;
  }

  static void handleControlListTap(final ControlScreenState controlScreenState, final NavigatorState navigatorState) {
    Widget widget = getListWidgetByControlItem( controlScreenState );
    controlScreenState.setToolbarButtonsOnList();

    navigatorState.push(
      MaterialPageRoute(
          builder: (context) {
            return widget;
          }
      ),
    );
  }
}