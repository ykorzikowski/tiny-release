import 'dart:typed_data';

import 'package:tiny_release/data/tiny_dbo.dart';

class TinyPeople extends TinyDBO {
  String identifier,
      givenName,
      middleName,
      prefix,
      suffix,
      familyName,
      birthday,
      company,
      jobTitle,
      idType,
      idNumber;
  int type;
  List<TinyPeopleItem> emails = List();
  List<TinyPeopleItem> phones = List();
  List<TinyAddress> postalAddresses = List();
  Uint8List avatar;

  TinyPeople({id, displayName, this.type, this.identifier, this.givenName, this.middleName, this.prefix,
    this.suffix, this.familyName, this.birthday, this.company, this.jobTitle, this.idNumber, this.idType, this.emails, this.phones,
  this.postalAddresses, this.avatar} );


  TinyPeople.fromMap(Map<String, dynamic> m) {
    id = m["id"];
    type = m["type"];
    identifier = m["identifier"];
    displayName = m["displayName"];
    givenName = m["givenName"];
    middleName = m["middleName"];
    familyName = m["familyName"];
    prefix = m["prefix"];
    suffix = m["suffix"];
    company = m["company"];
    birthday = m["birthday"];
    jobTitle = m["jobTitle"];
    idType = m["idType"];
    idNumber = m["idNumber"];
    emails = (m["emails"] as Iterable)?.map((m) => TinyPeopleItem.fromMap(m));
    phones = (m["phones"] as Iterable)?.map((m) => TinyPeopleItem.fromMap(m));
    postalAddresses = (m["postalAddresses"] as Iterable)
        ?.map((m) => TinyAddress.fromMap(m));
    avatar = m["avatar"];
  }

  static Map<String, dynamic> toMap(TinyPeople contact) {
    var emails = [];
    for (TinyPeopleItem email in contact.emails ?? []) {
      emails.add(TinyPeopleItem.toMap(email));
    }
    var phones = [];
    for (TinyPeopleItem phone in contact.phones ?? []) {
      phones.add(TinyPeopleItem.toMap(phone));
    }
    var postalAddresses = [];
    for (TinyAddress address in contact.postalAddresses ?? []) {
      postalAddresses.add(TinyAddress.toMap(address));
    }
    return {
      "id": contact.id,
      "type": contact.type,
      "identifier": contact.identifier,
      "displayName": contact.displayName,
      "givenName": contact.givenName,
      "middleName": contact.middleName,
      "familyName": contact.familyName,
      "birthday": contact.birthday,
      "prefix": contact.prefix,
      "suffix": contact.suffix,
      "company": contact.company,
      "jobTitle": contact.jobTitle,
      "idNumber": contact.idNumber,
      "idType": contact.idType,
      "emails": emails,
      "phones": phones,
      "postalAddresses": postalAddresses,
      "avatar": contact.avatar
    };
  }
}

class TinyPeopleItem extends TinyDBO {
  TinyPeopleItem({id, this.type, this.peopleId, this.label, this.value}) : super(id: id, displayName: "TinyPeopleItem");

  static const TYPE_EMAIL = 1;
  static const TYPE_PHONE = 2;

  int type, peopleId;
  String label, value;

  static Map<String, dynamic> toMap(TinyPeopleItem i) => {"type": i.type, "peopleId": i.peopleId, "label": i.label, "value": i.value};

  TinyPeopleItem.fromMap(Map<String, dynamic> m) {
    type = m["type"];
    label = m["label"];
    value = m["value"];
    peopleId = m["peopleId"];
  }

}

class TinyAddress extends TinyDBO{
  TinyAddress({id, this.peopleId, this.label,
    this.street,
    this.city,
    this.postcode,
    this.region,
    this.country}) : super(id: id, displayName: "TinyAddress");

  int peopleId;
  String label, street, city, postcode, region, country;

  TinyAddress.fromMap(Map<String, dynamic> m) {
    peopleId = m["peopleId"];
    label = m["label"];
    street = m["street"];
    city = m["city"];
    postcode = m["postcode"];
    region = m["region"];
    country = m["country"];
  }

  static Map<String, dynamic> toMap(TinyAddress address) =>
      {
        "peopleId": address.peopleId,
        "label": address.label,
        "street": address.street,
        "city": address.city,
        "postcode": address.postcode,
        "region": address.region,
        "country": address.country
      };
}