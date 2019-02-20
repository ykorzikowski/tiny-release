import 'dart:async';

import 'package:tiny_release/data/data_types.dart';
import 'package:tiny_release/data/repo/sqlite_provider.dart';
import 'package:tiny_release/data/tiny_reception.dart';
import 'package:tiny_release/data/repo/tiny_repo.dart';

class TinyReceptionRepo extends TinyRepo< TinyReception >{

  static const TYPE = DataType.RECEPTION;

  @override
  Future save( TinyReception item ) async {
    final db = await SQLiteProvider.db.database;

    if ( item.id != null ) {
       return _update( item );
    }

    return db.insert(TYPE, TinyReception.toMap( item ) );
  }

  void _update( TinyReception item ) async {
    final db = await SQLiteProvider.db.database;

    db.update(TYPE, TinyReception.toMap( item ) , where: "id = ?", whereArgs: [item.id] );
  }

  @override
  Future<List<TinyReception>> getAll( int offset, int limit ) async {
    final db = await SQLiteProvider.db.database;

    var res = await db.query(TYPE, limit: limit, offset: offset);
    var list = res.isNotEmpty ? res.map((c) => TinyReception.fromMap(c)) : List<TinyReception>();

    return List.of(list);
  }

  @override
  Future< TinyReception > get(int id) async {
    final db = await SQLiteProvider.db.database;

    var res = await  db.query(TYPE, where: "id = ?", whereArgs: [id]);
    return res.isNotEmpty ? TinyReception.fromMap(res.first) : Null ;
  }

  @override
  Future delete(TinyReception item) async {
    final db = await SQLiteProvider.db.database;

    var res = await db.delete(TYPE, where: "id = ?", whereArgs: [item.id]);

    return res;
  }

}