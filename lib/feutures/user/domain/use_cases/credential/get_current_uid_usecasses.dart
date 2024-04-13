import 'package:whats_app/feutures/user/domain/repositories/user_repository.dart';

class GetCurrentUidUseCases{
  final UserRepository repository;

  GetCurrentUidUseCases({required this.repository});

  Future<String>call()async{
    return repository.getCurrentUid();
  }

}