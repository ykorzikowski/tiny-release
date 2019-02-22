import 'dart:io' as Io;
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as Img;
import 'package:tiny_release/data/repo/tiny_people_repo.dart';
import 'package:tiny_release/data/repo/tiny_layout_repo.dart';
import 'package:tiny_release/data/repo/tiny_preset_repo.dart';
import 'package:tiny_release/data/repo/tiny_reception_repo.dart';
import 'package:tiny_release/data/repo/tiny_repo.dart';
import 'package:tiny_release/data/tiny_people.dart';
import 'package:tiny_release/data/tiny_dbo.dart';
import 'package:tiny_release/data/tiny_layout.dart';
import 'package:tiny_release/data/tiny_preset.dart';
import 'package:tiny_release/data/tiny_reception.dart';
import 'package:tiny_release/generated/i18n.dart';

class BaseUtil {

  static Future<Io.File> storeBlob(ByteData byteData) async {
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path;

    final Img.Image img = Img.decodeImage(Uint8List.view(byteData.buffer));

    return new Io.File('$path/${DateTime.now().toUtc().toIso8601String()}.png')
        ..writeAsBytes(Img.encodePng(img));
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