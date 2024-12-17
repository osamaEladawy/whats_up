part of 'credential_cubit.dart';

sealed class CredentialState extends Equatable {
  const CredentialState();

   @override
  List<Object> get props => [];
}

final class CredentialInitial extends CredentialState {
  @override
  List<Object> get props => [];
}
final class CredentialLoading extends CredentialState {
  @override
  List<Object> get props => [];
}
final class CredentialSuccess extends CredentialState {
  @override
  List<Object> get props => [];
}
final class CredentialPhoneAuthSmsCodeReceived extends CredentialState {
  @override
  List<Object> get props => [];
}
final class CredentialPhoneAuthProfileInfo extends CredentialState {
  @override
  List<Object> get props => [];
}
final class CredentialFailure extends CredentialState {
 
}

final class SelectCountry extends CredentialState{}
final class SelectCountryCode extends CredentialState{}