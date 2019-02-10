import 'package:tiny_release/data/data_types.dart';
import 'package:tiny_release/data/tiny_preset.dart';
import 'package:tiny_release/data/repo/tiny_repo.dart';

class TinyPresetRepo extends TinyRepo< TinyPreset >{

  static const TYPE = DataType.PRESET;

  @override
  void save( TinyPreset item ) {
    //todo implement save
  }

  @override
  Future<List<TinyPreset>> getAll( String type, int offset, int limit ) async {
    return getSync(type, limit);
  }

  @override
  TinyPreset get(int id) {
    // TODO: implement get
    return null;
  }

  List<TinyPreset> getSync( String type, int index ) {
    var item = new TinyPreset();
    item.displayName = type + " Foo Bar";

    return [item,item,item,item,item,item,item,item,item];
  }

}