import 'dart:async';

import 'package:paperflavor/data/data_types.dart';
import 'package:paperflavor/data/repo/sqlite_provider.dart';
import 'package:paperflavor/data/tiny_reception.dart';
import 'package:paperflavor/data/repo/tiny_repo.dart';

class TinyReceptionRepo extends TinyRepo< TinyReception >{

  static const TYPE = TableName.RECEPTION;

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

  Future<List<TinyReception>> getReceptionsForContract(int id) async {
    final db = await SQLiteProvider.db.database;

    var res = await db.query(TableName.RECEPTION_TO_CONTRACT, where: "contractId = ?", whereArgs: [id]);

    List<TinyReception> list = List();
    for (var value in res) {
      list.add(await get(Reception2ContractRel.fromMap(value).receptionId));
    }

    return list;
  }

  /// returns true if presetId is linked to any contract
  Future<bool> receptionInContract(int receptionId) async {
    final db = await SQLiteProvider.db.database;

    var res = await db.query(TableName.RECEPTION_TO_CONTRACT, columns: ['id'], where: "receptionId = ?", whereArgs: [receptionId]);
    return res.isEmpty;
  }

  @override
  Future< TinyReception > get(int id) async {
    final db = await SQLiteProvider.db.database;

    var res = await  db.query(TYPE, where: "id = ?", whereArgs: [id]);
    return res.isNotEmpty ? TinyReception.fromMap(res.first) : null ;
  }

  @override
  Future delete(TinyReception item) async {
    final db = await SQLiteProvider.db.database;

    var res = await db.delete(TYPE, where: "id = ?", whereArgs: [item.id]);

    return res;
  }

}
