import 'dart:ui' as ui;
import 'dart:io';

// https://github.com/ominibyte/flutter_device_type/blob/master/lib/flutter_device_type.dart
class DeviceCheck{
  static double devicePixelRatio = ui.window.devicePixelRatio;
  static ui.Size size = ui.window.physicalSize;
  static double width = size.width;
  static double height = size.height;
  static double screenWidth = width / devicePixelRatio;
  static double screenHeight = height / devicePixelRatio;
  static ui.Size screenSize = new ui.Size(screenWidth, screenHeight);
  final bool isTablet, isPhone, isIos, isAndroid, isIphoneX;
  static DeviceCheck _device;

  DeviceCheck({this.isTablet, this.isPhone, this.isIos, this.isAndroid, this.isIphoneX});

  factory DeviceCheck.get(){
    if( _device != null )
      return _device;

    bool isTablet;
    bool isPhone;
    bool isIos = Platform.isIOS;
    bool isAndroid = Platform.isAndroid;
    bool isIphoneX = false;

    if(devicePixelRatio < 2 && (width >= 1000 || height >= 1000)) {
      isTablet = true;
      isPhone = false;
    }
    else if(devicePixelRatio == 2 && (width >= 1920 || height >= 1920)) {
      isTablet = true;
      isPhone = false;
    }
    else {
      isTablet = false;
      isPhone = true;
    }

    if( isIos && (screenHeight == 812 || screenWidth == 812 || screenHeight == 896 || screenWidth == 896) )
      isIphoneX = true;

    return _device = new DeviceCheck(
        isTablet: isTablet,
        isPhone: isPhone,
        isAndroid: isAndroid,
        isIos: isIos,
        isIphoneX: isIphoneX
    );
  }
}
