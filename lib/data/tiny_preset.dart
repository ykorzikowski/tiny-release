import 'package:tiny_release/data/tiny_dbo.dart';

class TinyPreset extends TinyDBO {
  String title, subtitle, language, description;
  List< Paragraph > paragraphs;

  TinyPreset( {id, displayName, this.title, this.subtitle, this.language, this.description, this.paragraphs} ) : super(id: id, displayName: displayName);

  TinyPreset.fromMap(Map<String, dynamic> m) {
    id = m["id"];
    displayName = m["displayName"];
    title = m["title"];
    subtitle = m["subtitle"];
    language = m["language"];
    description = m["description"];
  }

  static Map<String, dynamic> toMap(TinyPreset tinyPreset) {
    return {
      "id": tinyPreset.id,
      "displayName": tinyPreset.displayName,
      "title": tinyPreset.title,
      "subtitle": tinyPreset.subtitle,
      "language": tinyPreset.language,
      "description": tinyPreset.description,
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