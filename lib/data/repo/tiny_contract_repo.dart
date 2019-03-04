import 'package:tiny_release/data/data_types.dart';
import 'package:tiny_release/data/repo/sqlite_provider.dart';
import 'package:tiny_release/data/repo/tiny_address_repo.dart';
import 'package:tiny_release/data/repo/tiny_people_repo.dart';
import 'package:tiny_release/data/repo/tiny_preset_repo.dart';
import 'package:tiny_release/data/repo/tiny_reception_repo.dart';
import 'package:tiny_release/data/repo/tiny_repo.dart';
import 'package:tiny_release/data/repo/tiny_signature_repo.dart';
import 'package:tiny_release/data/tiny_contract.dart';
import 'package:tiny_release/data/tiny_signature.dart';

class TinyContractRepo extends TinyRepo< TinyContract > {

  static const TYPE = TableName.CONTRACT;
  final TinyPeopleRepo _tinyPeopleRepo = new TinyPeopleRepo();
  final TinyPresetRepo _tinyPresetRepo = new TinyPresetRepo();
  final TinySignatureRepo _tinySignatureRepo = new TinySignatureRepo();
  final TinyAddressRepo _tinyAddressRepo = new TinyAddressRepo();
  final TinyReceptionRepo _tinyReceptionRepo = new TinyReceptionRepo();

  Future<TinyContract> _replaceIdWithNested( Map<String, dynamic> dboMap ) async{
    final TinyContract tinyContract = TinyContract.fromMap(dboMap);
    final TinyContractDBO dbo = TinyContractDBO.fromMap(dboMap);

    tinyContract.isLocked = dbo.locked_ == 1;
    tinyContract.model = await _tinyPeopleRepo.get(dbo.modelId);
    tinyContract.photographer = await _tinyPeopleRepo.get(dbo.photographerId);
    tinyContract.witness = await _tinyPeopleRepo.get(dbo.witnessId);
    tinyContract.parent = await _tinyPeopleRepo.get(dbo.parentId);
    tinyContract.preset = await _tinyPresetRepo.get(dbo.presetId);

    /// selected addresses
    if (dbo.selectedPhotographerAddressId != null) tinyContract.selectedPhotographerAddress = await _tinyAddressRepo.get(dbo.selectedPhotographerAddressId);
    if (dbo.selectedModelAddressId != null) tinyContract.selectedModelAddress = await _tinyAddressRepo.get(dbo.selectedModelAddressId);
    if (dbo.selectedWitnessAddressId != null) tinyContract.selectedWitnessAddress = await _tinyAddressRepo.get(dbo.selectedWitnessAddressId);
    if (dbo.selectedParentAddressId != null) tinyContract.selectedParentAddress = await _tinyAddressRepo.get(dbo.selectedParentAddressId);

    /// signatures
    tinyContract.modelSignature = await _tinySignatureRepo.getForContractAndType(dbo.id, SignatureType.SIG_MODEL);
    tinyContract.photographerSignature = await _tinySignatureRepo.getForContractAndType(dbo.id, SignatureType.SIG_PHOTOGRAPHER);
    tinyContract.witnessSignature = await _tinySignatureRepo.getForContractAndType(dbo.id, SignatureType.SIG_WITNESS);
    tinyContract.parentSignature = await _tinySignatureRepo.getForContractAndType(dbo.id, SignatureType.SIG_PARENT);

    /// receptions
    tinyContract.receptions = await _tinyReceptionRepo.getReceptionsForContract(dbo.id);

    return tinyContract;
  }

  TinyContract _saveNestedObjects( TinyContract item ) {
    _tinyPresetRepo.save(item.preset);
    _tinyPeopleRepo.save(item.model);
    _tinyPeopleRepo.save(item.photographer);
    if ( item.witness != null ) _tinyPeopleRepo.save(item.witness);
    if ( item.parent != null ) _tinyPeopleRepo.save(item.parent);

    /// signatures
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

    /// receptions
    if ( item.receptions != null) {
      _removeContract2Reception( item.id );
      item.receptions.forEach((f) => _saveContract2Reception(item.id, f.id));
    }

    return item;
  }

  Future _removeContract2Reception(int contractId) async {
    final db = await SQLiteProvider.db.database;

    return db.delete(TableName.RECEPTION_TO_CONTRACT, where: "contractId = ?", whereArgs: [contractId]);
  }

  Future _saveContract2Reception(int contractId, int receptionId) async {
    final db = await SQLiteProvider.db.database;

    var res = await db.query(TableName.RECEPTION_TO_CONTRACT, where: "contractId = ? AND receptionId = ?", whereArgs: [contractId, receptionId]);

    if (res.isEmpty) {
      return await db.insert(TableName.RECEPTION_TO_CONTRACT, {"contractId": contractId, "receptionId": receptionId} );
    } else {
      return res.first["id"];
    }
  }

  Map<String, dynamic> _replaceNestedWithIds( TinyContract tinyContract) {
    final TinyContractDBO dbo = TinyContractDBO.fromMap(TinyContract.toMap(tinyContract));

    dbo.locked_ = tinyContract.isLocked ? 1 : 0;
    dbo.modelId = tinyContract.model.id;
    dbo.photographerId = tinyContract.photographer.id;
    dbo.witnessId = tinyContract?.witness?.id;
    dbo.parentId = tinyContract?.parent?.id;
    dbo.presetId = tinyContract.preset.id;

    /// selected addresses
    dbo.selectedModelAddressId = tinyContract.selectedModelAddress.id;
    dbo.selectedPhotographerAddressId = tinyContract.selectedPhotographerAddress.id;
    dbo.selectedWitnessAddressId = tinyContract?.selectedWitnessAddress?.id;
    dbo.selectedParentAddressId = tinyContract?.selectedParentAddress?.id;

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
    return res.isNotEmpty ? (await _replaceIdWithNested(res.first)) : null ;
  }

  /// returns true if peopleId is linked to any contract
  Future<bool> personHasNoContracts(int peopleId) async {
    final db = await SQLiteProvider.db.database;

    var res = await db.query(TYPE, columns: ['id'], where: "photographerId = ? OR modelId = ? OR parentId = ? OR witnessId = ?", whereArgs: [peopleId, peopleId, peopleId, peopleId]);
    return res.isEmpty;
  }

  /// returns true if presetId is linked to any contract
  Future<bool> presetHasNoContracts(int presetId) async {
    final db = await SQLiteProvider.db.database;

    var res = await db.query(TYPE, columns: ['id'], where: "presetId = ?", whereArgs: [presetId]);
    return res.isEmpty;
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
    }

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
