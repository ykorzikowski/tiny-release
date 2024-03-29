import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:paperflavor/data/tiny_contract.dart';
import 'package:paperflavor/data/tiny_dbo.dart';
import 'package:paperflavor/data/tiny_people.dart';
import 'package:paperflavor/data/tiny_preset.dart';
import 'package:paperflavor/data/tiny_reception.dart';
import 'package:paperflavor/screens/contract/contract_edit.dart';
import 'package:paperflavor/screens/contract/contract_generated.dart';
import 'package:paperflavor/screens/contract/contract_list.dart';
import 'package:paperflavor/screens/contract/contract_master.dart';
import 'package:paperflavor/screens/contract/contract_preview.dart';
import 'package:paperflavor/screens/control/control_master.dart';
import 'package:paperflavor/screens/subscription/subscription.dart';
import 'package:paperflavor/screens/people/people_edit.dart';
import 'package:paperflavor/screens/people/people_import_callback.dart';
import 'package:paperflavor/screens/people/people_list.dart';
import 'package:paperflavor/screens/people/people_list_callback.dart';
import 'package:paperflavor/screens/people/people_preview.dart';
import 'package:paperflavor/screens/preset/preset_edit.dart';
import 'package:paperflavor/screens/preset/preset_edit_sort.dart';
import 'package:paperflavor/screens/preset/preset_list.dart';
import 'package:paperflavor/screens/preset/preset_preview.dart';
import 'package:paperflavor/screens/reception_area/reception_list.dart';
import 'package:paperflavor/screens/settings.dart';
import 'package:paperflavor/util/nav_routes.dart';

class TinyState {

  Function tinyEditCallback;
  Function contractPreviewCallback;

  /// callbacks for people widgets
  PeopleImportCallback peopleImportCallback;
  PeopleListCallback peopleListCallback;

  /// map that stores the routes of the app
  Map<String, WidgetBuilder> routes;

  /// the selected control item
  int selectedControlItem = 0;

  /// the current selected data item
  TinyPeople currentlyShownPeople;

  TinyPreset currentlyShownPreset;

  TinyReception currentlyShownReception;

  TinyContract currentlyShownContract;

  /// returns if user is currently in control widget
  bool inControlWidget = false;

  TinyState() {
    this.peopleImportCallback = PeopleImportCallback(this);
    this.peopleListCallback = PeopleListCallback(this);
    this.routes = {
      NavRoutes.CONTRACT_MASTER: (context) => ContractMasterWidget(this),
      NavRoutes.CONTRACT_LIST: (context) => ContractListWidget(tinyState: this),
      NavRoutes.CONTRACT_EDIT: (context) => ContractEditWidget(tinyState: this),
      NavRoutes.CONTRACT_PREVIEW: (context) => ContractPreviewWidget(this),
      NavRoutes.CONTRACT_GENERATED: (context) => ContractGeneratedWidget(this),

      NavRoutes.CONTROL_LIST: (context) => MasterControlWidget(this),
      /// PEOPLE ROUTE
      NavRoutes.PEOPLE_LIST: (context) => PeopleListWidget(this, peopleListCallback.getPeople, peopleListCallback.onPeopleTap),
      NavRoutes.PEOPLE_IMPORT: (context) => PeopleListWidget(this, peopleImportCallback.getPeople, peopleImportCallback.onPeopleTap, isContactImportDialog: false,),
      NavRoutes.PEOPLE_EDIT: (context) => PeopleEditWidget(this),
      NavRoutes.PEOPLE_PREVIEW: (context) => PeoplePreviewWidget(this),

      NavRoutes.PRESET_LIST: (context) =>
          PresetListWidget(
              tinyState: this,
              onPresetTap: (item, context) {
                this.currentlyShownPreset = item;

                Navigator.of(context).pushNamed(NavRoutes.PRESET_PREVIEW);
              }),

      NavRoutes.PRESET_PREVIEW: (context) => PresetPreviewWidget(this),
      NavRoutes.PRESET_EDIT: (context) => PresetEditWidget(this),
      NavRoutes.PRESET_PARAGRAPH_EDIT: (context) => PresetParagraphSortWidget(this),

      NavRoutes.RECEPTION_LIST: (context) => ReceptionListWidget(this, (){}),

      NavRoutes.SETTINGS: (context) => SettingsWidget(this),

      NavRoutes.PAYMENT: (context) => SubscriptionListWidget(),
    };
  }
}
