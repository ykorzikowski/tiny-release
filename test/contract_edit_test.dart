
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:paperflavor/data/tiny_contract.dart';
import 'package:paperflavor/screens/contract/contract_edit.dart';
import 'package:paperflavor/util/tiny_state.dart';

import 'test_utils.dart';

void main() {

  final TinyState tinyState = new TinyState();

  group('ContractEdit', () {
    testWidgets('ContractEdit PeopleBadge present', (WidgetTester tester) async {
      // given
      var tinyContract = new TinyContract();
      tinyState.curDBO = tinyContract;

      // then
      await tester.pumpWidget(TestUtils.makeTestableWidget(child: ContractEditWidget(
        tinyState: tinyState,
      )));
      await tester.pump();

      // assert
      expect( find.byKey(Key('select_photographer')), findsOneWidget);
      expect( find.byKey(Key('select_model')), findsOneWidget);
    });

    testWidgets('ContractEdit WitnessBadge is expanded', (WidgetTester tester) async {
      // given
      var tinyContract = new TinyContract();
      tinyState.curDBO = tinyContract;

      // then
      await tester.pumpWidget(TestUtils.makeTestableWidget(child: ContractEditWidget(
        tinyState: tinyState,
      )));
      await tester.pump();
      await tester.tap(find.byKey(Key('switch_witness')));
      await tester.pump();

      // assert
      expect( find.byKey(Key('select_witness')), findsOneWidget);
    });

    testWidgets('ContractEdit ParentBadge is expanded', (WidgetTester tester) async {
      // given
      var tinyContract = new TinyContract();
      tinyState.curDBO = tinyContract;

      // then
      await tester.pumpWidget(TestUtils.makeTestableWidget(child: ContractEditWidget(
        tinyState: tinyState,
      )));
      await tester.pump();
      await tester.tap(find.byKey(Key('switch_parent')));
      await tester.pump();

      // assert
      expect( find.byKey(Key('select_parent')), findsOneWidget);
    });


  });
}
