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

    for ( Paragraph p in item.paragraphs ) {
      p.presetId = presetId;
      paragraphRepo.save(p);
    }
  }

  void update(TinyPreset item) async {
    final db = await SQLiteProvider.db.database;

    // remove paragraphs from map
    var map = TinyPreset.toMap(item);
    map['paragraphs'] = null;
    db.update(TYPE, TinyPreset.toMap(item));

    for ( Paragraph p in item.paragraphs ) {
      p.presetId = item.id;
      paragraphRepo.save(p);
    }
  }

  @override
  Future<List<TinyPreset>> getAll( int offset, int limit ) async {
    final db = await SQLiteProvider.db.database;

    var res = await db.query(TYPE, limit: limit, offset: offset);
    var list = res.isNotEmpty ? List.of( res.map((c) => TinyPreset.fromMap(c)) ) : List<TinyPreset>();

    for ( TinyPreset tp in list ) {
      var paragraphs = await paragraphRepo.getAllByPresetId(tp.id);
      tp.paragraphs = paragraphs;
    }

    return list;
  }

  @override
  Future< TinyPreset > get(int id) async {
    final db = await SQLiteProvider.db.database;

    var res = await db.query(TYPE, where: "id = ?", whereArgs: [id]);

    var tp = TinyPreset.fromMap(res.first);
    var paragraphs = await paragraphRepo.getAllByPresetId(tp.id);
    tp.paragraphs = paragraphs;

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