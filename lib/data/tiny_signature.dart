import 'package:tiny_release/data/tiny_dbo.dart';

class TinySignature extends TinyDBO {
  String path;
  int type, contractId;

  TinySignature( {id, displayName, this.path, this.type, this.contractId} ) : super(id: id, displayName: displayName);

  TinySignature.fromMap(Map<String, dynamic> m) {
    id = m["id"];
    path = m["path"];
    type = m["type"];
    contractId = m["contractId"];
  }

  static Map<String, dynamic> toMap(TinySignature tinySignature) {
    return {
      "id": tinySignature.id,
      "path": tinySignature.path,
      "type": tinySignature.type,
      "contractId": tinySignature.contractId,
    };
  }

}

class SignatureType {
  static const SIG_MODEL = 0;
  static const SIG_PHOTOGRAPHER = 1;
  static const SIG_WITNESS = 2;
  static const SIG_PARENT = 3;

}