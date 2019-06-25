enum Environment { WHITELABEL, MODEL, WRITER }

class Constants {
  static Map<String, dynamic> _config;
  static const WHITELABEL = "whitelabel";
  static const MODEL = "model";
  static const WRITER = "writer";

  static void setEnvironment(Environment env) {
    switch (env) {
      case Environment.WHITELABEL:
        _config = _Config.whitelabelConstants;
        break;
      case Environment.MODEL:
        _config = _Config.modelConstants;
        break;
      case Environment.WRITER:
        _config = _Config.writerConstants;
        break;
    }
  }

  static get APP_FLAVOR {
    return _config[_Config.APP_FLAVOR];
  }
}

class _Config {
  static const APP_FLAVOR = "APP_FLAVOR";

  static Map<String, dynamic> whitelabelConstants = {
    APP_FLAVOR: Constants.WHITELABEL,
  };

  static Map<String, dynamic> modelConstants = {
    APP_FLAVOR: Constants.MODEL,
  };

  static Map<String, dynamic> writerConstants = {
    APP_FLAVOR: Constants.WRITER,
  };
}