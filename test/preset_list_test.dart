import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:paperflavor/data/repo/tiny_contract_repo.dart';
import 'package:paperflavor/data/repo/tiny_preset_repo.dart';
import 'package:paperflavor/data/tiny_preset.dart';
import 'package:paperflavor/screens/preset/preset_list.dart';
import 'package:paperflavor/util/tiny_state.dart';

import 'test_utils.dart';

class MockTinyPresetRepo extends Mock implements TinyPresetRepo {}
class MockTinyContractRepo extends Mock implements TinyContractRepo {}

void main() {
  final TinyState tinyState = new TinyState();

  TinyPresetRepo _getMockedPresetRepo() {
    TinyPresetRepo tinyPresetRepo = MockTinyPresetRepo();

    // return one preset on getAll invocation
    List<TinyPreset> list = List();
    list.add(TinyPreset(id: 0, title: "tinyPreset"));
    when(tinyPresetRepo.getAll(any, any)).thenAnswer((_) => Future.value(list));

    return tinyPresetRepo;
  }

  group('Presets', () {
    testWidgets('PresetList preset is listed', (WidgetTester tester) async {
      // given
      var tinyPreset = TinyPreset.factory();
      tinyState.curDBO = tinyPreset;
      TinyPresetRepo tinyPresetRepo = _getMockedPresetRepo();
      TinyContractRepo tinyContractRepo = TinyContractRepo();
      Function onPresetTap = (){};

      // then
      await tester.pumpWidget(TestUtils.makeTestableWidget(child: PresetListWidget(
        tinyState: tinyState,
        tinyContractRepo: tinyContractRepo,
        tinyPresetRepo: tinyPresetRepo,
        onPresetTap: onPresetTap,
      )));
      await tester.pump();

      // assert
      expect( find.byKey(Key('preset_0')), findsOneWidget);
      expect( find.byKey(Key('preset_title_0')), findsOneWidget);
    });

    testWidgets('PresetList add button is there', (WidgetTester tester) async {
      // given
      var tinyPreset = TinyPreset.factory();
      tinyState.curDBO = tinyPreset;
      TinyPresetRepo tinyPresetRepo = _getMockedPresetRepo();
      TinyContractRepo tinyContractRepo = TinyContractRepo();
      Function onPresetTap = (){};

      // then
      await tester.pumpWidget(TestUtils.makeTestableWidget(child: PresetListWidget(
        tinyState: tinyState,
        tinyContractRepo: tinyContractRepo,
        tinyPresetRepo: tinyPresetRepo,
        onPresetTap: onPresetTap,
      )));
      await tester.pump();

      // assert
      expect( find.byKey(Key('navbar_btn_add')), findsOneWidget);
    });
  });
}
