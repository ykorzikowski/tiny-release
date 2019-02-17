// Imports the Flutter Driver API
import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';


void _gotoPeopleEdit(var driver) {
  // go to Settings
  var tapBar = find.byValueKey('tap_bar');
  driver.tap(tapBar);

  // tap on people
  var peopleControlItem = find.byValueKey('control_0');
  driver.tap(peopleControlItem);

  // tap on add people
  var addPeople = find.byValueKey('navbar_btn_add');
  driver.tap(addPeople);
}

void main() {
  group('People Scroll', () {
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

    var saveBtn = find.byValueKey('navbar_btn_save');
    var tfGivenName = find.byValueKey('tf_givenName');

    test('verifies people load', () async {
      // Create two SerializableFinders. We will use these to locate specific
      // Widgets displayed by the app. The names provided to the byValueKey
      // method correspond to the Keys we provided to our Widgets in step 1.
      final listFinder = find.byValueKey('long_list');
      final itemFinder = find.byValueKey('item_50_text');

      _gotoPeopleEdit(driver);



      //TODO: stub code copied from flutter.io.
      await driver.scrollUntilVisible(
        // Scroll through this list
        listFinder,
        // Until we find this item
        itemFinder,
        // In order to scroll down the list, we need to provide a negative
        // value to dyScroll. Ensure this value is a small enough increment to
        // scroll the item into view without potentially scrolling past it.
        //
        // If you need to scroll through horizontal lists, provide a dxScroll
        // argument instead
        dyScroll: -300.0,
      );

      // Verify the item contains the correct text
      expect(
        await driver.getText(itemFinder),
        'Item 50',
      );
    });
  });
}
