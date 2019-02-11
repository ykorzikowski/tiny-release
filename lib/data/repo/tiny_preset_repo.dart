import 'package:tiny_release/data/data_types.dart';
import 'package:tiny_release/data/repo/sqlite_provider.dart';
import 'package:tiny_release/data/repo/tiny_paragraph_repo.dart';
import 'package:tiny_release/data/tiny_preset.dart';
import 'package:tiny_release/data/repo/tiny_repo.dart';

class TinyPresetRepo extends TinyRepo< TinyPreset >{

  static const TYPE = DataType.PRESET;
  final ParagraphRepo paragraphRepo = ParagraphRepo();

  @override
  Future save( TinyPreset item ) async {
    final db = await SQLiteProvider.db.database;

    if ( item.id != null ) {
      return update( item );
    }

    var map = TinyPreset.toMap( item );
    map.remove('paragraphs');
    var presetId = await db.insert(TYPE, map );

    item.id = presetId;
    _putParagraphs( item );
  }

  void update(TinyPreset item) async {
    final db = await SQLiteProvider.db.database;

    // remove paragraphs from map
    var map = TinyPreset.toMap(item);
    map.remove('paragraphs');
    db.update(TYPE, map, where: "id = ?", whereArgs: [item.id] );

    _putParagraphs( item );
  }

  void _putParagraphs( var tinyPreset ) {
    for ( Paragraph p in tinyPreset.paragraphs ) {
      p.presetId = tinyPreset.id;
      paragraphRepo.save(p);
    }
  }

  Future _getParagraphs( var tinyPreset ) async {
    var paragraphs = await paragraphRepo.getAllByPresetId(tinyPreset.id);
    tinyPreset.paragraphs = paragraphs;
  }

  @override
  Future<List<TinyPreset>> getAll( int offset, int limit ) async {
    final db = await SQLiteProvider.db.database;

    var res = await db.query(TYPE, limit: limit, offset: offset);
    var list = res.isNotEmpty ? List.of( res.map((c) => TinyPreset.fromMap(c)) ) : List<TinyPreset>();

    for ( TinyPreset tp in list ) {
      await _getParagraphs(tp);
    }

    return list;
  }

  @override
  Future< TinyPreset > get(int id) async {
    final db = await SQLiteProvider.db.database;

    var res = await db.query(TYPE, where: "id = ?", whereArgs: [id]);

    var tp = TinyPreset.fromMap(res.first);
    await _getParagraphs(tp);

    return res.isNotEmpty ? TinyPreset.fromMap(res.first) : Null ;
  }

  @override
  Future delete(TinyPreset item) async {
      final db = await SQLiteProvider.db.database;

      var res = await db.delete(TYPE, where: "id = ?", whereArgs: [item.id]);
      paragraphRepo.deleteByPresetId( item.id );

      return res;
  }

}