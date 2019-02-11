import 'package:tiny_release/data/tiny_contact.dart';
import 'package:tiny_release/data/repo/tiny_repo.dart';

class TinyContactRepo extends TinyRepo< TinyContact > {

  Future< TinyContact > get( final int id ) {
    // todo load from database
    return Future(() {TinyContact.fromMap(Map());});
  }

  List<TinyContact> getContactsSync( String type, int index ) {
    var contact = new TinyContact();
    contact.displayName = type + " Foo Bar";

    return [contact,contact,contact,contact,contact,contact,contact,contact,contact];
  }

  @override
  Future<List<TinyContact>> getAll(String type, int offset, int limit) async{
    // TODO: implement getAll
    return getContactsSync(type, limit);
  }

  @override
  Future save(TinyContact item) {
    // TODO: implement save
  }

  @override
  Future delete(TinyContact item) {
    // TODO: implement delete
    return null;
  }
}