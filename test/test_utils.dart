import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:tiny_release/generated/i18n.dart';

class TestUtils {
  static Widget makeTestableWidget({ Widget child }) {
    return MediaQuery(
      data: MediaQueryData(),
      child: MaterialApp(
        home: child,
        supportedLocales: S.delegate.supportedLocales,
        localizationsDelegates: <LocalizationsDelegate>[
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        localeResolutionCallback: S.delegate.resolution(
            fallback: new Locale("en", "")),
      ),
    );
  }

  static CupertinoButton getCupertinoButtonByText(key, find) => find.byType(CupertinoButton).evaluate()
      .where((el) => el.widget is CupertinoButton)
      .where((el) => (el.widget as CupertinoButton).child is Text)
      .where((el) => ((el.widget as CupertinoButton).child as Text).key == key).single.widget as CupertinoButton;
}