abstract class TinyRepo< T > {
  /// get item for id
  T get( int id );

  /// save item
  void save( T item );

  /// get All items for given type, limit from offset to limit
  Future<List<T>> getAll( String type, int offset, int limit );
}
