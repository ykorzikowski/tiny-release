// Imports the Flutter Driver API
import 'dart:convert';
import 'dart:io';

import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

Future _addPreset(FlutterDriver driver) async {
  // go to Settings
  var tapBar = find.byValueKey('tab_bar_settings');
  await driver.tap(tapBar);

  // tap on presets
  var peopleControlItem = find.byValueKey('control_1');
  await driver.tap(peopleControlItem);

  // tap on add paragraph
  var addPeople = find.byValueKey('navbar_btn_add');
  await driver.tap(addPeople);

  final file = new File('test_assets/test_preset.json');
  final Map<String, dynamic> presetJson = json.decode(await file.readAsString());

  var lastParagraphTitle;
  for (var key in presetJson.keys) {
    if ( key == 'paragraphs' ) {
      List<dynamic> paras = presetJson[key];
      for (int i = 0; i < paras.length; i++) {
        var map = paras[i];
        await driver.tap( find.byValueKey('btn_add_paragraph') );

        lastParagraphTitle = find.byValueKey('tf_paragraph_title_$i');
        await driver.tap( lastParagraphTitle );
        await driver.enterText(map['title']);
        await driver.scrollUntilVisible(find.byValueKey('scrlvw_preset_edit'), find.byValueKey('tf_paragraph_title_$i') );

        await driver.tap( find.byValueKey('tf_paragraph_content_$i') );
        await driver.enterText(map['content']);
        await driver.scrollUntilVisible(find.byValueKey('scrlvw_preset_edit'), find.byValueKey('tf_paragraph_content_$i') );
      }

      continue;
    }
    await driver.tap( find.byValueKey('tf_preset_$key') );
    await driver.enterText(presetJson[key]);
  }

  // hit save button
  await driver.tap( find.byValueKey('btn_navbar_save') );

  var pageBack = find.pageBack();
  if (await isPresent(pageBack, driver)) {
    await driver.tap(pageBack);
  }
}

Future _addPerson(FlutterDriver driver) async {
  // go to Settings
  var tapBar = find.byValueKey('tab_bar_settings');
  await driver.tap(tapBar);

  final file = new File('test_assets/people.json');
  final List<dynamic> peopleJson = json.decode(await file.readAsString());

  // tap on people
  var peopleControlItem = find.byValueKey('control_0');
  await driver.tap(peopleControlItem);

  for (var map in peopleJson) {

    // tap on add people
    await driver.tap(find.byValueKey('navbar_btn_add'));

    for (var key in map.keys) {
      if( key == 'addresses' ) {
        List<dynamic> items = map[key];
        for (int i = 0; i < items.length; i++) {
          var map = items[i];

          // tap on add address
          await driver.tap( find.byValueKey('btn_add_address') );

          // fill out address
          await driver.scrollUntilVisible(find.byValueKey('scrlvw_preset_edit'), find.byValueKey('tf_city_$i') );
          await driver.tap( find.byValueKey('tf_label_$i') );
          await driver.enterText("Private");

          await driver.tap( find.byValueKey('tf_street_$i') );
          await driver.enterText(map['street']);

          await driver.tap( find.byValueKey('tf_postcode_$i') );
          await driver.enterText(map['postcode'].toString());

          await driver.tap( find.byValueKey('tf_city_$i') );
          await driver.enterText(map['city']);
        }
        continue;
      }
      await driver.tap( find.byValueKey('tf_$key') );
      await driver.enterText(map[key].toString());
    }

    // hit save button
    var findSave = find.byValueKey('btn_navbar_save');
    await driver.waitFor(findSave);
    await driver.tap(findSave);
  }

  var pageBack = find.pageBack();
  if (await isPresent(pageBack, driver)) {
    await driver.tap(pageBack);
  }
}

Future _addReception(FlutterDriver driver) async {
  // go to Settings
  var tapBar = find.byValueKey('tab_bar_settings');
  await driver.tap(tapBar);

  // tap on presets
  var peopleControlItem = find.byValueKey('control_2');
  await driver.tap(peopleControlItem);

  final file = new File('test_assets/receptions.json');
  final List<dynamic> presetJson = json.decode(await file.readAsString());

  for (var value in presetJson) {
    await driver.tap( find.byValueKey('btn_add_reception') );
    await driver.tap( find.byValueKey('tf_reception') );
    await driver.enterText(value);
    await driver.tap( find.byValueKey('btn_save_reception') );
  }

  var pageBack = find.pageBack();
  if (await isPresent(pageBack, driver)) {
    await driver.tap(pageBack);
  }
}

