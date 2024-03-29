// Imports the Flutter Driver API
import 'dart:convert';
import 'dart:io';

import 'package:screenshots/screenshots.dart';

import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

Future _addPreset(FlutterDriver driver, screenshotConfig) async {
  // go to Settings
  var tapBar = find.byValueKey('tab_bar_settings');
  await driver.tap(tapBar);

  // tap on presets
  var peopleControlItem = find.byValueKey('control_1');
  await driver.tap(peopleControlItem);

  final file = new File('test_assets/test_preset.json');
  final List<dynamic> presetsJson = json.decode(await file.readAsString());

  bool isFirstPresetAdded = true;
  for (var presetJson in presetsJson) {
    // tap on add paragraph
    var addPreset = find.byValueKey('navbar_btn_add');
    await driver.tap(addPreset);

    var lastParagraphTitle;
    for (var key in presetJson.keys) {
      if ( key == 'paragraphs' ) {
        List<dynamic> paras = presetJson[key];
        for (int i = 0; i < paras.length; i++) {
          var map = paras[i];
          await driver.scrollUntilVisible(find.byType('SingleChildScrollView'), find.byValueKey('btn_add_paragraph') );
          await driver.tap( find.byValueKey('btn_add_paragraph') );

          await driver.scrollUntilVisible(find.byType('SingleChildScrollView'), find.byValueKey('tf_paragraph_title_$i') );
          lastParagraphTitle = find.byValueKey('tf_paragraph_title_$i');
          await driver.tap( lastParagraphTitle );
          await driver.enterText(map['title']);

          await driver.scrollUntilVisible(find.byType('SingleChildScrollView'), find.byValueKey('tf_paragraph_content_$i') );
          await driver.tap( find.byValueKey('tf_paragraph_content_$i') );
          await driver.enterText(map['content']);
        }

        continue;
      }
      await driver.tap( find.byValueKey('tf_preset_$key') );
      await driver.enterText(presetJson[key]);
    }

    if (isFirstPresetAdded) await screenshot(driver, screenshotConfig, 'preset_edit');

    // hit save button
    await driver.tap( find.byValueKey('btn_navbar_save') );
  }

  await screenshot(driver, screenshotConfig, 'preset_overview');
  var pageBack = find.pageBack();
  if (await isPresent(pageBack, driver)) {
    await driver.tap(pageBack);
  }
}

