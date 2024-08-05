import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/entities/contact_entity.dart';
import '../../../domain/use_cases/user/get_device_number_usecases.dart';

part 'get_device_number_state.dart';

class GetDeviceNumberCubit extends Cubit<GetDeviceNumberState> {

  final GetDeviceNumberUseCases getDeviceNumberUseCases;
  GetDeviceNumberCubit({
    required this.getDeviceNumberUseCases,
}) : super(GetDeviceNumberInitial());


  Future<void>getDeviceNumber()async{
    try{
      final contactNumbers=await getDeviceNumberUseCases.call();
      emit(GetDeviceNumberLoaded(contacts: contactNumbers));
    }catch(_){
      emit(GetDeviceNumberFailure());
    }
  }




}
