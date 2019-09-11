import 'dart:io' as Io;
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:package_info/package_info.dart';
import 'package:path_provider/path_provider.dart';
import 'package:paperflavor/data/repo/tiny_people_repo.dart';
import 'package:paperflavor/data/repo/tiny_layout_repo.dart';
import 'package:paperflavor/data/repo/tiny_preset_repo.dart';
import 'package:paperflavor/data/repo/tiny_reception_repo.dart';
import 'package:paperflavor/data/repo/tiny_repo.dart';
import 'package:paperflavor/data/tiny_people.dart';
import 'package:paperflavor/data/tiny_dbo.dart';
import 'package:paperflavor/data/tiny_layout.dart';
import 'package:paperflavor/data/tiny_preset.dart';
import 'package:paperflavor/data/tiny_reception.dart';
import 'package:paperflavor/generated/i18n.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BaseUtil {

  static Future<String> loadDefaultPresetAsString() async {
    return await rootBundle.loadString('assets/import_test.tinyjson');
  }

  static bool nullMeansTrue(bool) => bool == null ? true : bool;

  static bool nullMeansFalse(bool) => bool == null ? false : bool;

  static Future<bool> get errorReportingIsAllowed async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return BaseUtil.nullMeansFalse(prefs.getBool("user_reporting"));
  }

  static Future<String> getVersionString() async {
    PackageInfo info = await PackageInfo.fromPlatform();

    return '${info.version}_${info.buildNumber}';
  }

  static Future<Io.File> storeFile(String prefix, String suffix, Io.File file) async {
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path;

    return new Io.File('$path/$prefix-${DateTime.now().toUtc().toIso8601String()}.$suffix').writeAsBytes(
        file.readAsBytesSync());
  }

  static Future<Io.File> storeBlobUint8( String prefix, String suffix, Uint8List byteData) async {
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path;

    return new Io.File('$path/$prefix-${DateTime.now().toUtc().toIso8601String()}.$suffix').writeAsBytes(
        byteData);
  }

  static Future<Io.File> storeTempBlobUint8( String prefix, String suffix, Uint8List byteData) async {
    final directory = await getTemporaryDirectory();
    final path = directory.path;

    return new Io.File('$path/$prefix-${DateTime.now().toUtc().toIso8601String()}.$suffix').writeAsBytes(
        byteData);
  }

  static String getParagraphTitle(BuildContext ctx, Paragraph p, int index) {
    return '§' + index.toString() + " " + p.title;
  }

  static String getLocalFormattedDate( final BuildContext context, final String dboStr ) {
    DateFormat formatter = DateFormat(S.of(context).dateFormatPattern);
    return formatter.format(DateTime.parse(dboStr));
  }

  static String getLocalFormattedDateTime( final BuildContext context, final String dboStr ) {
    DateFormat formatter = DateFormat(S.of(context).dateTimeFormatPattern);
    return formatter.format(DateTime.parse(dboStr));
  }

  static bool isLargeScreen(context) {
    return MediaQuery.of(context).size.width > 600;
  }

  static TinyRepo getRepoForDataType( final TinyDBO tinyDBO ) {
    if( tinyDBO is TinyPeople ) {
      return TinyPeopleRepo();
    }

    if( tinyDBO is TinyReception ) {
      return TinyReceptionRepo();
    }

    if( tinyDBO is TinyLayout ) {
      return TinyLayoutRepo();
    }

    if( tinyDBO is TinyPreset ) {
      return TinyPresetRepo();
    }
    return null;
  }

  static Widget getDismissibleBackground() =>
      Container(
        color: CupertinoColors.destructiveRed,
        child: Align(alignment: Alignment.centerRight, child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Icon(
            CupertinoIcons.delete, color: CupertinoColors.white,),),),);
}
