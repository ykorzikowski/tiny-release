import 'package:tiny_release/data/data_types.dart';
import 'package:tiny_release/data/repo/sqlite_provider.dart';
import 'package:tiny_release/data/tiny_contact.dart';
import 'package:tiny_release/data/repo/tiny_repo.dart';

class TinyContactRepo extends TinyRepo< TinyContact > {

  static const TYPE = DataType.PEOPLE;


  Future< TinyContact > get( final int id ) async {
    final db = await SQLiteProvider.db.database;

    var res = await db.query(TYPE, where: "id = ?", whereArgs: [id]);
    return res.isNotEmpty ? TinyContact.fromMap(res.first) : Null ;
  }

  @override
  Future<List<TinyContact>> getAll(int offset, int limit) async{
    final db = await SQLiteProvider.db.database;

    var res = await db.query(TYPE, limit: limit, offset: offset);
    var list = res.isNotEmpty ? res.map((c) => TinyContact.fromMap(c)) : List<TinyContact>();

    return List.of(list);
  }

  Future<List<TinyContact>> getAllByType(String type, int offset, int limit) async{
    final db = await SQLiteProvider.db.database;

    var res = await db.query(TYPE, where: "type = ?", whereArgs: [type], limit: limit, offset: offset);
    var list = res.isNotEmpty ? res.map((c) => TinyContact.fromMap(c)) : List<TinyContact>();

    return List.of(list);
  }

  @override
  Future save(TinyContact item) async {
    final db = await SQLiteProvider.db.database;

    if ( item.id != null ) {
      update( item );
    }

    return db.insert(TYPE, TinyContact.toMap( item ) );
  }

  void update( TinyContact item ) async {
    final db = await SQLiteProvider.db.database;

    db.update(TYPE, TinyContact.toMap( item ) );
  }

  @override
  Future delete(TinyContact item) async {
    final db = await SQLiteProvider.db.database;

    var res = await db.delete(TYPE, where: "id = ?", whereArgs: [item.id]);

    return res;
  }
}