abstract class TinyRepo< T > {
  /// get item for id
  Future< T > get( int id );

  /// save item
  Future save( T item );

  Future delete( T item );

  /// get All items for given type, limit from offset to limit
  Future<List<T>> getAll( String type, int offset, int limit );
}
