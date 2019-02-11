import 'package:tiny_release/data/data_types.dart';
import 'package:tiny_release/data/repo/sqlite_provider.dart';
import 'package:tiny_release/data/tiny_preset.dart';
import 'package:tiny_release/data/repo/tiny_repo.dart';

class ParagraphRepo extends TinyRepo< Paragraph >{

  static const TYPE = DataType.PARAGRAPH;

  @override
  Future save( Paragraph item ) async {
    final db = await SQLiteProvider.db.database;

    if ( item.id != null ) {
      return update( item );
    }

    db.insert(TYPE, Paragraph.toMap( item ) );
  }

  void update( Paragraph item ) async {
    final db = await SQLiteProvider.db.database;

    db.update(TYPE, Paragraph.toMap( item ) );
  }

  @override
  Future<List<Paragraph>> getAll( int offset, int limit ) async {
    final db = await SQLiteProvider.db.database;

    var res = await db.query(TYPE, limit: limit, offset: offset);
    List<Paragraph> list = res.isNotEmpty ? res.toList().map((c) => Paragraph.fromMap(c)) : List<Paragraph>();
    return List<Paragraph>.of( list );
  }

  @override
  Future< Paragraph > get(int id) async {
    final db = await SQLiteProvider.db.database;

    var res = await db.query(TYPE, where: "id = ?", whereArgs: [id]);
    return res.isNotEmpty ? Paragraph.fromMap(res.first) : Null ;
  }

  Future<List<Paragraph>> getAllByPresetId( int presetId ) async {
    final db = await SQLiteProvider.db.database;

    var res = await db.query(TYPE, where: "presetId = ?", whereArgs: [presetId]);
    List<Paragraph> list = res.isNotEmpty ? res.toList().map((c) => Paragraph.fromMap(c)) : List<Paragraph>();
    return List<Paragraph>.of( list );
  }

  Future deleteByPresetId(int presetId) async {
    final db = await SQLiteProvider.db.database;

    var res = await db.delete(TYPE, where: "presetId = ?", whereArgs: [presetId]);

    return res;
  }

  @override
  Future delete(Paragraph item) async {
    final db = await SQLiteProvider.db.database;

    var res = await db.delete(TYPE, where: "id = ?", whereArgs: [item.id]);

    return res;
  }

}