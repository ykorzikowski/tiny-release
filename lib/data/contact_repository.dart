import 'package:sqflite/sqflite.dart';
import 'package:contacts_service/contacts_service.dart';

class ContactRepository {
  void saveContact( Contact contact, String type ) {

  }

  Future<List<Contact>> getContacts( String type, int offset, int limit ) async {
    return getContactsSync(type, limit);
  }

  List<Contact> getContactsSync( String type, int index ) {
    var contact = new Contact();
    contact.displayName = type + " Foo Bar";

    return [contact,contact,contact,contact,contact,contact,contact,contact,contact];
  }
}