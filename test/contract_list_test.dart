import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:paperflavor/data/repo/tiny_contract_repo.dart';
import 'package:paperflavor/data/tiny_contract.dart';
import 'package:paperflavor/data/tiny_people.dart';
import 'package:paperflavor/data/tiny_preset.dart';
import 'package:paperflavor/screens/contract/contract_list.dart';
import 'package:paperflavor/screens/preset/preset_list.dart';
import 'package:paperflavor/util/tiny_state.dart';

import 'test_utils.dart';

class MockTinyContractRepo extends Mock implements TinyContractRepo {}

void main() {
  final TinyState tinyState = new TinyState();
  final TestWidgetsFlutterBinding binding = TestWidgetsFlutterBinding.ensureInitialized();

  TinyContract _getMinimalContract() => TinyContract(
      id: 0,
      displayName: "contract",
      date: DateTime.now().toIso8601String(),
      location: 'loc',
      model: TinyPeople(id: 1, givenName: "Alpha", familyName: "Beta"),
      photographer: TinyPeople(id: 2, givenName: "Gamma", familyName: "Delta"),
  );

  group('Contracts', () {
    testWidgets('ContractList contract is listed on large screen', (WidgetTester tester) async {
      // given
      var tinyPreset = TinyPreset.factory();
      tinyState.currentlyShownPreset = tinyPreset;
      TinyContractRepo tinyContractRepo = MockTinyContractRepo();

      // return one preset on getAll invocation
      List<TinyContract> list = List();
      list.add(_getMinimalContract());
      when(tinyContractRepo.getAll(any, any)).thenAnswer((_) => Future.value(list));

      // then
      await tester.pumpWidget(TestUtils.makeTestableWidget(child: ContractListWidget(
        tinyState: tinyState,
        tinyContractRepo: tinyContractRepo,
      )));
      await tester.pump();

      // assert
      expect( find.byKey(Key('contract_0')), findsOneWidget);
      expect( find.byKey(Key('contract_text_0')), findsOneWidget);
      // FIXME: TINYR-24
//      expect( find.byKey(Key('location_badge_0')), findsOneWidget);
//      expect( find.byKey(Key('date_badge_0')), findsOneWidget);

      expect( find.byKey(Key('circle_avatar_1_0')), findsOneWidget);
      expect( find.byKey(Key('circle_avatar_2_0')), findsOneWidget);

    });

    testWidgets('PresetList add button is there', (WidgetTester tester) async {
      // given
      var tinyPreset = TinyPreset.factory();
      tinyState.currentlyShownPreset = tinyPreset;
      TinyContractRepo tinyContractRepo = MockTinyContractRepo();
      when(tinyContractRepo.getAll(any, any)).thenAnswer((_) => Future.value(List()));

      // then
      await tester.pumpWidget(TestUtils.makeTestableWidget(child: PresetListWidget(
        tinyState: tinyState,
        tinyContractRepo: tinyContractRepo,
      )));
      await tester.pump();

      // assert
      expect( find.byKey(Key('navbar_btn_add')), findsOneWidget);
    });
  });
}
