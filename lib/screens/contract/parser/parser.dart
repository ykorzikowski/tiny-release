import 'package:tiny_release/data/tiny_contract.dart';
import 'package:tiny_release/data/tiny_people.dart';
import 'package:tiny_release/data/tiny_preset.dart';
import 'package:tiny_release/screens/contract/parser/parser_config.dart';
import 'package:tiny_release/util/base_util.dart';

class Parser {
  final TinyContract tinyContract;

  Map<String, dynamic> modelMap, photographerMap, parentMap, witnessMap, contractMap;

  Parser(this.tinyContract, ctx) {
    modelMap = TinyPeople.toMap(tinyContract.model);
    photographerMap = TinyPeople.toMap(tinyContract.photographer);
    parentMap = tinyContract.parent != null ? TinyPeople.toMap(tinyContract.parent) : Map();
    witnessMap = tinyContract.witness != null ? TinyPeople.toMap(tinyContract.model) : Map();
    contractMap = TinyContract.toMap(tinyContract);

    if ( ctx != null ) {
      if(modelMap['birthday'] != null) modelMap['birthday'] = BaseUtil.getLocalFormattedDate(ctx, modelMap['birthday']);
      if(photographerMap['birthday'] != null) photographerMap['birthday'] = BaseUtil.getLocalFormattedDate(ctx, photographerMap['birthday']);
      if(witnessMap != null && witnessMap['birthday'] != null) witnessMap['birthday'] = BaseUtil.getLocalFormattedDate(ctx, witnessMap['birthday']);
      if(parentMap != null && parentMap['birthday'] != null ) parentMap['birthday'] = BaseUtil.getLocalFormattedDate(ctx, parentMap['birthday']);
      if(contractMap['date'] != null) contractMap['date'] = BaseUtil.getLocalFormattedDateTime(ctx, contractMap['date']);
    }
  }

  TinyPreset parsePreset() {
    var _parsedPreset = TinyPreset.fromMap( TinyPreset.toMap(tinyContract.preset) );

    for (var value in _parsedPreset.paragraphs) {
      value.title = _parseString(value.title);
      value.content = _parseString(value.content);
    }

    return _parsedPreset;
  }

  String _wrapPlaceholder(str) => '#' + str + '#';

  String _parseString(String str) {
    for (var placeholder in ParserConfig.PLACEHOLDERS) {
      final String first = placeholder.split('.')[0];
      final String last = placeholder.split('.')[1];

      switch(first) {
        case ParserConfig.MODEL:
          str = str.replaceAll(_wrapPlaceholder(placeholder), modelMap[last]?.toString() ?? "");
          break;
        case ParserConfig.PHOTOGRAPHER:
          str = str.replaceAll(_wrapPlaceholder(placeholder), photographerMap[last]?.toString() ?? "");
          break;
        case ParserConfig.WITNESS:
          str = str.replaceAll(_wrapPlaceholder(placeholder), witnessMap[last]?.toString() ?? "");
          break;
        case ParserConfig.PARENT:
          str = str.replaceAll(_wrapPlaceholder(placeholder), parentMap[last]?.toString() ?? "");
          break;
        case ParserConfig.CONTRACT:
          str = str.replaceAll(_wrapPlaceholder(placeholder), contractMap[last]?.toString() ?? "");
          break;
      }
    }


    return str;
  }
}