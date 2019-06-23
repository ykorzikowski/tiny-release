
import 'package:paperflavor/data/tiny_dbo.dart';

class TinyPeople extends TinyDBO {
  String identifier,
      givenName = "",
      middleName,
      prefix,
      suffix,
      familyName = "",
      birthday,
      company,
      jobTitle,
      idType,
      idNumber;
  int type;
  List<TinyPeopleItem> emails = List();
  List<TinyPeopleItem> phones = List();
  List<TinyAddress> postalAddresses = List();
  String avatar;

  TinyPeople({id, displayName, this.identifier, this.givenName, this.middleName, this.prefix,
    this.suffix, this.familyName, this.birthday, this.company, this.jobTitle, this.idNumber, this.idType, this.emails, this.phones,
  this.postalAddresses, this.avatar} ) : super(id: id, displayName: displayName);

  static TinyPeople factory() {
    var _tinyPeople = TinyPeople();

    _tinyPeople.emails = List();
    _tinyPeople.postalAddresses = List();
    _tinyPeople.phones = List();

    return _tinyPeople;
  }

  @override
  String get displayName => this.givenName + " " + this.familyName;

  TinyPeople.fromMap(Map<String, dynamic> m) {
    id = m["id"];
    identifier = m["identifier"];
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
    emails = (m["emails"] as Iterable)?.map((m) => TinyPeopleItem.fromMap(m))?.toList();
    phones = (m["phones"] as Iterable)?.map((m) => TinyPeopleItem.fromMap(m))?.toList();
    postalAddresses = (m["postalAddresses"] as Iterable)
        ?.map((m) => TinyAddress.fromMap(m))?.toList();
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
      "identifier": contact.identifier,
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

class TinyPeopleDBO extends TinyDBO {
  String identifier,
      givenName = "",
      middleName,
      prefix,
      suffix,
      familyName = "",
      birthday,
      company,
      jobTitle,
      idType,
      idNumber;
  int type;
  String avatar;

  TinyPeopleDBO({id, displayName, this.identifier, this.givenName, this.middleName, this.prefix,
    this.suffix, this.familyName, this.birthday, this.company, this.jobTitle, this.idNumber, this.idType, this.avatar} );

  TinyPeopleDBO.fromMap(Map<String, dynamic> m) {
    id = m["id"];
    identifier = m["identifier"];
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
    avatar = m["avatar"];
  }

  static Map<String, dynamic> toMap(TinyPeopleDBO contact) {
    return {
      "id": contact.id,
      "identifier": contact.identifier,
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

  static Map<String, dynamic> toMap(TinyPeopleItem i) => {"id": i.id,"type": i.type, "peopleId": i.peopleId, "label": i.label, "value": i.value};

  TinyPeopleItem.fromMap(Map<String, dynamic> m) {
    id = m["id"];
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
    id = m["id"];
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
        "id": address.id,
        "peopleId": address.peopleId,
        "label": address.label,
        "street": address.street,
        "city": address.city,
        "postcode": address.postcode,
        "region": address.region,
        "country": address.country
      };
}
