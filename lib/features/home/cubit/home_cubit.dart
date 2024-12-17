import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whats_up/my_app.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  static final HomeCubit _homeCubit =
      BlocProvider.of(navigatorKey.currentContext!);

  static HomeCubit get instance => _homeCubit;
}
