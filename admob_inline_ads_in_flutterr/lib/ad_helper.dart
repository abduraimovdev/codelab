import 'dart:io';

class AdHelper {

  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-5901980579105624/2988899147";
    } else if (Platform.isIOS) {
      return "ca-app-pub-5901980579105624/8321116873";
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }

  static String get nativeAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-5901980579105624/3918837430";
    } else if (Platform.isIOS) {
      return "ca-app-pub-5901980579105624/4162418005";
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }
}