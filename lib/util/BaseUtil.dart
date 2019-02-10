import 'package:flutter/cupertino.dart';
import 'package:tiny_release/data/repo/tiny_contact_repo.dart';
import 'package:tiny_release/data/repo/tiny_layout_repo.dart';
import 'package:tiny_release/data/repo/tiny_preset_repo.dart';
import 'package:tiny_release/data/repo/tiny_reception_repo.dart';
import 'package:tiny_release/data/repo/tiny_repo.dart';
import 'package:tiny_release/data/tiny_contact.dart';
import 'package:tiny_release/data/tiny_dbo.dart';
import 'package:tiny_release/data/tiny_layout.dart';
import 'package:tiny_release/data/tiny_preset.dart';
import 'package:tiny_release/data/tiny_reception.dart';

class BaseUtil {
  static bool isLargeScreen(context) {
    return MediaQuery.of(context).size.width > 600;
  }

  static TinyRepo getRepoForDataType( final TinyDBO tinyDBO ) {
    if( tinyDBO is TinyContact ) {
      return TinyContactRepo();
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
}