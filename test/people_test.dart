import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tiny_release/data/tiny_people.dart';
import 'package:tiny_release/generated/i18n.dart';
import 'package:tiny_release/screens/people/people_edit.dart';
import 'package:tiny_release/util/tiny_state.dart';

void main() {
  final TinyState tinyState = new TinyState();

  Widget makeTestableWidget({ Widget child }) {
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

  CupertinoButton getCupertinoButtonByText(key) => find.byType(CupertinoButton).evaluate()
      .where((el) => el.widget is CupertinoButton)
      .where((el) => (el.widget as CupertinoButton).child is Text)
      .where((el) => ((el.widget as CupertinoButton).child as Text).key == key).single.widget as CupertinoButton;

  group('People', () {
    testWidgets('PeopleEditWidget blocks no givenName', (WidgetTester tester) async {
      // given
      var tinyPeople = TinyPeople.factory();
      tinyState.curDBO = tinyPeople;
      await tester.pumpWidget(makeTestableWidget(child: PeopleEditWidget(tinyState)));
      await tester.pump();

      // then
      await tester.enterText(find.byKey(Key('tf_familyName')), 'fm');

      // assert
      expect( getCupertinoButtonByText(Key('btn_navbar_save')).enabled, false );
    });

    testWidgets('PeopleEditWidget blocks no familyName', (WidgetTester tester) async {
      // given
      var tinyPeople = TinyPeople.factory();
      tinyState.curDBO = tinyPeople;

      // then
      await tester.pumpWidget(makeTestableWidget( child: PeopleEditWidget(tinyState) ));
      await tester.enterText(find.byKey(Key('tf_givenName')), 'fm');
      await tester.pump();

      // assert
      expect( getCupertinoButtonByText(Key('btn_navbar_save')).enabled, false );
    });

    testWidgets('PeopleEditWidget test is saved', (WidgetTester tester) async {
      // given
      var tinyPeople = TinyPeople.factory();
      tinyState.curDBO = tinyPeople;

      // then
      await tester.pumpWidget(makeTestableWidget( child: PeopleEditWidget(tinyState) ));
      await tester.enterText(find.byKey(Key('tf_familyName')), 'Han');
      await tester.enterText(find.byKey(Key('tf_givenName')), 'Solo');
      await tester.pump();

      // assert
      expect( getCupertinoButtonByText(Key('btn_navbar_save')).enabled, true );
    });
  });
}

Future<List<TinyPeople>> _getPeople(pageIndex) async {
  var p1 = new TinyPeople();
  p1.givenName = "Han";
  p1.familyName = "Solo";

  var list = List<TinyPeople>();
  list.add(p1);

  return list;
}