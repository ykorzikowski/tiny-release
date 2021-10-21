# tinyrelease

project is not longer maintained! (21.10.2021)

create model releases

[![Build Status](https://drone.korzikowski.de/api/badges/ykorzikowski/paperflavor/status.svg)](https://drone.korzikowski.de/ykorzikowski/paperflavor)

## After checkout
```
flutter upgrade
flutter doctor
fastlane update_fastlane 
```
T
## Generate l10n
Managed by https://github.com/long1eu/flutter_i18n
For iOS, edit Info.plist when adding a new language

## git tagging
### testflight
There is a branch called `testflight`. This branch contains an old master which is safe for a testflight release. 
This branch should not diverge from master. 
```
git checkout testflight
git pull --rebase origin/master
```

### release
Release versions will get a tag. 
```
git tag -a v1.0
```

## prepare release

### prepare meta
```
# generate screenshots & upload meta
fastlane screenshots
fastlane meta

fastlane android release
fastlane ios release
```

## manual

## update icon
```
flutter packages get
flutter packages pub run flutter_launcher_icons:main
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
Ttests stored in `test_driver`dir. Can be run by command `flutter drive --target=test_driver/app_full.dart -dEngi`
