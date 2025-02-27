import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
    apiKey: 'AIzaSyD8nhmwja8CMcyJnIIJNRuzAWO8iW0vNbo',
    appId: '1:810598022076:android:a20bbc27d0e678ea2949b9',
    messagingSenderId: '810598022076',
    projectId: 'engineering-thesis-66bd4',
    storageBucket: 'engineering-thesis-66bd4.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDq-IAvaM7ScOkfWbtoudgRi_uDlBfjUQk',
    appId: '1:810598022076:ios:a1256ad524c29a632949b9',
    messagingSenderId: '810598022076',
    projectId: 'engineering-thesis-66bd4',
    storageBucket: 'engineering-thesis-66bd4.firebasestorage.app',
    iosBundleId: 'com.example.mobileApp',
  );
}
