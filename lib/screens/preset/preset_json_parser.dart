import 'dart:convert';
import 'dart:io';

import 'package:tiny_release/data/tiny_preset.dart';

typedef void JSONErrorCallback();

class PresetJSONParser {

  File _jsonFile;
  final JSONErrorCallback _errorCallback;

  PresetJSONParser(String path, this._errorCallback) {
    _jsonFile = new File(path);
  }

  Future<TinyPreset> map() async {
    try {
      var _presetJson = await _decode();
      if (!await _isValidJson(_presetJson)) {
        _errorCallback();
        return null;
      }

        return TinyPreset.fromMap(_presetJson);
    } catch(error) {
      print(error);
      _errorCallback();
    }
    return null;
  }

  Future<Map<String, dynamic>> _decode() async {
    return json.decode(await _jsonFile.readAsString());
  }

  Future<bool> _isValidJson(Map<String, dynamic> _presetJson) async {
    if (!_presetJson.containsKey("title")) return false;
    if (!_presetJson.containsKey("subtitle")) return false;
    if (!_presetJson.containsKey("language")) return false;
    if (!_presetJson.containsKey("description")) return false;
    if (!_presetJson.containsKey("paragraphs")) return false;

    List<dynamic> paragraphs = _presetJson["paragraphs"];
    for( Map<String, dynamic> para in paragraphs ) {
      if (!para.containsKey("title")) return false;
      if (!para.containsKey("content")) return false;
      if (!para.containsKey("position")) return false;
   }
    return true;
  }
}