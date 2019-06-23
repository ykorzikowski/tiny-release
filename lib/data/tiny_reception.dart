import 'package:paperflavor/data/tiny_dbo.dart';

class TinyReception extends TinyDBO {

  TinyReception({id, displayName}) : super(id: id, displayName: displayName);

  TinyReception.fromMap(Map<String, dynamic> m) {
    id = m["id"];
    displayName = m["displayName"];
  }

  static Map<String, dynamic> toMap(TinyReception i) => {"id": i.id, "displayName": i.displayName};

}

class Reception2ContractRel extends TinyDBO {
  int contractId, receptionId;

  Reception2ContractRel.fromMap(Map<String, dynamic> m) {
    id = m["id"];
    contractId = m["contractId"];
    receptionId = m["receptionId"];
  }

  static Map<String, dynamic> toMap(Reception2ContractRel i) => {"id": i.id, "contractId": i.contractId, "receptionId": i.receptionId};
}
