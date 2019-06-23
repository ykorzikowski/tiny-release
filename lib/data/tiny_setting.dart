import 'package:paperflavor/data/tiny_dbo.dart';

class TinySettingKey{
  static const MODEL_LABEL = "model_name";
  static const PHOTOGRAPHER_LABEL = "photographer_name";
}

class TinySetting extends TinyDBO {
  String key, value;

  TinySetting( {id, displayName, this.key, this.value} ) : super(id: id, displayName: displayName);

  TinySetting.fromMap(Map<String, dynamic> m) {
    id = m["id"];
    displayName = m["displayName"];
    key = m["key"];
    value = m["value"];
  }

  static Map<String, dynamic> toMap(TinySetting tinySetting) {
    return {
      "id": tinySetting.id,
      "displayName": tinySetting.displayName,
      "key": tinySetting.key,
      "value": tinySetting.value,
    };
  }

}