Future _addPerson(FlutterDriver driver, screenshotConfig) async {
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
    print("wait for navbar_btn_add");
    await driver.tap(find.byValueKey('navbar_btn_add'));

    for (var key in map.keys) {
      if( key == 'addresses' ) {
        List<dynamic> items = map[key];
        for (int i = 0; i < items.length; i++) {
          var map = items[i];

          // tap on add address
          if ( i > 0 ) {
            await driver.scrollUntilVisible(find.byType('SingleChildScrollView'), find.byValueKey('btn_add_address') );
            await driver.tap(find.byValueKey('btn_add_address'));
          }
          // fill out address
          await driver.scrollUntilVisible(find.byType('SingleChildScrollView'), find.byValueKey('tf_city_$i') );
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
    print("wait for btn_navbar_save");
    await driver.waitFor(findSave);
    // todo bug for flutter
    sleep(Duration(milliseconds: 500));
    print("tapping btn_navbar_save");
    await driver.tap(findSave);
  }

  await screenshot(driver, screenshotConfig, 'people_overview');

  var pageBack = find.pageBack();
  if (await isPresent(pageBack, driver)) {
    await driver.tap(pageBack);
  }
}

Future _addReception(FlutterDriver driver, screenshotConfig) async {
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

Future _addContract(FlutterDriver driver, screenshotConfig) async {
  // go to Settings
  var tapBar = find.byValueKey('tab_bar_add');
  await driver.tap(tapBar);

  // tap on navbar add
  await driver.tap(find.byValueKey('navbar_btn_add'));

  await screenshot(driver, screenshotConfig, 'contract_edit_start');

  // choose photographer
  print('choosing photographer');
  await driver.tap(find.byValueKey('select_photographer'));
  await driver.tap(find.byValueKey('people_0'));

  // choose model
  print('choosing model');
  await driver.scrollUntilVisible(find.byType('SingleChildScrollView'), find.byValueKey('select_model') );
  await driver.tap(find.byValueKey('select_model'));
  await driver.tap(find.byValueKey('people_1'));

  // choose parent
  await driver.scrollUntilVisible(find.byType('SingleChildScrollView'), find.byValueKey('switch_parent') );
  await driver.tap(find.byValueKey('switch_parent'));
  await driver.scrollUntilVisible(find.byType('SingleChildScrollView'), find.byValueKey('select_parent') );
  await driver.tap(find.byValueKey('select_parent'));
  await driver.tap(find.byValueKey('people_2'));

  // choose witness
  await driver.scrollUntilVisible(find.byType('SingleChildScrollView'), find.byValueKey('switch_witness') );
  await driver.tap(find.byValueKey('switch_witness'));
  await driver.scrollUntilVisible(find.byType('SingleChildScrollView'), find.byValueKey('select_witness') );
  await driver.tap(find.byValueKey('select_witness'));
  await driver.tap(find.byValueKey('people_3'));

  // choose preset
  await driver.tap(find.byValueKey('btn_add_preset'));
  await driver.tap(find.byValueKey('preset_0'));

  // set date
  await driver.scrollUntilVisible(find.byType('SingleChildScrollView'), find.byValueKey('btn_select_date') );
  await driver.tap(find.byValueKey('btn_select_date'));
  await driver.scroll(find.byValueKey('datepicker'), 0, 400, Duration(milliseconds: 300));
  await driver.tap(find.byValueKey('btn_ok'));

  // set images count
  await driver.scrollUntilVisible(find.byType('SingleChildScrollView'), find.byValueKey('btn_set_images_count') );
  await driver.tap(find.byValueKey('btn_set_images_count'));
  await driver.scroll(find.byValueKey('image_count_picker'), 0, -200, Duration(milliseconds: 300));
  await driver.tap(find.byValueKey('btn_ok'));

  // set location
  await driver.scrollUntilVisible(find.byType('SingleChildScrollView'), find.byValueKey('tf_location') );
  await driver.tap( find.byValueKey('tf_location') );
  await driver.enterText('Düsseldorf');

  // set subject
  await driver.scrollUntilVisible(find.byType('SingleChildScrollView'), find.byValueKey('tf_subject') );
  await driver.tap( find.byValueKey('tf_subject') );
  await driver.enterText('Summershooting');

  // add reception areas
  await driver.scrollUntilVisible(find.byType('SingleChildScrollView'), find.byValueKey('btn_set_reception') );
  await driver.tap( find.byValueKey('btn_set_reception') );
  await driver.tap(find.byValueKey('reception_0'));
  await driver.tap( find.byValueKey('btn_set_reception') );
  await driver.tap(find.byValueKey('reception_1'));

  await screenshot(driver, screenshotConfig, 'contract_edit');

  // sign contract
  await driver.tap( find.byValueKey('btn_sign_contract') );

  await screenshot(driver, screenshotConfig, 'contract_signed');

  await driver.scrollUntilVisible(find.byType('SingleChildScrollView'), find.byValueKey('signature_model'));

  await screenshot(driver, screenshotConfig, 'contract_signatures');

  await isPresent(find.byValueKey('signature_photographer'), driver);

  // todo draw signature
  // await screenshot(driver, screenshotConfig, 'contract_signature_popup');

  var pageBack = find.pageBack();
  if (await isPresent(pageBack, driver)) {
    await driver.tap(pageBack);
    await driver.tap(pageBack);
  }

  await screenshot(driver, screenshotConfig, 'contract_list');
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

    // init screenshots map
    final screenshotConfig = Config();

    // Connect to the Flutter driver before running any tests
    setUpAll(() async {
      //final Map screenshotsEnv = await Config().screenshotsEnv;
      //screenshotsEnv.forEach((k, v) => print(k + " - " + v));

      driver = await FlutterDriver.connect();
    });

    // Close the connection to the driver after the tests have completed
    tearDownAll(() async {
      if (driver != null) {
        await driver.close();
      }
    });

    test('verifies create people', () async {
      await _addPerson(driver, screenshotConfig);
    }, timeout: Timeout.factor(4));

    test('verifies create preset', () async {
      await _addPreset(driver, screenshotConfig);
    }, timeout: Timeout.factor(3));

    test('verifies create receptions', () async {
      await _addReception(driver, screenshotConfig);
    }, timeout: Timeout.factor(2));


    test('verifies add contract', () async {
      await _addContract(driver, screenshotConfig);
    }, timeout: Timeout.factor(3));

  });
}
