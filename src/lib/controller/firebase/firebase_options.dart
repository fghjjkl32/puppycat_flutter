// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBmdFKCBhurDbjj5p6wA6eAQBskNjDmIAg',
    appId: '1:14263543464:android:b52833d47506d509a9c49d',
    messagingSenderId: '14263543464',
    projectId: 'prd-puppycat',
    storageBucket: 'prd-puppycat.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC26GO3vDuyAfgEF8C9jW2ikP8kum_QFPQ',
    appId: '1:14263543464:ios:6a62a6702e40cdcaa9c49d',
    messagingSenderId: '14263543464',
    projectId: 'prd-puppycat',
    storageBucket: 'prd-puppycat.appspot.com',
    androidClientId: '14263543464-775u5si0ocp1mest7qch552uak2rj7g1.apps.googleusercontent.com',
    iosClientId: '14263543464-a7s7l6h3d68vatmij33ddooqn8qt26pl.apps.googleusercontent.com',
    iosBundleId: 'com.uxp.puppycat',
  );
}
