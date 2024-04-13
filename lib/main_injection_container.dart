
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';

import 'feutures/calls/call_injection_container.dart';
import 'feutures/chat/chat_injection_container.dart';
import 'feutures/status/status_injection_container.dart';
import 'feutures/user/user_injection_container.dart';

final sl = GetIt.instance;

Future<void> init() async {

  final auth = FirebaseAuth.instance;
  final fireStore = FirebaseFirestore.instance;

  sl.registerLazySingleton(() => auth);
  sl.registerLazySingleton(() => fireStore);
  

   await userInjectionContainer();
   await chatInjectionContainer();
   await statusInjectionContainer();
   await callInjectionContainer();

}