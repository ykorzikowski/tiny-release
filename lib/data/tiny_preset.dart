import 'package:tiny_release/data/tiny_dbo.dart';

class TinyPreset extends TinyDBO {
  String title, subtitle, language, description;
  List< Paragraph > paragraphs;

  TinyPreset( {this.title, this.subtitle, this.language, this.description, this.paragraphs} );

  TinyPreset.fromMap(Map m) {
    id = m["id"];
    title = m["title"];
    subtitle = m["subtitle"];
    language = m["language"];
    description = m["description"];
    paragraphs = (m["paragraphs"] as Iterable)?.map((m) => Paragraph.fromMap(m));
  }

  static Map toMap(TinyPreset tinyPreset) {
    var paragraphs = [];
    for (Paragraph paragraph in tinyPreset.paragraphs ?? []) {
      paragraphs.add(Paragraph.toMap(paragraph));
    }

    return {
      "id": tinyPreset.id,
      "title": tinyPreset.title,
      "subtitle": tinyPreset.subtitle,
      "language": tinyPreset.language,
      "description": tinyPreset.description,
      "paragraphs": paragraphs,
    };
  }

}

class Paragraph extends TinyDBO {
  String title, content;
  int position;

  Paragraph({this.title, this.content, this.position});

  Paragraph.fromMap(Map m) {
    title = m["title"];
    content = m["content"];
    position = m["position"];
  }

  static Map toMap(Paragraph paragraph) =>
      {
        "title": paragraph.title,
        "content": paragraph.content,
        "position": paragraph.position,
      };
}