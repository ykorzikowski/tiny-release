import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:tiny_release/data/tiny_people.dart';
import 'package:tiny_release/screens/people/people_list.dart';
import 'package:tiny_release/util/tiny_state.dart';
import 'package:tiny_release/util/NavRoutes.dart';

class PeopleImportCallback {

  final TinyState _controlState;

  PeopleImportCallback( this._controlState );

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

  /// called by list to get people
  /// getPeople(pageIndex)
  Future<List<TinyPeople>> getPeople(pageIndex) async {
    Iterable<Contact> contacts = await ContactsService.getContacts();

    var start = pageIndex * PeopleListWidget.PAGE_SIZE;
    var end = (pageIndex + 1) * PeopleListWidget.PAGE_SIZE;

    if (contacts.length < end) {
      end = contacts.length;
    }

    var data = contacts.toList();
    data.sort((a, b) =>
        a.familyName.toLowerCase().compareTo(b.familyName.toLowerCase()));

    return data.sublist(start, end)
        .map((value) => mapContactToPeople(value))
        .toList();
  }

  void onPeopleTap(item, context) {
    // keep type id of dbo created before import
    TinyPeople beforeImportDBO = _controlState.curDBO;
    item.type = beforeImportDBO.type;
    _controlState.curDBO = item;

    Navigator.of(context).pushNamed(NavRoutes.PEOPLE_EDIT);
  }
}