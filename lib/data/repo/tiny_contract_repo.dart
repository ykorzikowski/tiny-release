import 'package:tiny_release/data/data_types.dart';
import 'package:tiny_release/data/repo/sqlite_provider.dart';
import 'package:tiny_release/data/repo/tiny_people_repo.dart';
import 'package:tiny_release/data/repo/tiny_preset_repo.dart';
import 'package:tiny_release/data/repo/tiny_repo.dart';
import 'package:tiny_release/data/repo/tiny_signature_repo.dart';
import 'package:tiny_release/data/tiny_contract.dart';
import 'package:tiny_release/data/tiny_signature.dart';

class TinyContractRepo extends TinyRepo< TinyContract > {

  static const TYPE = DataType.CONTRACT;
  final TinyPeopleRepo _tinyPeopleRepo = new TinyPeopleRepo();
  final TinyPresetRepo _tinyPresetRepo = new TinyPresetRepo();
  final TinySignatureRepo _tinySignatureRepo = new TinySignatureRepo();

  Future<TinyContract> _replaceIdWithNested( Map<String, dynamic> dboMap ) async{
    final TinyContract tinyContract = TinyContract.fromMap(dboMap);
    final TinyContractDBO dbo = TinyContractDBO.fromMap(dboMap);

    tinyContract.locked = dbo.locked_ == 1;
    tinyContract.model = await _tinyPeopleRepo.get(dbo.modelId);
    tinyContract.photographer = await _tinyPeopleRepo.get(dbo.photographerId);
    tinyContract.witness = await _tinyPeopleRepo.get(dbo.witnessId);
    tinyContract.parent = await _tinyPeopleRepo.get(dbo.parentId);
    tinyContract.preset = await _tinyPresetRepo.get(dbo.presetId);

    tinyContract.modelSignature = await _tinySignatureRepo.getForContractAndType(dbo.id, SignatureType.SIG_MODEL);
    tinyContract.photographerSignature = await _tinySignatureRepo.getForContractAndType(dbo.id, SignatureType.SIG_PHOTOGRAPHER);
    tinyContract.witnessSignature = await _tinySignatureRepo.getForContractAndType(dbo.id, SignatureType.SIG_WITNESS);
    tinyContract.parentSignature = await _tinySignatureRepo.getForContractAndType(dbo.id, SignatureType.SIG_PARENT);

    return tinyContract;
  }

  TinyContract _saveNestedObjects( TinyContract item ) {
    _tinyPresetRepo.save(item.preset);
    _tinyPeopleRepo.save(item.model);
    _tinyPeopleRepo.save(item.photographer);
    if ( item.witness != null ) _tinyPeopleRepo.save(item.witness);
    if ( item.parent != null ) _tinyPeopleRepo.save(item.parent);

    if( item.modelSignature != null ) {
      _tinySignatureRepo.save(item.modelSignature);
      item.modelSignature.contractId = item.id;
    }

    if( item.photographerSignature != null ) {
      _tinySignatureRepo.save(item.photographerSignature);
      item.photographerSignature.contractId = item.id;
    }

    if( item.parentSignature != null ) {
      _tinySignatureRepo.save(item.parentSignature);
      item.parentSignature.contractId = item.id;
    }

    if( item.witnessSignature != null ) {
      _tinySignatureRepo.save(item.witnessSignature);
      item.witnessSignature.contractId = item.id;
    }

    return item;
  }

  Map<String, dynamic> _replaceNestedWithIds( TinyContract tinyContract) {
    final TinyContractDBO dbo = TinyContractDBO.fromMap(TinyContract.toMap(tinyContract));

    dbo.locked_ = tinyContract.locked ? 1 : 0;
    dbo.modelId = tinyContract.model.id;
    dbo.photographerId = tinyContract.photographer.id;
    dbo.witnessId = tinyContract?.witness?.id;
    dbo.parentId = tinyContract?.parent?.id;
    dbo.presetId = tinyContract.preset.id;

    return TinyContractDBO.toMap(dbo);
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
    return res.isNotEmpty ? (await _replaceIdWithNested(res.first)) : Null ;
  }

  @override
  Future<List<TinyContract>> getAll(int offset, int limit) async {
    final db = await SQLiteProvider.db.database;

    var res = await db.query(TYPE, limit: limit, offset: offset);

    List<TinyContractDBO> list = res.isNotEmpty ? res.map((li) => TinyContractDBO.fromMap(li)).toList() : List();

    var resultList = List<TinyContract>();

    for (var dbo in list) {
      var tinyContract = await _replaceIdWithNested(TinyContractDBO.toMap(dbo));
      resultList.add(tinyContract);
    };

    return resultList;
  }

  @override
  Future save(TinyContract item) async {
    final db = await SQLiteProvider.db.database;

    if ( item.id != null ) {
      return _update( item );
    }

    var contractId = await db.insert(TYPE, _replaceNestedWithIds( item ) );
    item.id = contractId;

    _saveNestedObjects( item );

    return contractId;
  }

  void _update( TinyContract item ) async {
    final db = await SQLiteProvider.db.database;

    db.update(TYPE, _replaceNestedWithIds( _saveNestedObjects( item ) ) , where: "id = ?", whereArgs: [item.id] );
  }

}
