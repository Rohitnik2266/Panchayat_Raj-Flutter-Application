// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
        return macos;
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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBEKHER1hLFM9wVA6zrYsSbJQboxqqYkI4',
    appId: '1:819357841365:web:8129956b8eeb60d83fef5c',
    messagingSenderId: '819357841365',
    projectId: 'panchayat-raj-de3bf',
    authDomain: 'panchayat-raj-de3bf.firebaseapp.com',
    storageBucket: 'panchayat-raj-de3bf.firebasestorage.app',
    measurementId: 'G-E5CVBY4N6R',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCo1FrHmYMc5xyzHuKHpO5KHdriIa3DSPs',
    appId: '1:819357841365:android:13db313242cfaf9f3fef5c',
    messagingSenderId: '819357841365',
    projectId: 'panchayat-raj-de3bf',
    storageBucket: 'panchayat-raj-de3bf.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDi9AVAR5sunUl1YYTU0xuXmy85cPhTZvo',
    appId: '1:819357841365:ios:498c0470b7205bc23fef5c',
    messagingSenderId: '819357841365',
    projectId: 'panchayat-raj-de3bf',
    storageBucket: 'panchayat-raj-de3bf.firebasestorage.app',
    iosBundleId: 'com.example.panchayatRaj',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDi9AVAR5sunUl1YYTU0xuXmy85cPhTZvo',
    appId: '1:819357841365:ios:498c0470b7205bc23fef5c',
    messagingSenderId: '819357841365',
    projectId: 'panchayat-raj-de3bf',
    storageBucket: 'panchayat-raj-de3bf.firebasestorage.app',
    iosBundleId: 'com.example.panchayatRaj',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBEKHER1hLFM9wVA6zrYsSbJQboxqqYkI4',
    appId: '1:819357841365:web:0500e5d7974047763fef5c',
    messagingSenderId: '819357841365',
    projectId: 'panchayat-raj-de3bf',
    authDomain: 'panchayat-raj-de3bf.firebaseapp.com',
    storageBucket: 'panchayat-raj-de3bf.firebasestorage.app',
    measurementId: 'G-BX36810HSG',
  );
}
