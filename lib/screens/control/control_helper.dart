import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tiny_release/data/data_types.dart';
import 'package:tiny_release/data/repo/tiny_people_repo.dart';
import 'package:tiny_release/data/tiny_people.dart';
import 'package:tiny_release/data/tiny_dbo.dart';
import 'package:tiny_release/data/tiny_layout.dart';
import 'package:tiny_release/data/tiny_preset.dart';
import 'package:tiny_release/data/tiny_reception.dart';
import 'package:tiny_release/data/repo/tiny_repo.dart';
import 'package:tiny_release/screens/layout/layout_edit.dart';
import 'package:tiny_release/screens/layout/layout_list.dart';
import 'package:tiny_release/screens/people/people_edit.dart';
import 'package:tiny_release/screens/people/people_list.dart';
import 'package:tiny_release/screens/people/people_preview.dart';
import 'package:tiny_release/screens/preset/preset_edit.dart';
import 'package:tiny_release/screens/preset/preset_list.dart';
import 'package:tiny_release/screens/reception_area/reception_edit.dart';
import 'package:tiny_release/screens/reception_area/reception_list.dart';
import 'package:tiny_release/screens/wording/wording_settings.dart';
import 'package:tiny_release/util/BaseUtil.dart';
import 'package:tiny_release/util/ControlState.dart';

class ControlHelper {

  static TinyPeople mapContactToPeople( Contact contact ) {
    var tinyPeople = new TinyPeople();

    tinyPeople.identifier = contact.identifier;
    tinyPeople.givenName = contact.givenName;
    tinyPeople.middleName = contact.middleName;
    tinyPeople.prefix = contact.prefix;
    tinyPeople.suffix = contact.suffix;
    tinyPeople.familyName = contact.familyName;
    tinyPeople.company = contact.company;
    tinyPeople.jobTitle = contact.jobTitle;
    tinyPeople.displayName = contact.displayName;
    tinyPeople.avatar = contact.avatar;

    tinyPeople.emails = contact.emails.map((i) {
      TinyPeopleItem tinyItem = new TinyPeopleItem();
      tinyItem.label = i.label;
      tinyItem.value = i.value;
      return tinyItem;
    }).toList();

    tinyPeople.phones = contact.phones.map((i) {
      TinyPeopleItem tinyItem = new TinyPeopleItem();
      tinyItem.label = i.label;
      tinyItem.value = i.value;
      return tinyItem;
    }).toList();

    tinyPeople.postalAddresses = contact.postalAddresses.map((i) {
      TinyAddress tinyAddress = new TinyAddress();
      tinyAddress.street = i.street;
      tinyAddress.label = i.label;
      tinyAddress.city = i.city;
      tinyAddress.postcode = i.postcode;
      tinyAddress.region = i.region;
      tinyAddress.country = i.country;
      return tinyAddress;
    }).toList();

    return tinyPeople;
  }

  static Future initContactImport( final ControlScreenState controlScreenState, final NavigatorState navigatorState ) async {
    controlScreenState.setToolbarButtonsOnImport();
    navigatorState.push(
       MaterialPageRoute(
          builder: (context) {
            return PeopleListWidget( controlScreenState,
                  (pageIndex) async {
                    Iterable<Contact> contacts = await ContactsService.getContacts();

                    var list = List();
                    contacts.forEach((contact) => list.add( mapContactToPeople(contact) ));

                    return list;
              },
                  (item, context) {
                    controlScreenState.setToolbarButtonsOnEdit();
                    // keep type id of dbo created before import
                    TinyPeople beforeImportDBO = controlScreenState.curDBO;
                    item.type = beforeImportDBO.type;
                    controlScreenState.curDBO = item;

                    Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return PeopleEditWidget(controlScreenState);
                        }
                    ) );
                  }
            );
          }
      ),
    );
  }

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
        var tinyPeople = new TinyPeople();
        tinyPeople.type = controlScreenState.selectedControlItem;
        tinyPeople.displayName = "Han Solo";
        tinyPeople.postalAddresses = List();
        tinyPeople.emails = List();
        tinyPeople.phones = List();
        controlScreenState.curDBO = tinyPeople;
        widget = PeopleEditWidget( controlScreenState );
        break;
      case 4:
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
        controlScreenState.curDBO = tinyPreset;

        widget = PresetEditWidget( controlScreenState );
        break;
      case 5:
        //todo remove when edit window implemented
        var tinyReception = new TinyReception();
        tinyReception.displayName = "tinyRec";

        controlScreenState.curDBO = tinyReception;
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
        return PeopleListWidget(
          controlScreenState,
              (pageIndex) {
                return new TinyPeopleRepo().getAllByType(
                    controlScreenState.selectedControlItem,
                    pageIndex * PeopleListWidget.PAGE_SIZE,
                    PeopleListWidget.PAGE_SIZE);
                },

              (item, context) {
                    controlScreenState.setToolbarButtonsOnPreview();
                    controlScreenState.curDBO = item;

                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return PeoplePreviewWidget(controlScreenState);
                      }
                    ) );
        },

      );
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