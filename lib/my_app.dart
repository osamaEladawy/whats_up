import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:whats_up/core/providers/handle_image.dart';
import 'package:whats_up/core/providers/storage_provider.dart';
import 'package:whats_up/core/theme/style.dart';
import 'package:whats_up/features/home/screens/home_page.dart';
import 'package:whats_up/features/user/presentation/manager/auth/auth_cubit.dart';
import 'package:whats_up/core/routes/on_generate_routes.dart';
import 'package:whats_up/features/user/presentation/manager/cerdential/credential_cubit.dart';
import 'package:whats_up/features/user/presentation/manager/get_device_number/get_device_number_cubit.dart';
import 'package:whats_up/features/user/presentation/manager/get_single_user/get_single_user_cubit.dart';
import 'package:whats_up/features/user/presentation/manager/user/user_cubit.dart';
import 'package:whats_up/features/splash/screens/splash.dart';
import 'main_injection_container.dart' as di;
import 'features/calls/presentation/manager/agora/agora_cubit.dart';
import 'features/calls/presentation/manager/call/call_cubit.dart';
import 'features/calls/presentation/manager/my_call/my_call_history_cubit.dart';
import 'features/chat/presentation/manager/chat/chat_cubit.dart';
import 'features/chat/presentation/manager/message/message_cubit.dart';
import 'features/status/presentation/manager/get_my_status/get_my_status_cubit.dart';
import 'features/status/presentation/manager/status/status_cubit.dart';

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => HandleImage()),
        ChangeNotifierProvider(
            create: (context) => StorageProviderRemoteDataSource()),
        BlocProvider(create: (context) => di.sl<AuthCubit>()..appStarted()),
        BlocProvider(create: (context) => di.sl<CredentialCubit>()),
        BlocProvider(create: (context) => di.sl<GetSingleUserCubit>()),
        BlocProvider(create: (context) => di.sl<UserCubit>()),
        BlocProvider(create: (context) => di.sl<GetDeviceNumberCubit>()),
        BlocProvider(create: (context) => di.sl<ChatCubit>()),
        BlocProvider(create: (context) => di.sl<MessageCubit>()),
        BlocProvider(create: (context) => di.sl<StatusCubit>()),
        BlocProvider(create: (context) => di.sl<GetMyStatusCubit>()),
        BlocProvider(create: (context) => di.sl<CallCubit>()),
        BlocProvider(create: (context) => di.sl<MyCallHistoryCubit>()),
        BlocProvider(create: (context) => di.sl<AgoraCubit>()),
      ],
      child: ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (_, child) {
          return MaterialApp(
            navigatorKey: navigatorKey,
            debugShowCheckedModeBanner: false,
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            theme: ThemeData.dark().copyWith(
              colorScheme: ColorScheme.fromSeed(
                  seedColor: tabColor, brightness: Brightness.dark),
              scaffoldBackgroundColor: backgroundColor,
              dialogBackgroundColor: appBarColor,
              appBarTheme: const AppBarTheme(color: appBarColor),
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
            home: child,
          );
        },
        //child: SplashScreen(),
      ),
    );
  }
}
