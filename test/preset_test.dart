import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tiny_release/data/tiny_preset.dart';
import 'package:tiny_release/screens/preset/preset_edit.dart';
import 'package:tiny_release/util/tiny_state.dart';

import 'test_utils.dart';

void main() {
  final TinyState tinyState = new TinyState();

  group('Presets', () {
    testWidgets('PresetWidget save button disabled on missing title', (WidgetTester tester) async {
      // given
      var tinyPreset = TinyPreset.factory();
      tinyState.curDBO = tinyPreset;

      // then
      await tester.pumpWidget(TestUtils.makeTestableWidget(child: PresetEditWidget(tinyState)));
      await tester.pump();

      // assert
      expect( TestUtils.getCupertinoButtonByText(Key('btn_navbar_save'), find).enabled, false );
    });

    testWidgets('PresetWidget save button disabled on missing paragraph', (WidgetTester tester) async {
      // given
      var tinyPreset = TinyPreset.factory();
      tinyState.curDBO = tinyPreset;
      await tester.pumpWidget(TestUtils.makeTestableWidget(child: PresetEditWidget(tinyState)));

      // then
      await tester.enterText(find.byKey(Key('tf_preset_title')), 'fm');
      await tester.pump();

      // assert
      expect( TestUtils.getCupertinoButtonByText(Key('btn_navbar_save'), find).enabled, false );
    });

    testWidgets('PresetWidget save button disabled on incomplete paragraph', (WidgetTester tester) async {
      // given
      var tinyPreset = TinyPreset.factory();
      tinyPreset.paragraphs.add(Paragraph());
      tinyState.curDBO = tinyPreset;
      await tester.pumpWidget(TestUtils.makeTestableWidget(child: PresetEditWidget(tinyState)));

      // then
      await tester.enterText(find.byKey(Key('tf_preset_title')), 'fm');
      await tester.pump();

      // assert
      expect( TestUtils.getCupertinoButtonByText(Key('btn_navbar_save'), find).enabled, false );
    });
  });

  testWidgets('PresetWidget save button enabled on complete paragraph and title set', (WidgetTester tester) async {
    // given
    var tinyPreset = TinyPreset.factory();
    tinyPreset.paragraphs.add(Paragraph());
    tinyState.curDBO = tinyPreset;
    await tester.pumpWidget(TestUtils.makeTestableWidget(child: PresetEditWidget(tinyState)));

    // then
    await tester.enterText(find.byKey(Key('tf_preset_title')), 'fm');
    await tester.enterText(find.byKey(Key('tf_paragraph_title_0')), 'fm');
    await tester.enterText(find.byKey(Key('tf_paragraph_content_0')), 'fm');
    await tester.pump();

    // assert
    expect( TestUtils.getCupertinoButtonByText(Key('btn_navbar_save'), find).enabled, true );
  });
}