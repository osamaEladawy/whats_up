
import '../../repositories/user_repository.dart';

class VerifyPhoneNumberUseCases{
  final UserRepository repository;

  VerifyPhoneNumberUseCases({required this.repository});

  Future<void>call(String phoneNumber)async{
    return repository.verifyPhoneNumber(phoneNumber);
  }
}