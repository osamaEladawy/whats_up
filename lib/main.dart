import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whats_up/core/class/my_bloc_observer.dart';
import 'package:whats_up/core/storage/pref_services.dart';
import 'package:whats_up/my_app.dart';
import 'package:whats_up/core/services/my_service.dart';
import 'package:whats_up/translations/codegen_loader.g.dart';
import 'main_injection_container.dart' as di;

Future<void> main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await MyService().initializeApp();
  await PrefServices.init();
  Bloc.observer = MyBlocObserver();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await di.init();
  return runApp(
    EasyLocalization(
      supportedLocales: [
        Locale('en'),
        Locale('ar'),
      ],
      path: 'assets/translations',
      fallbackLocale: Locale('ar'),
      startLocale: Locale("en"),
      assetLoader: const CodegenLoader(),
      child: const MyApp(),
    ),
  );
}
