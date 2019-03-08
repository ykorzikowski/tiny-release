# tiny_release

create model releases

## Generate l10n
Managed by https://github.com/long1eu/flutter_i18n
For iOS, edit Info.plist when adding a new language

## releasing
```
# generate screenshots
fastlane screenshots

fastlane android release
fastlane ios release
```

## manual
### deliver ios meta + screenshots
```
# ios
cd ios

# commit screenshots and metadata
fastlane deliver

```

## testing
### screenshots
```
# install dart sdk
brew tap dart-lang/dart
brew install dart

# install screenshots
pub global activate screenshots
brew update && brew install imagemagick

```

### android simulator
```
# java 8 only :(
export JAVA_HOME=$(/usr/libexec/java_home -v 1.8) 

brew cask install intel-haxm
brew install qt
brew cask install android-sdk
sdkmanager --update
sdkmanager "platform-tools" "platforms;android-27" "extras;intel;Hardware_Accelerated_Execution_Manager" "build-tools;27.0.0" "system-images;android-27;google_apis;x86" "emulator"export ANDROID_SDK_ROOT="/usr/local/share/android-sdk"
avdmanager create avd -n test -k "system-images;android-27;google_apis;x86"
/usr/local/share/android-sdk/tools/emulator -avd test

```

### flutter driver
tests stored in `test_driver`dir. Can be run by command `flutter drive --target=test_driver/app.dart`