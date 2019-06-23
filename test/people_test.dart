import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:paperflavor/data/tiny_people.dart';
import 'package:paperflavor/screens/people/people_edit.dart';
import 'package:paperflavor/util/tiny_state.dart';

import 'test_utils.dart';

void main() {
  final TinyState tinyState = new TinyState();

  group('People', () {
    testWidgets('PeopleEditWidget save button disabled on missing givenName', (WidgetTester tester) async {
      // given
      var tinyPeople = TinyPeople.factory();
      tinyState.curDBO = tinyPeople;
      await tester.pumpWidget(TestUtils.makeTestableWidget(child: PeopleEditWidget(tinyState)));
      await tester.pump();

      // then
      await tester.enterText(find.byKey(Key('tf_familyName')), 'fm');

      // assert
      expect( TestUtils.getCupertinoButtonByText(Key('btn_navbar_save'), find).enabled, false );
    });

    testWidgets('PeopleEditWidget save button disabled on missing familyName', (WidgetTester tester) async {
      // given
      var tinyPeople = TinyPeople.factory();
      tinyState.curDBO = tinyPeople;

      // then
      await tester.pumpWidget(TestUtils.makeTestableWidget( child: PeopleEditWidget(tinyState) ));
      await tester.enterText(find.byKey(Key('tf_givenName')), 'fm');
      await tester.pump();

      // assert
      expect( TestUtils.getCupertinoButtonByText(Key('btn_navbar_save'), find).enabled, false );
    });

    testWidgets('PeopleEditWidget save button enabled on missing saved', (WidgetTester tester) async {
      // given
      var tinyPeople = TinyPeople.factory();
      tinyState.curDBO = tinyPeople;

      // then
      await tester.pumpWidget(TestUtils.makeTestableWidget( child: PeopleEditWidget(tinyState) ));
      await tester.enterText(find.byKey(Key('tf_familyName')), 'Han');
      await tester.enterText(find.byKey(Key('tf_givenName')), 'Solo');
      await tester.enterText(find.byKey(Key('tf_street_0')), 'street');
      await tester.enterText(find.byKey(Key('tf_city_0')), 'city');
      await tester.enterText(find.byKey(Key('tf_postcode_0')), 'postcode');
      await tester.pump();

      // assert
      expect( TestUtils.getCupertinoButtonByText(Key('btn_navbar_save'), find).enabled, true );
    });

    testWidgets('PeopleEditWidget two addresses present', (WidgetTester tester) async {
      // given
      var tinyPeople = TinyPeople.factory();
      tinyPeople.postalAddresses.add(TinyAddress());
      tinyPeople.postalAddresses.add(TinyAddress());
      tinyState.curDBO = tinyPeople;

      // then
      await tester.pumpWidget(TestUtils.makeTestableWidget(child: PeopleEditWidget(tinyState)));

      // assert
      expect( find.byKey(Key('tf_street_1')), findsOneWidget );
    });

    testWidgets('PeopleEditWidget mail is present', (WidgetTester tester) async {
      // given
      var tinyPeople = TinyPeople.factory();
      tinyPeople.emails.add(TinyPeopleItem());
      tinyState.curDBO = tinyPeople;

      // then
      await tester.pumpWidget(TestUtils.makeTestableWidget(child: PeopleEditWidget(tinyState)));

      // assert
      expect( find.byKey(Key('tf_mail_address_0')), findsOneWidget );
    });

    testWidgets('PeopleEditWidget phone is present', (WidgetTester tester) async {
      // given
      var tinyPeople = TinyPeople.factory();
      tinyPeople.phones.add(TinyPeopleItem());
      tinyState.curDBO = tinyPeople;

      // then
      await tester.pumpWidget(TestUtils.makeTestableWidget(child: PeopleEditWidget(tinyState)));

      // assert
      expect( find.byKey(Key('tf_phone_number_0')), findsOneWidget );
    });
  });
}
