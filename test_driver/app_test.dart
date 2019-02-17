// Imports the Flutter Driver API
import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

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

    test('verifies people load', () async {
      // Create two SerializableFinders. We will use these to locate specific
      // Widgets displayed by the app. The names provided to the byValueKey
      // method correspond to the Keys we provided to our Widgets in step 1.
      final listFinder = find.byValueKey('long_list');
      final itemFinder = find.byValueKey('item_50_text');

      // go to Settings
      var tapBar = find.byValueKey('tap_bar');
      driver.tap(tapBar);

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
