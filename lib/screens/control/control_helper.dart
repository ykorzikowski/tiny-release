import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:paperflavor/data/data_types.dart';
import 'package:paperflavor/data/tiny_dbo.dart';
import 'package:paperflavor/data/repo/tiny_repo.dart';
import 'package:paperflavor/util/base_util.dart';
import 'package:paperflavor/util/tiny_state.dart';
import 'package:paperflavor/util/nav_routes.dart';

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
      default:
        return "notImplYet";
    }
  }

  static void handleSaveButton( final TinyState tinyState, final NavigatorState navigatorState ) {
    final TinyDBO curDBO = tinyState.curDBO;
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
        return NavRoutes.SETTINGS;
      case 5:
        return NavRoutes.PAYMENT;
    }
    return null;
  }

  static Duration getScreenSizeBasedDuration(context) => BaseUtil.isLargeScreen(context) ? Duration.zero : Duration(milliseconds: 325);

}
