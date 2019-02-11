import 'package:tiny_release/data/data_types.dart';
import 'package:tiny_release/data/repo/sqlite_provider.dart';
import 'package:tiny_release/data/tiny_preset.dart';
import 'package:tiny_release/data/repo/tiny_repo.dart';

class TinyPresetRepo extends TinyRepo< TinyPreset >{

  static const TYPE = DataType.PRESET;

  @override
  Future save( TinyPreset item ) async {
    final db = await SQLiteProvider.db.database;

    if ( item.id != null ) {
      return update( item );
    }

    db.insert(TYPE, TinyPreset.toMap( item ) );
  }

  void update( TinyPreset item ) async {
    final db = await SQLiteProvider.db.database;

    db.update(TYPE, TinyPreset.toMap( item ) );
  }

  @override
  Future<List<TinyPreset>> getAll( String type, int offset, int limit ) async {
    final db = await SQLiteProvider.db.database;

    var res = await db.query(TYPE, limit: limit, offset: offset);
    List<TinyPreset> list = res.isNotEmpty ? res.toList().map((c) => TinyPreset.fromMap(c)) : List();
    return list;
  }

  @override
  Future< TinyPreset > get(int id) async {
    final db = await SQLiteProvider.db.database;

    var res = await db.query(TYPE, where: "id = ?", whereArgs: [id]);
    return res.isNotEmpty ? TinyPreset.fromMap(res.first) : Null ;
  }

  @override
  Future delete(TinyPreset item) async {
      final db = await SQLiteProvider.db.database;

      var res = await db.delete(TYPE, where: "id = ?", whereArgs: [item.id]);

      return res;
  }

}