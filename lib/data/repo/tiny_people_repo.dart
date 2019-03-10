import 'package:tiny_release/data/data_types.dart';
import 'package:tiny_release/data/repo/sqlite_provider.dart';
import 'package:tiny_release/data/repo/tiny_address_repo.dart';
import 'package:tiny_release/data/repo/tiny_peopleitem_repo.dart';
import 'package:tiny_release/data/tiny_people.dart';
import 'package:tiny_release/data/repo/tiny_repo.dart';

class TinyPeopleRepo extends TinyRepo< TinyPeople > {

  static const TYPE = TableName.PEOPLE;
  final TinyPeopleItemRepo tinyPeopleItemRepo = new TinyPeopleItemRepo();
  final TinyAddressRepo tinyAddressRepo = new TinyAddressRepo();


  Future< TinyPeople > get( final int id ) async {
    final db = await SQLiteProvider.db.database;

    var res = await db.query(TYPE, where: "id = ?", whereArgs: [id]);
    TinyPeople tc = res.isNotEmpty ? TinyPeople.fromMap(res.first) : null;

    if ( tc != null ) {
      tc.postalAddresses = await _getAddress(tc.id);
      tc.emails = await _getEmail(tc.id);
      tc.phones = await _getPhone(tc.id);
    }

    return tc ;
  }

  Future<int> getPeopleCount() async{
    final db = await SQLiteProvider.db.database;

    var res = await db.query(TYPE, columns: ['id']);

    return res.length;
  }

  @override
  Future<List<TinyPeople>> getAll(int offset, int limit) async{
    final db = await SQLiteProvider.db.database;

    var res = await db.query(TYPE, limit: limit, offset: offset);
    var list = res.isNotEmpty ? List.of( res.map((c) => TinyPeople.fromMap(c)) ) : List<TinyPeople>();

    for( var tc in list ) {
      tc.postalAddresses = await _getAddress(tc.id);
      tc.emails = await _getEmail(tc.id);
      tc.phones = await _getPhone(tc.id);
    }

    return list;
  }

  @override
  Future save(TinyPeople item) async {
    final db = await SQLiteProvider.db.database;

    if ( item.id != null ) {
      return _update( item );
    }

    var map = TinyPeople.toMap( item );
    map.remove('phones');
    map.remove('emails');
    map.remove('postalAddresses');
    var peopleId = await db.insert(TYPE, map );

    _putAddress(item.postalAddresses, peopleId);
    _putEmail(item.emails, peopleId);
    _putPhone(item.phones, peopleId);

    return peopleId;
  }

  void _update( TinyPeople item ) async {
    final db = await SQLiteProvider.db.database;

    var map = TinyPeople.toMap( item );
    map.remove('phones');
    map.remove('emails');
    map.remove('postalAddresses');

    _putAddress(item.postalAddresses, item.id);
    _putEmail(item.emails, item.id);
    _putPhone(item.phones, item.id);

    db.update(TYPE, map, where: "id = ?", whereArgs: [item.id] );
  }

  @override
  Future delete(TinyPeople item) async {
    final db = await SQLiteProvider.db.database;

    item.postalAddresses.forEach((i) => tinyAddressRepo.delete(i));
    item.emails.forEach((i) => tinyPeopleItemRepo.delete(i));
    item.phones.forEach((i) => tinyPeopleItemRepo.delete(i));

    var res = await db.delete(TYPE, where: "id = ?", whereArgs: [item.id]);

    return res;
  }

  Future _putEmail( var emails, int peopleId ) async {
    for (TinyPeopleItem value in emails) {
      value.type = TinyPeopleItem.TYPE_EMAIL;
      value.peopleId = peopleId;
      await tinyPeopleItemRepo.save(value);
    }
  }

  Future _putAddress( var addresses, int peopleId  ) async {
    for (TinyAddress value in addresses) {
      value.peopleId = peopleId;
      await tinyAddressRepo.save(value);
    }
  }

  Future _putPhone(var phones, int peopleId ) async {
    for (TinyPeopleItem value in phones) {
      value.type = TinyPeopleItem.TYPE_PHONE;
      value.peopleId = peopleId;
      await tinyPeopleItemRepo.save(value);
    }
  }

  Future _getEmail( int peopleId ) {
    return tinyPeopleItemRepo.getAllByTypeAndPeopleId(peopleId, TinyPeopleItem.TYPE_EMAIL);
  }

  Future _getAddress( int peopleId ) {
    return tinyAddressRepo.getAllByPeopleId(peopleId);
  }

  Future _getPhone( int peopleId ) {
    return tinyPeopleItemRepo.getAllByTypeAndPeopleId(peopleId, TinyPeopleItem.TYPE_PHONE);
  }
}