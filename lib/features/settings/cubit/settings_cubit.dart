import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whats_up/my_app.dart';

part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit() : super(SettingsInitial());
  static final SettingsCubit _settingsCubit =
      BlocProvider.of(navigatorKey.currentContext!);

  static SettingsCubit get instance => _settingsCubit;
}
