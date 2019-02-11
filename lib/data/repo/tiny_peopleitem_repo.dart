import 'package:tiny_release/data/data_types.dart';
import 'package:tiny_release/data/repo/sqlite_provider.dart';
import 'package:tiny_release/data/repo/tiny_repo.dart';
import 'package:tiny_release/data/tiny_people.dart';

class TinyPeopleItemRepo extends TinyRepo< TinyPeopleItem > {

  static const TYPE = DataType.PEOPLE_ITEM;

  @override
  Future delete(TinyPeopleItem item) async {
    final db = await SQLiteProvider.db.database;

    var res = await db.delete(TYPE, where: "id = ?", whereArgs: [item.id]);

    return res;
  }

  @override
  Future<TinyPeopleItem> get(int id) async {
    final db = await SQLiteProvider.db.database;

    var res = await db.query(TYPE, where: "id = ?", whereArgs: [id]);
    return res.isNotEmpty ? TinyPeopleItem.fromMap(res.first) : Null ;
  }

  @override
  Future<List<TinyPeopleItem>> getAll(int offset, int limit) async {
    final db = await SQLiteProvider.db.database;

    var res = await db.query(TYPE, limit: limit, offset: offset);
    return res.isNotEmpty ? List.of( res.toList().map((c) => TinyPeopleItem.fromMap(c))) : List();
  }

  @override
  Future save(TinyPeopleItem item) async {
    final db = await SQLiteProvider.db.database;

    if ( item.id != null ) {
      return update( item );
    }

    db.insert(TYPE, TinyPeopleItem.toMap( item ) );
  }

  void update( TinyPeopleItem item ) async {
    final db = await SQLiteProvider.db.database;

    db.update(TYPE, TinyPeopleItem.toMap( item ) );
  }

  Future<List<TinyPeopleItem>> getAllByTypeAndPeopleId( int peopleId, int type ) async {
    final db = await SQLiteProvider.db.database;

    var res = await db.query(TYPE, where: "peopleId = ? AND type = ?", whereArgs: [peopleId, type]);
    return res.isNotEmpty ? List<TinyPeopleItem>.of( res.toList().map((c) => TinyPeopleItem.fromMap(c))) : List<TinyPeopleItem>();
  }

}