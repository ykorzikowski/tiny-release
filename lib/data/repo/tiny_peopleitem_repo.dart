import 'package:paperflavor/data/data_types.dart';
import 'package:paperflavor/data/repo/sqlite_provider.dart';
import 'package:paperflavor/data/repo/tiny_repo.dart';
import 'package:paperflavor/data/tiny_people.dart';

class TinyPeopleItemRepo extends TinyRepo< TinyPeopleItem > {

  static const TYPE = TableName.PEOPLE_ITEM;

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
    return res.isNotEmpty ? TinyPeopleItem.fromMap(res.first) : null ;
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
      return _update( item );
    }

    db.insert(TYPE, TinyPeopleItem.toMap( item ) );
  }

  void _update( TinyPeopleItem item ) async {
    final db = await SQLiteProvider.db.database;

    db.update(TYPE, TinyPeopleItem.toMap( item ), where: "id = ?", whereArgs: [item.id] );
  }

  Future<List<TinyPeopleItem>> getAllByTypeAndPeopleId( int peopleId, int type ) async {
    final db = await SQLiteProvider.db.database;

    var res = await db.query(TYPE, where: "peopleId = ? AND type = ?", whereArgs: [peopleId, type]);
    return res.isNotEmpty ? List<TinyPeopleItem>.of( res.toList().map((c) => TinyPeopleItem.fromMap(c))) : List<TinyPeopleItem>();
  }

}
