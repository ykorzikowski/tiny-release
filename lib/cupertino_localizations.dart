import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class FallbackCupertinoLocalisationsDelegate extends LocalizationsDelegate<CupertinoLocalizations> {
  const FallbackCupertinoLocalisationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'de'].contains(locale.languageCode);

  @override
  Future<CupertinoLocalizations> load(Locale locale) => SynchronousFuture<_DefaultCupertinoLocalizations>(_DefaultCupertinoLocalizations(locale));

  @override
  bool shouldReload(FallbackCupertinoLocalisationsDelegate old) => false;
}

class _DefaultCupertinoLocalizations extends DefaultCupertinoLocalizations {
  final Locale locale;
  static const monthEs = ['', 'Januar', 'Februar', 'März', 'April', 'May', 'Juni', 'Juli', 'August', 'September', 'Oktober', 'November', 'Dezember'];

  _DefaultCupertinoLocalizations(this.locale);

  @override
  String datePickerMonth(int monthIndex) {
    if(locale.languageCode == 'de') {
      return monthEs[monthIndex];
    }
    return super.datePickerMonth(monthIndex);
  }
}