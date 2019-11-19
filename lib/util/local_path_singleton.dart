
import 'package:path_provider/path_provider.dart';

class LocalPath {
  static final LocalPath _instance = LocalPath._internal();
  String localPath;

  factory LocalPath() {
    return _instance;
  }

  LocalPath._internal() {
    _localPath.then((val) => localPath = val);
  }

  static Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }


}   
