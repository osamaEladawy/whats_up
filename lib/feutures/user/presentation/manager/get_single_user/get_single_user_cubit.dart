import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:whats_app/feutures/user/domain/entities/user_entity.dart';
import 'package:whats_app/feutures/user/domain/use_cases/user/get_single_user_usecases.dart';

part 'get_single_user_state.dart';

class GetSingleUserCubit extends Cubit<GetSingleUserState> {
  final GetSingleUserUseCases getSingleUserUseCases;
  GetSingleUserCubit({
    required this.getSingleUserUseCases,
}) : super(GetSingleUserInitial());

  Future<void>getSingleUser({required String userId})async {
    emit(GetSingleUserLoading());
    final streamResponse = await getSingleUserUseCases.call(userId);
    streamResponse.listen((userEntity) {
      emit(GetSingleUserLoaded(userEntity: userEntity.first));
    });
  }

}
