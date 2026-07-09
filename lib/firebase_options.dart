import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;
import 'core/config/env_config.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return ios;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static FirebaseOptions get web => FirebaseOptions(
        apiKey: 'AIzaSyDummyWebKeyForDevelopmentAndTesting123',
        appId: '1:1234567890:web:abcdef123456',
        messagingSenderId: '1234567890',
        projectId: EnvConfig.instance.firebaseProjectId,
        authDomain: '${EnvConfig.instance.firebaseProjectId}.firebaseapp.com',
        storageBucket: '${EnvConfig.instance.firebaseProjectId}.appspot.com',
      );

  static FirebaseOptions get android => FirebaseOptions(
        apiKey: 'AIzaSyDummyAndroidKeyForDevelopmentAndTesting123',
        appId: '1:1234567890:android:abcdef123456',
        messagingSenderId: '1234567890',
        projectId: EnvConfig.instance.firebaseProjectId,
        storageBucket: '${EnvConfig.instance.firebaseProjectId}.appspot.com',
      );

  static FirebaseOptions get ios => FirebaseOptions(
        apiKey: 'AIzaSyDummyIosKeyForDevelopmentAndTesting123',
        appId: '1:1234567890:ios:abcdef123456',
        messagingSenderId: '1234567890',
        projectId: EnvConfig.instance.firebaseProjectId,
        storageBucket: '${EnvConfig.instance.firebaseProjectId}.appspot.com',
        iosBundleId: 'com.kumbh.navigator.nashikKumbhNavigator',
      );

  static FirebaseOptions get windows => FirebaseOptions(
        apiKey: 'AIzaSyDummyWindowsKeyForDevelopmentAndTesting123',
        appId: '1:1234567890:web:abcdef123456',
        messagingSenderId: '1234567890',
        projectId: EnvConfig.instance.firebaseProjectId,
        authDomain: '${EnvConfig.instance.firebaseProjectId}.firebaseapp.com',
        storageBucket: '${EnvConfig.instance.firebaseProjectId}.appspot.com',
      );
}
