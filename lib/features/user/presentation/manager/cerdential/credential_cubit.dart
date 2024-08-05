import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/entities/user_entity.dart';
import '../../../domain/use_cases/credential/sign_in_with_phone_number_usecases.dart';
import '../../../domain/use_cases/credential/verify_phone_number_usecases.dart';
import '../../../domain/use_cases/user/create_user_usecases.dart';

part 'credential_state.dart';

class CredentialCubit extends Cubit<CredentialState> {
  final SignInWithPhoneNumberUseCases signInUseCases;
  final VerifyPhoneNumberUseCases verifyWithPhoneNumberUseCases;
  final CreateUserUseCases createUserUseCases;

  CredentialCubit({
    required this.createUserUseCases,
    required this.signInUseCases,
    required this.verifyWithPhoneNumberUseCases
}) : super(CredentialInitial());

  Future<void>submitVerifyPhoneNumber({required String phoneNumber})async{
    try {
      await verifyWithPhoneNumberUseCases.call(phoneNumber);
      emit(CredentialPhoneAuthSmsCodeReceived());
    } on SocketException catch (_) {
      emit(CredentialFailure());
    } catch (_) {
      emit(CredentialFailure());
    }
  }

  Future<void>submitSmsCode({required String smsPinCode})async{
    try {
      await signInUseCases.call(smsPinCode);
      emit(CredentialPhoneAuthProfileInfo());
    } on SocketException catch (_) {
      emit(CredentialFailure());
    } catch (_) {
      emit(CredentialFailure());
    }
  }


  Future<void>submitProfileInfo({required UserEntity userEntity})async{
    try {
      await createUserUseCases.call(userEntity);
      emit(CredentialSuccess());
    } on SocketException catch (_) {
      emit(CredentialFailure());
    } catch (_) {
      emit(CredentialFailure());
    }
  }







}
