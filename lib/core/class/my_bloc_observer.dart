import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';

class MyBlocObserver extends BlocObserver {
  @override
  void onChange(BlocBase bloc, Change change) {
    if (kDebugMode) {
      print(
        "current State ${change.currentState} /onC/ next State ${change.nextState}");
    }
    super.onChange(bloc, change);
  }

  @override
  void onCreate(BlocBase bloc) {
    if (kDebugMode) {
      print("${bloc.runtimeType} -- onCreate");
    }
    super.onCreate(bloc);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    if (kDebugMode) {
      print(
        "current State ${transition.currentState} /onT/ next State ${transition.nextState}");
    }
    super.onTransition(bloc, transition);
  }

  @override
  void onEvent(Bloc bloc, Object? event) {
    if (kDebugMode) {
      print("event: ${event.runtimeType}");
    }
    super.onEvent(bloc, event);
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    if (kDebugMode) {
      print("Error--${error.runtimeType} --- Trace--${stackTrace.runtimeType}");
    }
    super.onError(bloc, error, stackTrace);
  }

  @override
  void onClose(BlocBase bloc) {
    if (kDebugMode) {
      print("${bloc.runtimeType} -- is closing");
    }
    super.onClose(bloc);
  }
}
