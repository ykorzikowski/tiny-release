import 'package:test_api/test_api.dart';
import 'package:paperflavor/data/tiny_contract.dart';
import 'package:paperflavor/data/tiny_people.dart';
import 'package:paperflavor/data/tiny_preset.dart';
import 'package:paperflavor/screens/contract/parser/parser.dart';

void main() {
  test('Parser replace model', () {
    // given
    final TinyContract tinyContract = TinyContract.fromMap(Map());
    tinyContract.receptions = List();
    tinyContract.model = TinyPeople( givenName: 'First', familyName: 'Last', emails: List(), postalAddresses: List(), phones: List() );
    tinyContract.photographer = TinyPeople.factory();
    tinyContract.preset = TinyPreset(paragraphs: [
      Paragraph( title: '#model.givenName#', content: '#model.familyName#' )
    ]);

    final Parser parser = Parser(tinyContract, null);

    // then
    TinyPreset parsedPreset = parser.parsePreset();

    // assert
    expect( parsedPreset.paragraphs[0].title, 'First');
    expect( parsedPreset.paragraphs[0].content, 'Last');
  });

  test('Parser replace contract', () {
    // given
    final TinyContract tinyContract = TinyContract.fromMap(Map());
    tinyContract.receptions = List();
    tinyContract.imagesCount = 42;
    tinyContract.location = 'location';
    tinyContract.model = TinyPeople.factory();
    tinyContract.photographer = TinyPeople.factory();
    tinyContract.preset = TinyPreset(paragraphs: [
      Paragraph( title: '#contract.imagesCount#', content: '#contract.location#' )
    ]);

    final Parser parser = Parser(tinyContract, null);

    // then
    TinyPreset parsedPreset = parser.parsePreset();

    // assert
    expect( parsedPreset.paragraphs[0].title, '42');
    expect( parsedPreset.paragraphs[0].content, 'location');
  });

  test('Parser test parser does not change text when no match found', () {
    // given
    final TinyContract tinyContract = TinyContract.fromMap(Map());
    tinyContract.receptions = List();
    tinyContract.imagesCount = 42;
    tinyContract.location = 'location';
    tinyContract.model = TinyPeople.factory();
    tinyContract.photographer = TinyPeople.factory();
    tinyContract.preset = TinyPreset(paragraphs: [
      Paragraph( title: '#something#', content: 'another thing' )
    ]);

    final Parser parser = Parser(tinyContract, null);

    // then
    TinyPreset parsedPreset = parser.parsePreset();

    // assert
    expect( parsedPreset.paragraphs[0].title, '#something#');
    expect( parsedPreset.paragraphs[0].content, 'another thing');
  });
}
