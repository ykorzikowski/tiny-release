import 'package:tiny_release/data/data_types.dart';
import 'package:tiny_release/data/repo/sqlite_provider.dart';
import 'package:tiny_release/data/repo/tiny_people_repo.dart';
import 'package:tiny_release/data/repo/tiny_preset_repo.dart';
import 'package:tiny_release/data/repo/tiny_repo.dart';
import 'package:tiny_release/data/tiny_contract.dart';

class TinyContractRepo extends TinyRepo< TinyContract > {

  static const TYPE = DataType.CONTRACT;
  final TinyPeopleRepo _tinyPeopleRepo = new TinyPeopleRepo();
  final TinyPresetRepo _tinyPresetRepo = new TinyPresetRepo();


  Future< Map<String, dynamic> > _replaceIdWithNested( Map<String, dynamic> map ) async{
    var modelId = map["model"];
    var photographerId = map["photographer"];
    var witnessId = map["witness"];
    var parentId = map["parent"];
    var presetId = map["preset"];

    map["model"] = await _tinyPeopleRepo.get(modelId);
    map["photographer"] = await _tinyPeopleRepo.get(photographerId);
    map["witness"] = await _tinyPeopleRepo.get(witnessId);
    map["parent"] = await _tinyPeopleRepo.get(parentId);
    map["preset"] = await _tinyPeopleRepo.get(presetId);

    return map;
  }

  TinyContract _saveNestedObjects( TinyContract item ) {
    _tinyPresetRepo.save(item.preset);
    _tinyPeopleRepo.save(item.model);
    _tinyPeopleRepo.save(item.photographer);
    _tinyPeopleRepo.save(item.witness);
    _tinyPeopleRepo.save(item.parent);

    return item;
  }

  Map<String, dynamic> _replaceNestedWithIds( Map<String, dynamic> map) {
    map["model"] = map["model"]["id"];
    map["photographer"] = map["photographer"]["id"];
    map["witness"] = map["witness"]["id"];
    map["parent"] = map["parent"]["id"];
    map["preset"] = map["preset"]["id"];

    return map;
  }


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
    return res.isNotEmpty ? TinyContract.fromMap(await _replaceIdWithNested(res.first)) : Null ;
  }

  @override
  Future<List<TinyContract>> getAll(int offset, int limit) async {
    final db = await SQLiteProvider.db.database;

    var res = await db.query(TYPE, limit: limit, offset: offset);
    var list = res.isNotEmpty ? res.map((c) async => TinyContract.fromMap(await _replaceIdWithNested(c))) : List<TinyContract>();

    return List.of(list);
  }

  @override
  Future save(TinyContract item) async {
    final db = await SQLiteProvider.db.database;

    if ( item.id != null ) {
      return _update( item );
    }

    return db.insert(TYPE, _replaceNestedWithIds( TinyContract.toMap( _saveNestedObjects( item ) ) ) );
  }

  void _update( TinyContract item ) async {
    final db = await SQLiteProvider.db.database;

    db.update(TYPE, _replaceNestedWithIds( _replaceNestedWithIds( TinyContract.toMap( _saveNestedObjects( item ) ) ) ) , where: "id = ?", whereArgs: [item.id] );
  }

}
