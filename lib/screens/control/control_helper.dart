import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tiny_release/data/data_types.dart';
import 'package:tiny_release/data/tiny_people.dart';
import 'package:tiny_release/data/tiny_dbo.dart';
import 'package:tiny_release/data/tiny_layout.dart';
import 'package:tiny_release/data/tiny_preset.dart';
import 'package:tiny_release/data/tiny_reception.dart';
import 'package:tiny_release/data/repo/tiny_repo.dart';
import 'package:tiny_release/screens/layout/layout_edit.dart';
import 'package:tiny_release/screens/people/people_edit.dart';
import 'package:tiny_release/screens/preset/preset_edit.dart';
import 'package:tiny_release/screens/reception_area/reception_edit.dart';
import 'package:tiny_release/util/BaseUtil.dart';
import 'package:tiny_release/util/tiny_state.dart';
import 'package:tiny_release/util/NavRoutes.dart';
import 'package:tiny_release/util/tiny_page_wrapper.dart';

class ControlHelper {

  /// could be implemented directly in DataType if enum is supported
  static String getListTypeForPosition( final int position ) {
    switch (position) {
      case 0:
        return DataType.PEOPLE;
      case 1:
        return DataType.PRESET;
      case 2:
        return DataType.RECEPTION;
      case 3:
        return DataType.LAYOUT;
      case 4:
        return DataType.WORDING;
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

  static void _handleAddButton( final TinyState TinyState, final NavigatorState navigatorState ) {
    Widget widget;

    switch (TinyState.selectedControlItem) {
      case 0:
        var tinyPeople = new TinyPeople();
        tinyPeople.type = TinyState.selectedControlItem;
        TinyState.curDBO = tinyPeople;
        widget = PeopleEditWidget( TinyState );
        break;
      case 1:
        //todo remove when edit window implemented
        TinyPreset tinyPreset = new TinyPreset();
        Paragraph p = new Paragraph();

        tinyPreset.description = "Test 123";
        tinyPreset.displayName = "Blijad";

        p.displayName = "P1";
        p.title = "paragraph";
        p.content = "blabli";

        var list = new List<Paragraph>();
        list.add(p);

        tinyPreset.paragraphs = list;
        TinyState.curDBO = tinyPreset;

        widget = PresetEditWidget( TinyState );
        break;
      case 2:
        //todo remove when edit window implemented
        var tinyReception = new TinyReception();
        tinyReception.displayName = "tinyRec";

        TinyState.curDBO = tinyReception;
        widget = ReceptionEditWidget( TinyState );
        break;
      case 3:
        TinyState.curDBO = new TinyLayout();
        widget = LayoutEditWidget( TinyState );
        break;
      default:
      // TODO
    }

    navigatorState.push(
      TinyPageWrapper(
          title: "Neu",
          transitionDuration: getScreenSizeBasedDuration(navigatorState.context),
          settings: new RouteSettings(name: NavRoutes.PEOPLE_EDIT, isInitialRoute: false),
          builder: (context) {
            return widget;
          }
      ),
    );
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
      case 3:
        return NavRoutes.WORDING;
    }
    return null;
  }

  static Duration getScreenSizeBasedDuration(context) => BaseUtil.isLargeScreen(context) ? Duration.zero : Duration(milliseconds: 325);



}