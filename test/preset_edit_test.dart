import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:paperflavor/data/tiny_preset.dart';
import 'package:paperflavor/screens/preset/preset_edit.dart';
import 'package:paperflavor/util/tiny_state.dart';

import 'test_utils.dart';

void main() {
  final TinyState tinyState = new TinyState();

  group('Validation', () {
    testWidgets('PresetWidget save button disabled on missing title', (WidgetTester tester) async {
      // given
      var tinyPreset = TinyPreset.factory();
      tinyState.currentlyShownPreset = tinyPreset;

      // then
      await tester.pumpWidget(TestUtils.makeTestableWidget(child: PresetEditWidget(tinyState)));
      await tester.pump();

      // assert
      expect( TestUtils.getCupertinoButtonByText(Key('btn_navbar_save'), find).enabled, false );
    });

    testWidgets('PresetWidget save button disabled on missing paragraph', (WidgetTester tester) async {
      // given
      var tinyPreset = TinyPreset.factory();
      tinyState.currentlyShownPreset = tinyPreset;
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
      tinyState.currentlyShownPreset = tinyPreset;
      await tester.pumpWidget(TestUtils.makeTestableWidget(child: PresetEditWidget(tinyState)));

      // then
      await tester.enterText(find.byKey(Key('tf_preset_title')), 'fm');
      await tester.pump();

      // assert
      expect( TestUtils.getCupertinoButtonByText(Key('btn_navbar_save'), find).enabled, false );
    });

    testWidgets('PresetWidget save button enabled on complete paragraph and title set', (WidgetTester tester) async {
      // given
      var tinyPreset = TinyPreset.factory();
      tinyPreset.paragraphs.add(Paragraph(position: 0));
      tinyState.currentlyShownPreset = tinyPreset;
      await tester.pumpWidget(TestUtils.makeTestableWidget(child: PresetEditWidget(tinyState)));

      // then
      await tester.enterText(find.byKey(Key('tf_preset_title')), 'fm');
      await tester.enterText(find.byKey(Key('tf_paragraph_title_0')), 'fm');
      await tester.enterText(find.byKey(Key('tf_paragraph_content_0')), 'fm');
      await tester.pump();

      // assert
      expect( TestUtils.getCupertinoButtonByText(Key('btn_navbar_save'), find).enabled, true );
    });

    testWidgets('PresetWidget paragraph added on "btn_add_paragraph"', (WidgetTester tester) async {
      // given
      var tinyPreset = TinyPreset.factory();
      tinyState.currentlyShownPreset = tinyPreset;

      // then
      await tester.pumpWidget(TestUtils.makeTestableWidget(child: PresetEditWidget(tinyState)));
      await tester.tap(find.byKey(Key('btn_add_paragraph')));
      await tester.pump();

      // assert
      expect( find.byKey(Key('tf_paragraph_title_0')), findsOneWidget );
    });
  });
}