Future _addContract(FlutterDriver driver) async {
  // go to Settings
  var tapBar = find.byValueKey('tab_bar_add');
  await driver.tap(tapBar);

  // tap on navbar add
  await driver.tap(find.byValueKey('navbar_btn_add'));

  // choose photographer
  await driver.tap(find.byValueKey('select_photographer'));
  await driver.tap(find.byValueKey('people_0'));

  // choose model
  await driver.tap(find.byValueKey('select_model'));
  await driver.tap(find.byValueKey('people_1'));

  // choose parent
  await driver.scrollUntilVisible(find.byType('ListView'), find.byValueKey('switch_witness') );
  await driver.tap(find.byValueKey('switch_parent'));
  await driver.tap(find.byValueKey('select_parent'));
  await driver.tap(find.byValueKey('people_2'));

  // choose witness
  await driver.tap(find.byValueKey('switch_witness'));
  await driver.tap(find.byValueKey('select_witness'));
  await driver.tap(find.byValueKey('people_3'));

  // choose preset
  await driver.scrollUntilVisible(find.byType('ListView'), find.byValueKey('btn_select_date') );
  await driver.tap(find.byValueKey('btn_add_preset'));
  await driver.tap(find.byValueKey('preset_0'));

  // set date
  await driver.tap(find.byValueKey('btn_select_date'));
  await driver.scroll(find.byValueKey('datepicker'), 0, 400, Duration(milliseconds: 300));
  await driver.tap(find.byValueKey('btn_ok'));

  // set images count
  await driver.tap(find.byValueKey('btn_set_images_count'));
  await driver.scroll(find.byValueKey('image_count_picker'), 0, -200, Duration(milliseconds: 300));
  await driver.tap(find.byValueKey('btn_ok'));

  // set location
  await driver.scrollUntilVisible(find.byType('ListView'), find.byValueKey('btn_set_reception') );
  await driver.tap( find.byValueKey('tf_location') );
  await driver.enterText('Düsseldorf');

  // set subject
  await driver.tap( find.byValueKey('tf_subject') );
  await driver.enterText('Summershooting');

  // add reception areas
  await driver.tap( find.byValueKey('btn_set_reception') );
  await driver.tap(find.byValueKey('reception_0'));
  await driver.tap( find.byValueKey('btn_set_reception') );
  await driver.tap(find.byValueKey('reception_1'));

  // sign contract
  await driver.tap( find.byValueKey('btn_sign_contract') );

  // TODO: fix signing test   
//  await driver.scroll(find.byValueKey('scrlvw_contract_generated'), 0, 1000, Duration(milliseconds: 400));
//  await driver.tap(find.byValueKey('signature_photographer_flex'));
//  await driver.tap(find.byValueKey('signature_photographer_dialog'));

}

Future<bool> isPresent(SerializableFinder finder, FlutterDriver driver, {Duration timeout = const Duration(seconds: 1)}) async {
  try {
    await driver.waitFor(finder, timeout: timeout);
    return true;
  } catch (e) {
    return false;
  }
}

void main() {
  group('Input Data', () {
    FlutterDriver driver;

    // Connect to the Flutter driver before running any tests
    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    // Close the connection to the driver after the tests have completed
    tearDownAll(() async {
      if (driver != null) {
        await driver.close();
      }
    });

    test('verifies create people', () async {
      await _addPerson(driver);
    }, timeout: Timeout.factor(3));

    test('verifies create preset', () async {
      await _addPreset(driver);
    }, timeout: Timeout.factor(2));

    test('verifies create receptions', () async {
      await _addReception(driver);
    }, timeout: Timeout.factor(2));


    test('verifies add contract', () async {
      await _addContract(driver);
    }, timeout: Timeout.factor(3));
//
//      //TODO: stub code copied from flutter.io.
//      await driver.scrollUntilVisible(
//        // Scroll through this list
//        listFinder,
//        // Until we find this item
//        itemFinder,
//        // In order to scroll down the list, we need to provide a negative
//        // value to dyScroll. Ensure this value is a small enough increment to
//        // scroll the item into view without potentially scrolling past it.
//        //
//        // If you need to scroll through horizontal lists, provide a dxScroll
//        // argument instead
//        dyScroll: -300.0,
//      );
//
//      // Verify the item contains the correct text
//      expect(
//        await driver.getText(itemFinder),
//        'Item 50',
//      );
  });
}
