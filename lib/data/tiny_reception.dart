import 'package:tiny_release/data/tiny_dbo.dart';

class TinyReception extends TinyDBO {

  TinyReception({id, displayName}) : super(id: id, displayName: displayName);

  TinyReception.fromMap(Map<String, dynamic> m) {
    id = m["id"];
    displayName = m["displayName"];
  }

  static Map<String, dynamic> toMap(TinyReception i) => {"id": i.id, "displayName": i.displayName};

}