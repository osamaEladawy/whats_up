import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'wellcome_state.dart';

class WellcomeCubit extends Cubit<WellcomeState> {
  WellcomeCubit() : super(WellcomeInitial());
}
