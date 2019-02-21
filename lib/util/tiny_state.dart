import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tiny_release/data/tiny_dbo.dart';
import 'package:tiny_release/screens/contract/contract_edit.dart';
import 'package:tiny_release/screens/contract/contract_list.dart';
import 'package:tiny_release/screens/contract/contract_master.dart';
import 'package:tiny_release/screens/contract/contract_preview.dart';
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
import 'package:tiny_release/screens/preset/preset_edit_sort.dart';
import 'package:tiny_release/screens/preset/preset_list.dart';
import 'package:tiny_release/screens/preset/preset_preview.dart';
import 'package:tiny_release/screens/reception_area/reception_list.dart';
import 'package:tiny_release/screens/settings.dart';
import 'package:tiny_release/screens/wording/wording_settings.dart';
import 'package:tiny_release/util/NavRoutes.dart';

class TinyState {

  Function tinyEditCallback;

  /// callbacks for people widgets
  PeopleImportCallback peopleImportCallback;
  PeopleListCallback peopleListCallback;

  /// map that stores the routes of the app
  Map<String, WidgetBuilder> routes;
  
  /// the selected control item
  int selectedControlItem = 0;

  /// the current selected data item
  TinyDBO curDBO;

  /// returns if user is currently in control widget
  bool inControlWidget = false;

  TinyState() {
    this.peopleImportCallback = PeopleImportCallback(this);
    this.peopleListCallback = PeopleListCallback(this);
    this.routes = {
      NavRoutes.CONTRACT_MASTER: (context) => ContractMasterWidget(this),
      NavRoutes.CONTRACT_LIST: (context) => ContractListWidget(this),
      NavRoutes.CONTRACT_EDIT: (context) => ContractEditWidget(this),
      NavRoutes.CONTRACT_PREVIEW: (context) => ContractPreviewWidget(this),
      NavRoutes.CONTRACT_GENERATED: (context) => MasterControlWidget(this),

      NavRoutes.CONTROL_LIST: (context) => MasterControlWidget(this),
      /// PEOPLE ROUTE
      NavRoutes.PEOPLE_LIST: (context) => PeopleListWidget(this, peopleListCallback.getPeople, peopleListCallback.onPeopleTap),
      NavRoutes.PEOPLE_IMPORT: (context) => PeopleListWidget(this, peopleImportCallback.getPeople, peopleImportCallback.onPeopleTap, isContactImportDialog: false,),
      NavRoutes.PEOPLE_EDIT: (context) => PeopleEditWidget(this),
      NavRoutes.PEOPLE_PREVIEW: (context) => PeoplePreviewWidget(this),

      NavRoutes.PRESET_LIST: (context) =>
          PresetListWidget(this, (item, context) {
            this.curDBO = item;

            Navigator.of(context).pushNamed(NavRoutes.PRESET_PREVIEW);
          }),

      NavRoutes.PRESET_PREVIEW: (context) => PresetPreviewWidget(this),
      NavRoutes.PRESET_EDIT: (context) => PresetEditWidget(this),
      NavRoutes.PRESET_PARAGRAPH_EDIT: (context) => PresetParagraphSortWidget(this),


      NavRoutes.RECEPTION_LIST: (context) => ReceptionListWidget(this, (){}),

      NavRoutes.LAYOUT_LIST: (context) => LayoutListWidget(this),
      NavRoutes.LAYOUT_PREVIEW: (context) => LayoutPreviewWidget(this),
      NavRoutes.LAYOUT_EDIT: (context) => LayoutEditWidget(this),

      NavRoutes.SETTINGS: (context) => SettingsWidget(this),
      NavRoutes.WORDING: (context) => WordingSettingsWidget(this),
    };
  }
}