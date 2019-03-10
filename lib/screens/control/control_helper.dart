import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tiny_release/data/data_types.dart';
import 'package:tiny_release/data/tiny_dbo.dart';
import 'package:tiny_release/data/repo/tiny_repo.dart';
import 'package:tiny_release/util/BaseUtil.dart';
import 'package:tiny_release/util/tiny_state.dart';
import 'package:tiny_release/util/NavRoutes.dart';

class ControlHelper {

  /// could be implemented directly in DataType if enum is supported
  static String getListTypeForPosition( final int position ) {
    switch (position) {
      case 0:
        return TableName.PEOPLE;
      case 1:
        return TableName.PRESET;
      case 2:
        return TableName.RECEPTION;
      case 3:
        return TableName.LAYOUT;
      case 4:
        return TableName.WORDING;
      default:
        return "notImplYet";
    }
  }

  static void handleSaveButton( final TinyState TinyState, final NavigatorState navigatorState ) {
    final TinyDBO curDBO = TinyState.curDBO as TinyDBO;
    TinyRepo repoForDataType = BaseUtil.getRepoForDataType(curDBO);
    repoForDataType.save(curDBO);

    navigatorState.popUntil((route) => !navigatorState.canPop());
    navigatorState.pushNamed(NavRoutes.PEOPLE_LIST);
  }

  static String getControlRouteByIndex( final int index ) {
    switch (index) {
      case 0:
        return NavRoutes.PEOPLE_LIST;
      case 1:
        return NavRoutes.PRESET_LIST;
      case 2:
        return NavRoutes.RECEPTION_LIST;
      case 3:
        return NavRoutes.LAYOUT_LIST;
      case 4:
        return NavRoutes.WORDING;
      case 5:
        return NavRoutes.SETTINGS;
      case 6:
        return NavRoutes.PAYMENT;
    }
    return null;
  }

  static Duration getScreenSizeBasedDuration(context) => BaseUtil.isLargeScreen(context) ? Duration.zero : Duration(milliseconds: 325);

}