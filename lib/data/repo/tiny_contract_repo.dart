import 'package:tiny_release/data/data_types.dart';
import 'package:tiny_release/data/repo/sqlite_provider.dart';
import 'package:tiny_release/data/repo/tiny_repo.dart';
import 'package:tiny_release/data/tiny_contract.dart';

class TinyContractRepo extends TinyRepo< TinyContract > {

  static const TYPE = DataType.CONTRACT;

  @override
  Future delete(TinyContract item) async {
    final db = await SQLiteProvider.db.database;

    var res = await db.delete(TYPE, where: "id = ?", whereArgs: [item.id]);

    return res;
  }

  @override
  Future<TinyContract> get(int id) async {
    final db = await SQLiteProvider.db.database;

    var res = await  db.query(TYPE, where: "id = ?", whereArgs: [id]);
    return res.isNotEmpty ? TinyContract.fromMap(res.first) : Null ;
  }

  @override
  Future<List<TinyContract>> getAll(int offset, int limit) async {
    final db = await SQLiteProvider.db.database;

    var res = await db.query(TYPE, limit: limit, offset: offset);
    var list = res.isNotEmpty ? res.map((c) => TinyContract.fromMap(c)) : List<TinyContract>();

    return List.of(list);
  }

  @override
  Future save(TinyContract item) async {
    final db = await SQLiteProvider.db.database;

    if ( item.id != null ) {
      return update( item );
    }

    return db.insert(TYPE, TinyContract.toMap( item ) );
  }

  void update( TinyContract item ) async {
    final db = await SQLiteProvider.db.database;

    db.update(TYPE, TinyContract.toMap( item ) , where: "id = ?", whereArgs: [item.id] );
  }

}
