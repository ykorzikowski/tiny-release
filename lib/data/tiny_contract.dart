
import 'package:tiny_release/data/tiny_dbo.dart';

class TinyContract extends TinyDBO {
  int presetId, photographerId, modelId, parentId, witnessId;
  List<TinySetting> settings;

  TinyContract( {id, displayName, this.presetId, this.photographerId, this.modelId, this.parentId, this.witnessId, this.settings} ) : super(id: id, displayName: displayName);

  TinyContract.fromMap(Map<String, dynamic> m) {
    id = m["id"];
    displayName = m["displayName"];
    presetId = m["presetId"];
    photographerId = m["photographerId"];
    modelId = m["modelId"];
    parentId = m["parentId"];
    witnessId = m["witnessId"];
    settings = (m["settings"] as Iterable)
        ?.map((m) => TinySetting.fromMap(m))?.toList();
  }

  static Map<String, dynamic> toMap(TinyContract tinyContract) {
    var settings = List();
    for (TinySetting ts in tinyContract.settings ?? []) {
      settings.add(TinySetting.toMap(ts));
    }

    return {
      "id": tinyContract.id,
      "displayName": tinyContract.displayName,
      "presetId": tinyContract.presetId,
      "photographerId": tinyContract.photographerId,
      "modelId": tinyContract.modelId,
      "parentId": tinyContract.parentId,
      "witnessId": tinyContract.witnessId,
      "settings": settings,
    };
  }

  Map<String, String> settingsToMap( List<TinySetting> settings ) {
    var map = Map();

    for (var value in settings) {
      map[value.key] = value.value;
    }

    return map;
  }

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