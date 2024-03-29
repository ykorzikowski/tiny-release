fastlane documentation
================
# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```
xcode-select --install
```

Install _fastlane_ using
```
[sudo] gem install fastlane -NV
```
or alternatively using `brew cask install fastlane`

# Available Actions
### meta
```
fastlane meta
```

### screenshots
```
fastlane screenshots
```


----

## Android
### android testing
```
fastlane android testing
```
Deploy a new version to the Google Play Alpha
### android release
```
fastlane android release
```
Deploy a new version to the Google Play Production

----

## iOS
### ios testing
```
fastlane ios testing
```
Push a new beta build to TestFlight
### ios release
```
fastlane ios release
```
Push a new release build to the App Store

----

This README.md is auto-generated and will be re-generated every time [fastlane](https://fastlane.tools) is run.
More information about fastlane can be found on [fastlane.tools](https://fastlane.tools).
The documentation of fastlane can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
