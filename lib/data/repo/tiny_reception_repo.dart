import 'package:tiny_release/data/data_types.dart';
import 'package:tiny_release/data/tiny_reception.dart';
import 'package:tiny_release/data/repo/tiny_repo.dart';

class TinyReceptionRepo extends TinyRepo< TinyReception >{

  static const TYPE = DataType.RECEPTION;

  @override
  void save( TinyReception item ) {
    //todo implement save
  }

  @override
  Future<List<TinyReception>> getAll( String type, int offset, int limit ) async {
    return getSync(type, limit);
  }

  @override
  Future< TinyReception > get(int id) {
    // TODO: implement get
    return null;
  }

  List<TinyReception> getSync( String type, int index ) {
    var item = new TinyReception();
    item.displayName = type + " Foo Bar";

    return [item,item,item,item,item,item,item,item,item];
  }

}