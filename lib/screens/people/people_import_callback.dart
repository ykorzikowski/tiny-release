import 'dart:io' as Io;
import 'package:path/path.dart';
import 'dart:typed_data';

import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:paperflavor/data/tiny_contract.dart';
import 'package:paperflavor/data/tiny_people.dart';
import 'package:paperflavor/screens/people/people_list.dart';
import 'package:paperflavor/util/base_util.dart';
import 'package:paperflavor/util/tiny_state.dart';
import 'package:path/path.dart' as path;

class PeopleImportCallback {

  final TinyState _controlState;

  PeopleImportCallback( this._controlState );

  static bool isValidImage(Uint8List img) {
    return img != null && img.isNotEmpty;
  }

  static Future<TinyPeople> mapContactToPeople( Contact contact ) async {
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
    tinyPeople.avatar = isValidImage(contact.avatar) ? basename((await BaseUtil.storeTempBlobUint8('people', 'png', contact.avatar)).path) : null;

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

  /// called by list to get people
  /// getPeople(pageIndex)
  Future<List<TinyPeople>> getPeople(pageIndex) async {
    Iterable<Contact> contacts = await ContactsService.getContacts();

    if( contacts == null ) {
      return List();
    }

    var start = pageIndex * PeopleListWidget.PAGE_SIZE;
    var end = (pageIndex + 1) * PeopleListWidget.PAGE_SIZE;

    if (contacts.length < end) {
      end = contacts.length;
    }

    var data = contacts.toList();
    data.sort((a, b) =>
        a.familyName?.toLowerCase()?.compareTo(b.familyName?.toLowerCase()) ?? 0);

    Future<List<TinyPeople>> wait = Future.wait(data.sublist(start, end)
        .map((value) async => mapContactToPeople(value))
        .toList());

    return wait;
  }

  void copyAvatarFromTempToDocuments(item, context) {
    if (item.avatar == null) {
      onAvatarSaved(item, context);
      return;
    }

    BaseUtil.storeFile('people', 'png', BaseUtil.getFileSync(item.avatar))
        .then((file) {
          item.avatar = path.basename(file.path);
          onAvatarSaved(item, context);
        });
  }

  void onAvatarSaved(item, context) {
    _controlState.currentlyShownPeople = item;
    _controlState.tinyEditCallback();

    Navigator.pop(context);
  }

  void onPeopleTap(item, context) {
    // keep type id of dbo created before import
    TinyPeople beforeImportDBO = _controlState.currentlyShownPeople;
    item.type = beforeImportDBO.type;
    onAvatarSaved(item, context);
  }
}
