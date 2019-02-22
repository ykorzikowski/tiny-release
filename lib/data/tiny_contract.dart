
import 'package:tiny_release/data/tiny_dbo.dart';
import 'package:tiny_release/data/tiny_people.dart';
import 'package:tiny_release/data/tiny_preset.dart';

class TinyContract extends TinyDBO {
  TinyPreset preset;
  TinyPeople model, photographer, parent, witness;
  int imagesCount;
  String location, date;
  List<TinySetting> settings;

  TinyContract( {id, displayName, this.preset, this.photographer, this.model, this.parent, this.witness, this.imagesCount, this.settings, this.location, this.date} ) : super(id: id, displayName: displayName);

  TinyContract.fromMap(Map<String, dynamic> m) {
    id = m["id"];
    displayName = m["displayName"];
    preset = m["preset"] != null ? TinyPreset.fromMap(m["preset"]) : null;
    photographer = m["photographer"] != null ? TinyPeople.fromMap(m["photographer"]) : null;
    model = m["model"] != null ? TinyPeople.fromMap(m["model"]) : null;
    parent = m["parent"] != null ? TinyPeople.fromMap(m["parent"]) : null;
    witness = m["witness"] != null ? TinyPeople.fromMap(m["witness"]) : null;
    imagesCount = m["imagesCount"];
    location = m["location"];
    date = m["date"];
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
      "preset": tinyContract.preset != null ? TinyPreset.toMap(tinyContract?.preset) : null,
      "photographer": tinyContract.photographer != null ? TinyPeople.toMap(tinyContract.photographer) : null,
      "model": tinyContract.model != null ? TinyPeople.toMap(tinyContract.model) : null,
      "parent": tinyContract.parent != null ? TinyPeople.toMap(tinyContract.parent) : null,
      "witness": tinyContract.witness != null ? TinyPeople.toMap(tinyContract.witness) : null,
      "imagesCount": tinyContract.imagesCount,
      "location": tinyContract.location,
      "date": tinyContract.date,
      "settings": settings,
    };
  }

  static Map<String, String> settingsToMap( List<TinySetting> settings ) {
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