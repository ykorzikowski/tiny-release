import 'package:tiny_release/data/data_types.dart';
import 'package:tiny_release/data/repo/sqlite_provider.dart';
import 'package:tiny_release/data/repo/tiny_repo.dart';
import 'package:tiny_release/data/tiny_signature.dart';

class TinySignatureRepo extends TinyRepo<TinySignature> {

  static const TYPE = DataType.SIGNATURE;

  @override
  Future delete(TinySignature item) async {
    final db = await SQLiteProvider.db.database;

    var res = await db.delete(TYPE, where: "id = ?", whereArgs: [item.id]);

    return res;
  }

  @override
  Future<TinySignature> get(int id) async {
    final db = await SQLiteProvider.db.database;

    var res = await  db.query(TYPE, where: "id = ?", whereArgs: [id]);
    return res.isNotEmpty ? TinySignature.fromMap(res.first) : Null ;
  }

  Future<TinySignature> getForContractAndType(int contractId, int type) async {
    final db = await SQLiteProvider.db.database;

    var res = await  db.query(TYPE, where: "contractId = ? AND type = ?", whereArgs: [contractId, type]);
    return res.isNotEmpty ? TinySignature.fromMap(res.first) : null ;
  }

  @override
  Future<List<TinySignature>> getAll(int offset, int limit) async {
    final db = await SQLiteProvider.db.database;

    var res = await db.query(TYPE, limit: limit, offset: offset);
    var list = res.isNotEmpty ? res.map((c) => TinySignature.fromMap(c)) : List<TinySignature>();

    return List.of(list);
  }

  @override
  Future save(TinySignature item) async {
    final db = await SQLiteProvider.db.database;

    if ( item.id != null ) {
      return _update( item );
    }

    return db.insert(TYPE, TinySignature.toMap( item ) );
  }


  void _update( TinySignature item ) async {
    final db = await SQLiteProvider.db.database;

    db.update(TYPE, TinySignature.toMap( item ) , where: "id = ?", whereArgs: [item.id] );
  }


}