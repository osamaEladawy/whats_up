import 'package:whats_app/feutures/user/domain/repositories/user_repository.dart';

class IsSignInUseCases{
  final UserRepository repository;

  IsSignInUseCases({required this.repository});

  Future<bool>call()async{
    return repository.isSignIn();
  }

}