import 'dart:typed_data';

import 'package:tiny_release/data/tiny_dbo.dart';

class TinyContact extends TinyDBO {
  String type,
      identifier,
      givenName,
      middleName,
      prefix,
      suffix,
      familyName,
      company,
      jobTitle;
  Iterable<Item> emails = [];
  Iterable<Item> phones = [];
  Iterable<PostalAddress> postalAddresses = [];
  Uint8List avatar;

  TinyContact({id, displayName, this.type, this.identifier, this.givenName, this.middleName, this.prefix,
    this.suffix, this.familyName, this.company, this.jobTitle, this.emails, this.phones,
  this.postalAddresses, this.avatar} );


  TinyContact.fromMap(Map m) {
    id = m["id"];
    identifier = m["identifier"];
    displayName = m["displayName"];
    givenName = m["givenName"];
    middleName = m["middleName"];
    familyName = m["familyName"];
    prefix = m["prefix"];
    suffix = m["suffix"];
    company = m["company"];
    jobTitle = m["jobTitle"];
    emails = (m["emails"] as Iterable)?.map((m) => Item.fromMap(m));
    phones = (m["phones"] as Iterable)?.map((m) => Item.fromMap(m));
    postalAddresses = (m["postalAddresses"] as Iterable)
        ?.map((m) => PostalAddress.fromMap(m));
    avatar = m["avatar"];
  }

  static Map toMap(TinyContact contact) {
    var emails = [];
    for (Item email in contact.emails ?? []) {
      emails.add(Item._toMap(email));
    }
    var phones = [];
    for (Item phone in contact.phones ?? []) {
      phones.add(Item._toMap(phone));
    }
    var postalAddresses = [];
    for (PostalAddress address in contact.postalAddresses ?? []) {
      postalAddresses.add(PostalAddress._toMap(address));
    }
    return {
      "id": contact.id,
      "identifier": contact.identifier,
      "displayName": contact.displayName,
      "givenName": contact.givenName,
      "middleName": contact.middleName,
      "familyName": contact.familyName,
      "prefix": contact.prefix,
      "suffix": contact.suffix,
      "company": contact.company,
      "jobTitle": contact.jobTitle,
      "emails": emails,
      "phones": phones,
      "postalAddresses": postalAddresses,
      "avatar": contact.avatar
    };
  }
}

class Item extends TinyDBO {
  Item({id, this.label, this.value}) : super(id: id, displayName: "");

  String label, value;

  static Map _toMap(Item i) => {"label": i.label, "value": i.value};

  Item.fromMap(Map m) {
    label = m["label"];
    value = m["value"];
  }

}

class PostalAddress extends TinyDBO{
  PostalAddress({id, this.label,
    this.street,
    this.city,
    this.postcode,
    this.region,
    this.country}) : super(id: id, displayName: "");

  String label, street, city, postcode, region, country;

  PostalAddress.fromMap(Map m) {
    label = m["label"];
    street = m["street"];
    city = m["city"];
    postcode = m["postcode"];
    region = m["region"];
    country = m["country"];
  }

  static Map _toMap(PostalAddress address) =>
      {
        "label": address.label,
        "street": address.street,
        "city": address.city,
        "postcode": address.postcode,
        "region": address.region,
        "country": address.country
      };
}