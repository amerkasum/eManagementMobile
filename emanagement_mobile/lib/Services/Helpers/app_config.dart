import 'package:flutter/foundation.dart';

class AppConfig {
  static String get apiUrl {
    if (kIsWeb) {
      return 'http://localhost:5001';
    }

    if (defaultTargetPlatform == TargetPlatform.android) {
      return 'https://10.0.2.2:5001';
    }

    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return 'http://localhost:5001';
    }

    //final isDesktop = !Platform.isAndroid && (Platform.isWindows || Platform.isMacOS || Platform.isLinux);


    if (defaultTargetPlatform == TargetPlatform.windows ||
        defaultTargetPlatform == TargetPlatform.macOS ||
        defaultTargetPlatform == TargetPlatform.linux) {
      return 'http://localhost:5001';
    }

    return 'http://localhost:5001';
  }
}
