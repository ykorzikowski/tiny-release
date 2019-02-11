import 'package:tiny_release/data/data_types.dart';
import 'package:tiny_release/data/repo/sqlite_provider.dart';
import 'package:tiny_release/data/tiny_layout.dart';
import 'package:tiny_release/data/repo/tiny_repo.dart';

class TinyLayoutRepo extends TinyRepo< TinyLayout >{

  static const TYPE = DataType.LAYOUT;

  @override
  Future save( TinyLayout item ) async {
    final db = await SQLiteProvider.db.database;

    if ( item.id != null ) {
      update( item );
    }

    return db.insert(TYPE, TinyLayout.toMap( item ) );
  }

  void update( TinyLayout item ) async {
    final db = await SQLiteProvider.db.database;

    db.update(TYPE, TinyLayout.toMap( item ) );
  }


  @override
  Future<List<TinyLayout>> getAll( int offset, int limit ) async {
    final db = await SQLiteProvider.db.database;

    var res = await db.query(TYPE, limit: limit, offset: offset);
    var list = res.isNotEmpty ? res.map((c) => TinyLayout.fromMap(c)) : List<TinyLayout>();

    return List.of(list);
  }

  @override
  Future< TinyLayout > get(int id) async {
    final db = await SQLiteProvider.db.database;

    var res = await  db.query(TYPE, where: "id = ?", whereArgs: [id]);
    return res.isNotEmpty ? TinyLayout.fromMap(res.first) : Null ;
  }

  @override
  Future delete(TinyLayout item) async {
    final db = await SQLiteProvider.db.database;

    var res = await db.delete(TYPE, where: "id = ?", whereArgs: [item.id]);

    return res;
  }

}