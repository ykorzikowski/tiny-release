
import 'package:paperflavor/data/tiny_dbo.dart';
import 'package:paperflavor/data/tiny_people.dart';
import 'package:paperflavor/data/tiny_preset.dart';
import 'package:paperflavor/data/tiny_reception.dart';
import 'package:paperflavor/data/tiny_setting.dart';
import 'package:paperflavor/data/tiny_signature.dart';

class TinyContract extends TinyDBO {
  TinyPreset preset;
  TinyPeople model, photographer, parent, witness;
  TinyAddress selectedModelAddress, selectedPhotographerAddress, selectedParentAddress, selectedWitnessAddress;
  int imagesCount;
  bool isLocked = false;
  String location, date;
  List<TinySetting> settings;
  List<TinyReception> receptions;
  TinySignature modelSignature, photographerSignature, witnessSignature, parentSignature;

  TinyContract( {id, displayName, this.preset, this.photographer, this.model, this.parent, this.witness, this.imagesCount, this.settings, this.location, this.date, this.isLocked} ) : super(id: id, displayName: displayName);

  TinyContract.fromMap(Map<String, dynamic> m) {
    id = m["id"];
    displayName = m["displayName"];
    preset = m["preset"] != null ? TinyPreset.fromMap(m["preset"]) : null;
    photographer = m["photographer"] != null ? TinyPeople.fromMap(m["photographer"]) : null;
    model = m["model"] != null ? TinyPeople.fromMap(m["model"]) : null;
    parent = m["parent"] != null ? TinyPeople.fromMap(m["parent"]) : null;
    witness = m["witness"] != null ? TinyPeople.fromMap(m["witness"]) : null;

    selectedModelAddress = m["selectedModelAddress"] != null ? TinyAddress.fromMap(m["selectedModelAddress"]) : null;
    selectedPhotographerAddress = m["selectedPhotographerAddress"] != null ? TinyAddress.fromMap(m["selectedPhotographerAddress"]) : null;
    selectedParentAddress = m["selectedParentAddress"] != null ? TinyAddress.fromMap(m["selectedParentAddress"]) : null;
    selectedWitnessAddress = m["selectedWitnessAddress"] != null ? TinyAddress.fromMap(m["selectedWitnessAddress"]) : null;

    imagesCount = m["imagesCount"];
    location = m["location"];
    date = m["date"];
    modelSignature = m["modelSignature"];
    photographerSignature = m["photographerSignature"];
    witnessSignature = m["witnessSignature"];
    parentSignature = m["parentSignature"];
    isLocked = m["isLocked"] ?? false;
    settings = (m["settings"] as Iterable)
        ?.map((m) => TinySetting.fromMap(m))?.toList();
    receptions = (m["receptions"] as Iterable)
        ?.map((m) => TinyReception.fromMap(m))?.toList();
  }

  static Map<String, dynamic> toMap(TinyContract tinyContract) {
    var settings = List();
    for (TinySetting ts in tinyContract.settings ?? []) {
      settings.add(TinySetting.toMap(ts));
    }

    var receptions = List();
    for (TinyReception ts in tinyContract.receptions ?? []) {
      settings.add(TinyReception.toMap(ts));
    }

    return {
      "id": tinyContract.id,
      "displayName": tinyContract.displayName,
      "preset": tinyContract.preset != null ? TinyPreset.toMap(tinyContract?.preset) : null,
      "photographer": tinyContract.photographer != null ? TinyPeople.toMap(tinyContract.photographer) : null,
      "model": tinyContract.model != null ? TinyPeople.toMap(tinyContract.model) : null,
      "parent": tinyContract.parent != null ? TinyPeople.toMap(tinyContract.parent) : null,
      "witness": tinyContract.witness != null ? TinyPeople.toMap(tinyContract.witness) : null,

      "selectedModelAddress": tinyContract.selectedModelAddress != null ? TinyAddress.toMap(tinyContract.selectedModelAddress) : null,
      "selectedPhotographerAddress": tinyContract.selectedPhotographerAddress != null ? TinyAddress.toMap(tinyContract.selectedPhotographerAddress) : null,
      "selectedParentAddress": tinyContract.selectedParentAddress != null ? TinyAddress.toMap(tinyContract.selectedParentAddress) : null,
      "selectedWitnessAddress": tinyContract.selectedWitnessAddress != null ? TinyAddress.toMap(tinyContract.selectedWitnessAddress) : null,

      "imagesCount": tinyContract.imagesCount,
      "modelSignature": tinyContract.modelSignature,
      "photographerSignature": tinyContract.photographerSignature,
      "witnessSignature": tinyContract.witnessSignature,
      "parentSignature": tinyContract.parentSignature,
      "location": tinyContract.location,
      "date": tinyContract.date,
      "isLocked": tinyContract.isLocked,
      "settings": settings,
      "receptions": receptions,
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

class TinyContractDBO extends TinyDBO {
  int presetId;
  int modelId, photographerId, parentId, witnessId;
  int selectedModelAddressId, selectedPhotographerAddressId, selectedParentAddressId, selectedWitnessAddressId;
  int imagesCount;
  // ignore: non_constant_identifier_names
  int locked_;
  String location, date;

  TinyContractDBO(
      {id, displayName, this.presetId, this.photographerId, this.modelId, this.parentId, this.witnessId,
        this.selectedModelAddressId, this.selectedPhotographerAddressId, this.selectedParentAddressId, this.selectedWitnessAddressId,
        // ignore: non_constant_identifier_names
        this.imagesCount, this.location, this.date, this.locked_})
      : super(id: id, displayName: displayName);

  TinyContractDBO.fromMap(Map<String, dynamic> m) {
    id = m["id"];
    displayName = m["displayName"];
    presetId = m["presetId"];
    modelId = m["modelId"];
    photographerId = m["photographerId"];
    parentId = m["parentId"];
    witnessId = m["witnessId"];

    selectedModelAddressId = m["selectedModelAddressId"];
    selectedPhotographerAddressId = m["selectedPhotographerAddressId"];
    selectedParentAddressId = m["selectedParentAddressId"];
    selectedWitnessAddressId = m["selectedWitnessAddressId"];

    imagesCount = m["imagesCount"];
    location = m["location"];
    date = m["date"];
    locked_ = m["locked_"] ?? 0 ;
  }

  static Map<String, dynamic> toMap(TinyContractDBO tinyContract) {
    return {
      "id": tinyContract.id,
      "displayName": tinyContract.displayName,
      "presetId": tinyContract.presetId,
      "modelId": tinyContract.modelId,
      "photographerId": tinyContract.photographerId,
      "parentId": tinyContract.parentId,
      "witnessId": tinyContract.witnessId,

      "selectedModelAddressId": tinyContract.selectedModelAddressId,
      "selectedPhotographerAddressId": tinyContract.selectedPhotographerAddressId,
      "selectedParentAddressId": tinyContract.selectedParentAddressId,
      "selectedWitnessAddressId": tinyContract.selectedWitnessAddressId,

      "imagesCount": tinyContract.imagesCount,
      "location": tinyContract.location,
      "date": tinyContract.date,
      "locked_": tinyContract.locked_,
    };
  }
}
