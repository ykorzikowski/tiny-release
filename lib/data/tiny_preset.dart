import 'package:paperflavor/data/tiny_dbo.dart';

class TinyPreset extends TinyDBO {
  String title, subtitle, language, description;
  int isManualEdited;
  List< Paragraph > paragraphs;

  TinyPreset( {id, displayName, this.title, this.isManualEdited, this.subtitle, this.language, this.description, this.paragraphs} ) : super(id: id, displayName: displayName);

  static TinyPreset factory() {
    var _tinyPreset = TinyPreset();

    _tinyPreset.paragraphs = List();

    return _tinyPreset;
  }

  TinyPreset.fromMap(Map<String, dynamic> m) {
    id = m["id"];
    isManualEdited = m["isManualEdited"];
    displayName = m["displayName"];
    title = m["title"];
    subtitle = m["subtitle"];
    language = m["language"];
    description = m["description"];
    paragraphs = (m["paragraphs"] as Iterable)
        ?.map((m) => Paragraph.fromMap(m))?.toList();
  }

  static Map<String, dynamic> toMap(TinyPreset tinyPreset) {
    var paragraphs = List();
    for (Paragraph p in tinyPreset.paragraphs ?? []) {
      paragraphs.add(Paragraph.toMap(p));
    }

    return {
      "id": tinyPreset.id,
      "isManualEdited": tinyPreset.isManualEdited,
      "displayName": tinyPreset.displayName,
      "title": tinyPreset.title,
      "subtitle": tinyPreset.subtitle,
      "language": tinyPreset.language,
      "description": tinyPreset.description,
      "paragraphs": paragraphs
    };
  }

}

class Paragraph extends TinyDBO {
  String title, content;
  int position, presetId;

  Paragraph({id, this.title, this.content, this.position, this.presetId}) : super(id: id, displayName: "");

  Paragraph.fromMap(Map<String, dynamic> m) {
    id = m["id"];
    title = m["title"];
    content = m["content"];
    position = m["position"];
    presetId = m["presetId"];
  }

  static Map<String, dynamic> toMap(Paragraph paragraph) =>
      {
        "id": paragraph.id,
        "title": paragraph.title,
        "content": paragraph.content,
        "position": paragraph.position,
        "presetId": paragraph.presetId
      };
}
