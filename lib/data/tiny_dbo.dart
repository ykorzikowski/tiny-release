import 'package:sentry/sentry.dart';

abstract class TinyDBO {

  TinyDBO({this.id, this.displayName});

  /// database id
  int id;

  /// shown in lists
  String displayName;
}
