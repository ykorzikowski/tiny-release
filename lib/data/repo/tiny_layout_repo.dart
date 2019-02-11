import 'package:tiny_release/data/data_types.dart';
import 'package:tiny_release/data/repo/sqlite_provider.dart';
import 'package:tiny_release/data/tiny_layout.dart';
import 'package:tiny_release/data/repo/tiny_repo.dart';

class TinyLayoutRepo extends TinyRepo< TinyLayout >{

  static const TYPE = DataType.LAYOUT;

  @override
  Future save( TinyLayout item ) {
    //todo implement save
  }

  @override
  Future<List<TinyLayout>> getAll( String type, int offset, int limit ) async {
    return getSync(type, limit);
  }

  @override
  Future< TinyLayout > get(int id) {
    // TODO: implement get
    return null;
  }

  List<TinyLayout> getSync( String type, int index ) {
    var item = new TinyLayout();
    item.displayName = type + " Foo Bar";

    return [item,item,item,item,item,item,item,item,item];
  }

  @override
  Future delete(TinyLayout item) async {
    final db = await SQLiteProvider.db.database;

    var res = await db.delete(TYPE, where: "id = ?", whereArgs: [item.id]);

    return res;
  }

}