import 'package:tiny_release/data/tiny_dbo.dart';

class TinyLayout extends TinyDBO {

  //todo implement me

  String layout;

  TinyLayout({id, displayName, this.layout}) : super(id: id, displayName: displayName);


  TinyLayout.fromMap(Map m) {
    id = m["id"];
    displayName = m["displayName"];
  }

  static Map toMap(TinyLayout item) {
    return {
      "id": item.id,
      "displayName": item.displayName,
    };
  }

}