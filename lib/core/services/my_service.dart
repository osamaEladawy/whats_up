import 'package:firebase_core/firebase_core.dart';

class MyService {
  Future<MyService> init() async {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyBUBB0FgafM1tWnlZsred8Q5dA87_8i5us",
          appId: "1:2874420508:android:e1ee4b726fe29a96015ed9",
          messagingSenderId: "2874420508",
          projectId: "whatsapp-2ce4e",
          storageBucket: "whatsapp-2ce4e.appspot.com"),
    );
    return this;
  }

  Future initializeApp() async {
    return await MyService().init();
  }
}
