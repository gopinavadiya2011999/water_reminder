// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
      return web;
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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyD-NDm8ZhAwSeJDZxHRk9CbEseqyz_p9tA',
    appId: '1:627764711712:web:90a0a7d72a252e8742c745',
    messagingSenderId: '627764711712',
    projectId: 'water-reminder-de51d',
    authDomain: 'water-reminder-de51d.firebaseapp.com',
    storageBucket: 'water-reminder-de51d.appspot.com',
    measurementId: 'G-W3QV9KS3F3',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBFayW5-Q-a6YsxPTpsjKlDLKOdj0kWgBQ',
    appId: '1:627764711712:android:2066c8c8fbf3288242c745',
    messagingSenderId: '627764711712',
    projectId: 'water-reminder-de51d',
    storageBucket: 'water-reminder-de51d.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAw-OEIKFsXbYAlTEpMSS6So2_ucmjXIy4',
    appId: '1:627764711712:ios:62304f532ea5bbe242c745',
    messagingSenderId: '627764711712',
    projectId: 'water-reminder-de51d',
    storageBucket: 'water-reminder-de51d.appspot.com',
    iosClientId:
    '627764711712-ge3nnvu4l0jucehk0us9urrrqadqs1q9.apps.googleusercontent.com',
    iosBundleId: 'com.example.waterReminder',
  );
}