
import '../../repositories/user_repository.dart';

class SignInWithPhoneNumberUseCases{
  final UserRepository repository;

  SignInWithPhoneNumberUseCases({required this.repository});


  Future<void>call(String smsPinCode)async{
    return repository.signInWithPhoneNumber(smsPinCode);
  }
}