import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:whats_app/feutures/app/class/handle_image.dart';
import 'package:whats_app/feutures/user/presentation/manager/auth/auth_cubit.dart';
import 'package:whats_app/feutures/user/presentation/manager/cerdential/credential_cubit.dart';
import 'package:whats_app/feutures/user/presentation/manager/get_device_number/get_device_number_cubit.dart';
import 'package:whats_app/feutures/user/presentation/manager/get_single_user/get_single_user_cubit.dart';
import 'package:whats_app/feutures/user/presentation/manager/user/user_cubit.dart';
import 'package:whats_app/routes/on_generate_routes.dart';
import 'package:whats_app/feutures/theme/style.dart';
import 'package:whats_app/storage/storage_provider.dart';
import 'package:whats_app/views/home/home_page.dart';
import 'package:whats_app/views/splash/splash.dart';
import 'feutures/calls/presentation/manager/agora/agora_cubit.dart';
import 'feutures/calls/presentation/manager/call/call_cubit.dart';
import 'feutures/calls/presentation/manager/my_call/my_call_history_cubit.dart';
import 'feutures/chat/presentation/manager/chat/chat_cubit.dart';
import 'feutures/chat/presentation/manager/message/message_cubit.dart';
import 'feutures/status/presentation/manager/get_my_status/get_my_status_cubit.dart';
import 'feutures/status/presentation/manager/status/status_cubit.dart';
import 'main_injection_container.dart' as di;


Future<void> main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: "AIzaSyBUBB0FgafM1tWnlZsred8Q5dA87_8i5us",
        appId: "1:2874420508:android:e1ee4b726fe29a96015ed9",
        messagingSenderId: "2874420508",
        projectId: "whatsapp-2ce4e",
        storageBucket: "whatsapp-2ce4e.appspot.com"),
  );
  await di.init();
  return runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => HandleImage()),
        ChangeNotifierProvider(
            create: (context) => StorageProviderRemoteDataSource()),
        BlocProvider(create: (context) => di.sl<AuthCubit>()..appStarted()),
        BlocProvider(create: (context) => di.sl<CredentialCubit>()),
        BlocProvider(create: (context) => di.sl<GetSingleUserCubit>()),
        BlocProvider(create: (context) => di.sl<UserCubit>()),
        BlocProvider(create: (context) => di.sl<GetDeviceNumberCubit>()),
        BlocProvider(
          create: (context) => di.sl<ChatCubit>(),
        ),
        BlocProvider(
          create: (context) => di.sl<MessageCubit>(),
        ),
        BlocProvider(
          create: (context) => di.sl<StatusCubit>(),
        ),
        BlocProvider(
          create: (context) => di.sl<GetMyStatusCubit>(),
        ),
        BlocProvider(
          create: (context) => di.sl<CallCubit>(),
        ),
        BlocProvider(
          create: (context) => di.sl<MyCallHistoryCubit>(),
        ),
        BlocProvider(
          create: (context) => di.sl<AgoraCubit>(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      useInheritedMediaQuery: true,
      theme: ThemeData.dark().copyWith(
        colorScheme: ColorScheme.fromSeed(
            seedColor: tabColor, brightness: Brightness.dark),
        scaffoldBackgroundColor: backgroundColor,
        dialogBackgroundColor: appBarColor,
        appBarTheme: const AppBarTheme(
          color: appBarColor,
        ),
      ),
      initialRoute: "/",
      onGenerateRoute: OnGenerateRoute.route,
      routes: {
        "/": (context) {
          return BlocBuilder<AuthCubit, AuthState>(
              builder: (context, authState) {
            if (authState is Authenticated) {
              return HomePage(uid: authState.userUid);
            }
            return const SplashScreen();
          });
        }
      },
    );
  }
}
