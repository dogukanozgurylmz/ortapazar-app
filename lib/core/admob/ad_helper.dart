import 'dart:io';

class AdHelper {
  static String get nativeAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-5873934691119930/1023326803";
    } else {
      throw UnsupportedError("Unsupported Platform");
    }
  }

  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-5873934691119930/7791953128";
    } else {
      throw UnsupportedError("Unsupported Platform");
    }
  }
}
