import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:paperflavor/generated/i18n.dart';

import '../constants.dart';

class FlavorS extends S {

  static const GeneratedLocalizationsDelegate delegate =
  const FlavorLocalizationsDelegate();
}

class FlavorLocalizationsDelegate extends GeneratedLocalizationsDelegate {
  const FlavorLocalizationsDelegate();

  @override
  Future<WidgetsLocalizations> load(Locale locale) {
    switch (Constants.APP_FLAVOR) {
      case Constants.WHITELABEL:
        return _loadWhiteLabelLocale(locale);
      case Constants.MODEL:
        return _loadModelLocale(locale);
      case Constants.WRITER:
        return _loadWriterLocale(locale);
    }

    return null;
  }

  @override
  LocaleResolutionCallback resolution({Locale fallback}) {
    return (Locale locale, Iterable<Locale> supported) {
      if ( locale == null) {
        return fallback;
      }
      final Locale languageLocale = new Locale(locale.languageCode, "");
      if (supported.contains(locale))
        return locale;
      else if (supported.contains(languageLocale))
        return languageLocale;
      else {
        final Locale fallbackLocale = fallback ?? supported.first;
        return fallbackLocale;
      }
    };
  }

  Future<WidgetsLocalizations> _loadWhiteLabelLocale(Locale locale) {
    final String lang = getLang(locale);

    switch (lang) {

      case "de":
        return new SynchronousFuture<WidgetsLocalizations>(const de());
      case "en":
        return new SynchronousFuture<WidgetsLocalizations>(const en());
      case "nl":
        return new SynchronousFuture<WidgetsLocalizations>(const nl());

      default:
        return new SynchronousFuture<WidgetsLocalizations>(const en());
    }
  }

  Future<WidgetsLocalizations> _loadModelLocale(Locale locale) {
    final String lang = getLang(locale);

    switch (lang) {

      case "de":
        return new SynchronousFuture<WidgetsLocalizations>(const de_model());
      case "en":
        return new SynchronousFuture<WidgetsLocalizations>(const en_model());
      case "nl":
        return new SynchronousFuture<WidgetsLocalizations>(const nl_model());

      default:
        return new SynchronousFuture<WidgetsLocalizations>(const en_model());
    }
  }

  Future<WidgetsLocalizations> _loadWriterLocale(Locale locale) {
    final String lang = getLang(locale);

    switch (lang) {

      case "de":
        return new SynchronousFuture<WidgetsLocalizations>(const de_writer());
      case "en":
        return new SynchronousFuture<WidgetsLocalizations>(const en_writer());
      case "nl":
        return new SynchronousFuture<WidgetsLocalizations>(const nl_writer());

      default:
        return new SynchronousFuture<WidgetsLocalizations>(const en_writer());
    }
  }
}