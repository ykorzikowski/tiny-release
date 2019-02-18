import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
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