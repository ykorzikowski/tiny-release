import 'package:tiny_release/data/data_types.dart';
import 'package:tiny_release/data/repo/sqlite_provider.dart';
import 'package:tiny_release/data/repo/tiny_repo.dart';
import 'package:tiny_release/data/tiny_contract.dart';

class TinySettingsRepo  extends TinyRepo< TinySetting >{

  static const TYPE = DataType.SETTINGS;

  @override
  Future delete(TinySetting item) async {
    final db = await SQLiteProvider.db.database;

    var res = await db.delete(TYPE, where: "id = ?", whereArgs: [item.id]);

    return res;
  }

  @override
  Future<TinySetting> get(int id) async {
    final db = await SQLiteProvider.db.database;

    var res = await  db.query(TYPE, where: "id = ?", whereArgs: [id]);
    return res.isNotEmpty ? TinySetting.fromMap(res.first) : Null ;
  }

  @override
  Future<List<TinySetting>> getAll(int offset, int limit) async {
    final db = await SQLiteProvider.db.database;

    var res = await db.query(TYPE, limit: limit, offset: offset);
    var list = res.isNotEmpty ? res.map((c) => TinySetting.fromMap(c)) : List<TinySetting>();

    return List.of(list);
  }

  Future<List<TinySetting>> getAllForContract(int offset, int limit, int contractId) async {
    final db = await SQLiteProvider.db.database;

    var res = await db.query(TYPE, limit: limit, offset: offset, where: "contractId = ?", whereArgs: [contractId]);
    var list = res.isNotEmpty ? res.map((c) => TinySetting.fromMap(c)) : List<TinySetting>();

    return List.of(list);
  }

  @override
  Future save(TinySetting item) async {
    final db = await SQLiteProvider.db.database;

    if ( item.id != null ) {
      return update( item );
    }

    return db.insert(TYPE, TinySetting.toMap( item ) );

  }

  void update( TinySetting item ) async {
    final db = await SQLiteProvider.db.database;

    db.update(TYPE, TinySetting.toMap( item ) , where: "id = ?", whereArgs: [item.id] );
  }


}