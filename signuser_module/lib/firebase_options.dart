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
        return macos;
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
    apiKey: 'AIzaSyBXskPUmlA00OGbuftJsrsgGf02ykpMALQ',
    appId: '1:757087137413:web:b3697c711d4fcd221943ec',
    messagingSenderId: '757087137413',
    projectId: 'signuser',
    authDomain: 'signuser.firebaseapp.com',
    storageBucket: 'signuser.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB-UWewt6CutGdoi1xh1SgaV4GqS6aAw2c',
    appId: '1:757087137413:android:e613603f3edd31d31943ec',
    messagingSenderId: '757087137413',
    projectId: 'signuser',
    storageBucket: 'signuser.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBH2mzNxR4_BpSClhRbE-4lDCK9Cl9T1wI',
    appId: '1:757087137413:ios:00b118f19fba66371943ec',
    messagingSenderId: '757087137413',
    projectId: 'signuser',
    storageBucket: 'signuser.appspot.com',
    iosClientId: '757087137413-lmdnjeb2ppr2p3edamj3m51jt1rgred6.apps.googleusercontent.com',
    iosBundleId: 'com.tommy.signuserModule',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBH2mzNxR4_BpSClhRbE-4lDCK9Cl9T1wI',
    appId: '1:757087137413:ios:00b118f19fba66371943ec',
    messagingSenderId: '757087137413',
    projectId: 'signuser',
    storageBucket: 'signuser.appspot.com',
    iosClientId: '757087137413-lmdnjeb2ppr2p3edamj3m51jt1rgred6.apps.googleusercontent.com',
    iosBundleId: 'com.tommy.signuserModule',
  );
}
