import 'package:tiny_release/data/data_types.dart';
import 'package:tiny_release/data/repo/sqlite_provider.dart';
import 'package:tiny_release/data/repo/tiny_repo.dart';
import 'package:tiny_release/data/tiny_people.dart';

class TinyAddressRepo extends TinyRepo< TinyAddress > {

  static const TYPE = DataType.PEOPLE_ADDRESS;

  @override
  Future delete(TinyAddress item) async {
    final db = await SQLiteProvider.db.database;

    var res = await db.delete(TYPE, where: "id = ?", whereArgs: [item.id]);

    return res;
  }

  @override
  Future<TinyAddress> get(int id) async {
    final db = await SQLiteProvider.db.database;

    var res = await db.query(TYPE, where: "id = ?", whereArgs: [id]);
    return res.isNotEmpty ? TinyAddress.fromMap(res.first) : Null ;
  }

  @override
  Future<List<TinyAddress>> getAll(int offset, int limit) async {
    final db = await SQLiteProvider.db.database;

    var res = await db.query(TYPE, limit: limit, offset: offset);
    return res.isNotEmpty ? List<TinyAddress>.of( res.toList().map((c) => TinyAddress.fromMap(c))) : List<TinyAddress>();
  }

  @override
  Future save(TinyAddress item) async {
    final db = await SQLiteProvider.db.database;

    if ( item.id != null ) {
      return update( item );
    }

    db.insert(TYPE, TinyAddress.toMap( item ) );
  }

  void update( TinyAddress item ) async {
    final db = await SQLiteProvider.db.database;

    db.update(TYPE, TinyAddress.toMap( item ), where: "id = ?", whereArgs: [item.id] );
  }

  Future<List<TinyAddress>> getAllByPeopleId( int peopleId ) async {
    final db = await SQLiteProvider.db.database;

    var res = await db.query(TYPE, where: "peopleId = ?", whereArgs: [peopleId]);
    return res.isNotEmpty ? List.of( res.toList().map((c) => TinyAddress.fromMap(c))) : List<TinyAddress>();
  }

}