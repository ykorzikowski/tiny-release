import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tiny_release/data/tiny_dbo.dart';
import 'package:tiny_release/screens/control/control_master.dart';
import 'package:tiny_release/screens/layout/layout_edit.dart';
import 'package:tiny_release/screens/layout/layout_list.dart';
import 'package:tiny_release/screens/layout/layout_preview.dart';
import 'package:tiny_release/screens/people/people_edit.dart';
import 'package:tiny_release/screens/people/people_import_callback.dart';
import 'package:tiny_release/screens/people/people_list.dart';
import 'package:tiny_release/screens/people/people_list_callback.dart';
import 'package:tiny_release/screens/people/people_preview.dart';
import 'package:tiny_release/screens/preset/preset_edit.dart';
import 'package:tiny_release/screens/preset/preset_list.dart';
import 'package:tiny_release/screens/preset/preset_preview.dart';
import 'package:tiny_release/screens/reception_area/reception_list.dart';
import 'package:tiny_release/screens/wording/wording_settings.dart';
import 'package:tiny_release/util/NavRoutes.dart';

class TinyState {

  PeopleImportCallback peopleImportCallback;
  PeopleListCallback peopleListCallback;
  Map<String, WidgetBuilder> routes;
  
  /// the selected control item
  int selectedControlItem = 0;

  /// the current selected data item
  TinyDBO curDBO;

  TinyState() {
    this.peopleImportCallback = PeopleImportCallback(this);
    this.peopleListCallback = PeopleListCallback(this);
    this.routes = {
      NavRoutes.CONTROL_LIST: (context) => MasterControlWidget(this),
      /// PEOPLE ROUTE
      NavRoutes.PEOPLE_LIST: (context) => PeopleListWidget(this, peopleListCallback.getPeople, peopleListCallback.onPeopleTap),
      NavRoutes.PEOPLE_IMPORT: (context) => PeopleListWidget(this, peopleImportCallback.getPeople, peopleImportCallback.onPeopleTap),
      NavRoutes.PEOPLE_EDIT: (context) => PeopleEditWidget(this),
      NavRoutes.PEOPLE_PREVIEW: (context) => PeoplePreviewWidget(this),

      NavRoutes.PRESET_LIST: (context) => PresetListWidget(this),
      NavRoutes.PRESET_PREVIEW: (context) => PresetPreviewWidget(this),
      NavRoutes.PRESET_EDIT: (context) => PresetEditWidget(this),

      NavRoutes.RECEPTION_LIST: (context) => ReceptionListWidget(this),

      NavRoutes.LAYOUT_LIST: (context) => LayoutListWidget(this),
      NavRoutes.LAYOUT_PREVIEW: (context) => LayoutPreviewWidget(this),
      NavRoutes.LAYOUT_EDIT: (context) => LayoutEditWidget(this),

      NavRoutes.WORDING: (context) => WordingSettingsWidget(this),
    };
  }
}